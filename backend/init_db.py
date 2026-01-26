#!/usr/bin/env python3
"""Script to initialize the database for testing"""

import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'app'))

from app.infrastructure.database import engine, create_tables

if __name__ == "__main__":
    print("Creating database tables...")
    create_tables()
    print("Database tables created successfully!")