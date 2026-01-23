# Technical Implementation Plan

This document provides a detailed technical plan for implementing the new features specified in `FEATURES_SPECIFICATION.md`.

---

## 1. Database Schema

The following new tables need to be added to the database. The SQL is written for PostgreSQL.

```sql
-- Enum types for new fields
CREATE TYPE project_difficulty AS ENUM ('easy', 'medium', 'hard');
CREATE TYPE user_project_status AS ENUM ('not_started', 'in_progress', 'completed');
CREATE TYPE suggested_content_status AS ENUM ('pending', 'approved', 'rejected');

-- Table for Project-Based Learning
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    track VARCHAR(50) NOT NULL, -- Corresponds to the Track enum: user, builder, innovator
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    starter_code_url VARCHAR(255),
    difficulty project_difficulty NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Join table for user progress on projects
CREATE TABLE user_projects (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    status user_project_status NOT NULL DEFAULT 'not_started',
    submission_url VARCHAR(255),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, project_id)
);

-- Table for the "What's New in AI" Feed
CREATE TABLE feed_items (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    source_name VARCHAR(100) NOT NULL,
    original_url VARCHAR(512) NOT NULL UNIQUE,
    summary TEXT NOT NULL,
    published_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table for community content suggestions
CREATE TABLE suggested_content (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    url VARCHAR(512) NOT NULL,
    comment TEXT,
    suggested_track VARCHAR(50) NOT NULL, -- Corresponds to the Track enum
    status suggested_content_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

```
**Action:** These SQL commands need to be integrated into the project's migration system. Since one doesn't seem to exist, a new migration script will need to be created in `backend/app/infrastructure/migrations.py`.

---

## 2. Backend API Changes

The following changes need to be made to the FastAPI backend.

### New Value Objects & Enums
- **File**: `backend/app/domain/value_objects/project.py`
  - Create enums `ProjectDifficulty` and `UserProjectStatus`.
- **File**: `backend/app/domain/value_objects/feed.py`
  - (No enums needed, but file for consistency if required later)
- **File**: `backend/app/domain/value_objects/suggestion.py`
  - Create enum `SuggestionStatus`.

### New Domain Entities
- `backend/app/domain/entities/project.py`: `Project` and `UserProject` dataclasses.
- `backend/app/domain/entities/feed.py`: `FeedItem` dataclass.
- `backend/app/domain/entities/suggestion.py`: `SuggestedContent` dataclass.

### New DTOs
- `backend/app/application/dtos/project.py`: Pydantic models for `Project` and `UserProject`.
- `backend/app/application/dtos/feed.py`: Pydantic model for `FeedItem`.
- `backend/app/application/dtos/suggestion.py`: Pydantic model for `SuggestedContent`.

### New API Routers
- **File**: `backend/app/presentation/api/projects.py`
  - `GET /projects/`
  - `GET /projects/{id}`
  - `POST /projects/{id}/submit`
  - `GET /me/projects/`
- **File**: `backend/app/presentation/api/playground.py`
  - `POST /playground/chat`
- **File**: `backend/app/presentation/api/feed.py`
  - `GET /feed/`
- **File**: `backend/app/presentation/api/suggestions.py`
  - `POST /suggestions/`

**Action:** Update `backend/app/main.py` to include these new routers.

---

## 3. New Services (Backend)

### Code Playground Kernel Service
- **Architecture**: This will be a new, separate FastAPI application. It will not be part of the main backend to ensure isolation.
- **Project Structure**: A new directory `backend-kernel/` will be created.
- **Dockerfile**: It will have its own `Dockerfile` with all ML libraries installed.
- **Execution**: It will use `subprocess` to run user code in a temporary file. The execution will be sandboxed using Docker's security features or a lower-privileged user.
- **API**: A single endpoint `POST /execute` will receive the code and return the output.

### Feed Summarization Worker
- **Architecture**: A background worker process that can be run as a separate container. It is not a user-facing service.
- **Technology**: Celery with a message broker like Redis would be ideal, but for simplicity, a simple script run via a `cron` job inside a Docker container can be used initially.
- **Logic**:
  1. Define a list of RSS feeds in a config file.
  2. Use a library like `feedparser` to read feeds.
  3. For new articles, use the `google-generativeai` library to call the Gemini API for summarization.
  4. Store the result in the `feed_items` table.
- **File**: `backend/app/workers/feed_worker.py`.

---

## 4. Frontend UI Changes (Flutter)

The following changes need to be made to the Flutter frontend.

### New Models
- `lib/data/models/project.dart`: `Project` and `UserProject` models.
- `lib/data/models/feed_item.dart`: `FeedItem` model.

### New Services (API Clients)
- `lib/services/api/project_api_service.dart`: Client for the projects API.
- `lib/services/api/playground_api_service.dart`: Client for the playground API.
- `lib/services/api/feed_api_service.dart`: Client for the feed API.

### New Providers (State Management)
- `lib/providers/project_provider.dart`: To manage project state.
- `lib/providers/feed_provider.dart`: To manage the feed state.
- `lib/providers/playground_provider.dart`: To manage the AI playground state.

### New Screens & Widgets
- **Playground**: `lib/presentation/screens/playground_screen.dart`
- **Projects**:
  - `lib/presentation/screens/project_list_screen.dart`
  - `lib/presentation/screens/project_detail_screen.dart`
- **Feed**: `lib/presentation/screens/feed_screen.dart`
- **Code Playground**: `lib/presentation/widgets/code_playground_widget.dart`. This will be a complex widget containing a code editor and an output view.

**Action:** Update the app's router (`lib/app_router.dart`) to include the new screens. Update the main navigation to provide access to the new sections.
