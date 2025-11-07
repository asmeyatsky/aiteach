import os
import logging
from datetime import datetime
from sqlalchemy import text, MetaData
from app.database import engine, Base

logger = logging.getLogger(__name__)

class DatabaseMigration:
    """Simple database migration system"""

    def __init__(self):
        self.migrations = []

    def register_migration(self, version: str, description: str, up_sql: str, down_sql: str = None):
        """Register a new migration"""
        self.migrations.append({
            'version': version,
            'description': description,
            'up_sql': up_sql,
            'down_sql': down_sql,
            'applied_at': None
        })

    def create_migration_table(self):
        """Create the migrations table if it doesn't exist"""
        with engine.connect() as conn:
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS schema_migrations (
                    version VARCHAR(255) PRIMARY KEY,
                    description TEXT,
                    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """))
            conn.commit()

    def get_applied_migrations(self):
        """Get list of applied migrations"""
        with engine.connect() as conn:
            result = conn.execute(text("SELECT version FROM schema_migrations ORDER BY version"))
            return [row[0] for row in result]

    def apply_migrations(self):
        """Apply all pending migrations"""
        self.create_migration_table()
        applied = self.get_applied_migrations()

        for migration in sorted(self.migrations, key=lambda x: x['version']):
            if migration['version'] not in applied:
                logger.info(f"Applying migration {migration['version']}: {migration['description']}")

                try:
                    with engine.connect() as conn:
                        # Execute migration SQL
                        conn.execute(text(migration['up_sql']))

                        # Record migration
                        conn.execute(text("""
                            INSERT INTO schema_migrations (version, description)
                            VALUES (:version, :description)
                        """), {
                            'version': migration['version'],
                            'description': migration['description']
                        })
                        conn.commit()

                    logger.info(f"Migration {migration['version']} applied successfully")

                except Exception as e:
                    logger.error(f"Failed to apply migration {migration['version']}: {e}")
                    raise

    def rollback_migration(self, version: str):
        """Rollback a specific migration"""
        migration = next((m for m in self.migrations if m['version'] == version), None)

        if not migration:
            raise ValueError(f"Migration {version} not found")

        if not migration['down_sql']:
            raise ValueError(f"Migration {version} has no rollback SQL")

        try:
            with engine.connect() as conn:
                conn.execute(text(migration['down_sql']))
                conn.execute(text("DELETE FROM schema_migrations WHERE version = :version"),
                           {'version': version})
                conn.commit()

            logger.info(f"Migration {version} rolled back successfully")

        except Exception as e:
            logger.error(f"Failed to rollback migration {version}: {e}")
            raise

# Initialize migration system
migration_system = DatabaseMigration()

# Register initial migrations
migration_system.register_migration(
    version="001_create_indexes",
    description="Add database indexes for performance",
    up_sql="""
    -- Add indexes for users table
    CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
    CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
    CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

    -- Add indexes for courses table
    CREATE INDEX IF NOT EXISTS idx_courses_level ON courses(level);
    CREATE INDEX IF NOT EXISTS idx_courses_created_at ON courses(created_at);

    -- Add indexes for user_progress table
    CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
    CREATE INDEX IF NOT EXISTS idx_user_progress_course_id ON user_progress(course_id);

    -- Add indexes for forum_posts table
    CREATE INDEX IF NOT EXISTS idx_forum_posts_user_id ON forum_posts(user_id);
    CREATE INDEX IF NOT EXISTS idx_forum_posts_created_at ON forum_posts(created_at);
    """,
    down_sql="""
    DROP INDEX IF EXISTS idx_users_email;
    DROP INDEX IF EXISTS idx_users_username;
    DROP INDEX IF EXISTS idx_users_created_at;
    DROP INDEX IF EXISTS idx_courses_level;
    DROP INDEX IF EXISTS idx_courses_created_at;
    DROP INDEX IF EXISTS idx_user_progress_user_id;
    DROP INDEX IF EXISTS idx_user_progress_course_id;
    DROP INDEX IF EXISTS idx_forum_posts_user_id;
    DROP INDEX IF EXISTS idx_forum_posts_created_at;
    """
)

migration_system.register_migration(
    version="002_add_audit_fields",
    description="Add audit fields to tables",
    up_sql="""
    -- Add updated_at columns where missing
    ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE courses ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

    -- Create triggers to auto-update updated_at
    CREATE OR REPLACE FUNCTION update_modified_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = now();
        RETURN NEW;
    END;
    $$ language 'plpgsql';

    DROP TRIGGER IF EXISTS update_users_modtime ON users;
    CREATE TRIGGER update_users_modtime BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_modified_column();

    DROP TRIGGER IF EXISTS update_courses_modtime ON courses;
    CREATE TRIGGER update_courses_modtime BEFORE UPDATE ON courses FOR EACH ROW EXECUTE FUNCTION update_modified_column();

    DROP TRIGGER IF EXISTS update_forum_posts_modtime ON forum_posts;
    CREATE TRIGGER update_forum_posts_modtime BEFORE UPDATE ON forum_posts FOR EACH ROW EXECUTE FUNCTION update_modified_column();
    """,
    down_sql="""
    DROP TRIGGER IF EXISTS update_users_modtime ON users;
    DROP TRIGGER IF EXISTS update_courses_modtime ON courses;
    DROP TRIGGER IF EXISTS update_forum_posts_modtime ON forum_posts;
    DROP FUNCTION IF EXISTS update_modified_column();

    ALTER TABLE users DROP COLUMN IF EXISTS updated_at;
    ALTER TABLE courses DROP COLUMN IF EXISTS updated_at;
    ALTER TABLE forum_posts DROP COLUMN IF EXISTS updated_at;
    """
)

def run_migrations():
    """Run all pending migrations"""
    logger.info("Starting database migrations...")
    migration_system.apply_migrations()
    logger.info("Database migrations completed")

def rollback_to_version(version: str):
    """Rollback to a specific migration version"""
    logger.info(f"Rolling back to migration version {version}...")
    migration_system.rollback_migration(version)
    logger.info(f"Rollback to version {version} completed")