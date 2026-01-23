# Feature Specification: Interactive & Dynamic Content

This document outlines the specifications for new interactive features and dynamic content systems for the AI Education Platform.

---

## 1. Integrated Code Playground

- **Goal**: To allow users, especially in the "Builder" track, to run code snippets from lessons directly in the browser in a secure, pre-configured environment.

- **Core Requirements**:
    - **Execution Environment**: A sandboxed Python 3.9+ environment.
    - **Security**: The environment must be isolated from the host system and other users' environments. API keys and other secrets must not be exposed to the client-side.
    - **Persistence**: Environments will be stateless and ephemeral. Each execution starts in a clean, pre-defined state.
    - **Pre-installed Libraries**: The environment will include common AI/ML libraries, such as:
        - `numpy`
        - `pandas`
        - `scikit-learn`
        - `torch`
        - `tensorflow`
        - `requests`
        - `google-generativeai`
        - `python-dotenv`
    - **User Interface**:
        - A front-end code editor with Python syntax highlighting (e.g., using the Monaco or CodeMirror editor component).
        - A "Run" button to trigger code execution.
        - An output area to display `stdout`, `stderr`, and any visual outputs like plots or images.

- **Proposed Technology**:
    - **Backend Kernel Service**: A new, dedicated backend service (e.g., a "Kernel Service") will be created.
    - When a user runs code, the frontend will send the code to this service.
    - The service will spin up a short-lived, isolated Docker container to execute the code.
    - Any API keys required for a lesson (e.g., a Gemini API key) will be securely loaded into the container's environment from the backend.
    - The `stdout` and `stderr` from the execution will be streamed back to the user's browser.
    - **Rationale**: This approach is more secure for handling API keys and supports a full range of Python libraries, which is essential for the "Builder" track.

---

## 2. Live AI Model Interaction ("AI Playground")

- **Goal**: To provide a simple, chat-like interface for all users to interact directly with generative AI models, making learning more intuitive and hands-on.

- **Core Requirements**:
    - **User Interface**:
        - A simple chat interface (for language models) or a prompt-and-image-display (for image models).
        - A text input for the user's prompt.
        - An output area where the model's response is displayed (with streaming for text).
        - A mechanism to select from a pre-defined list of models (e.g., Gemini Pro).
    - **Backend**:
        - A new API endpoint (e.g., `/api/v1/playground/chat`).
        - The backend will receive the user's prompt and securely call the appropriate external AI API (e.g., Google Gemini).
        - The API key for the external service will be stored securely on the backend and never exposed to the client.
        - The response from the AI model will be streamed back to the frontend to create a real-time interactive effect.

---

## 3. Project-Based Learning Modules

- **Goal**: To shift learning from passive content consumption to active building by creating a structured system for hands-on projects.

- **Database Schema Changes**:
    - **New `Project` Table**:
        - `id` (PK)
        - `track` (Enum: `user`, `builder`, `innovator`)
        - `title` (String)
        - `description` (Text/Markdown)
        - `starter_code_url` (String, optional)
        - `difficulty` (Enum: `easy`, `medium`, `hard`)
    - **New `UserProject` Table**:
        - `id` (PK)
        - `user_id` (FK to `User`)
        - `project_id` (FK to `Project`)
        - `status` (Enum: `not_started`, `in_progress`, `completed`)
        - `submission_url` (String, e.g., link to user's GitHub repo)

- **Backend API**:
    - New API endpoints under `/api/v1/projects/`.
    - `GET /projects/`: List all available projects, with filtering by track and difficulty.
    - `GET /projects/{id}`: Get details for a single project.
    - `POST /projects/{id}/submit`: Endpoint for a user to submit their completed project.
    - `GET /me/projects/`: List the current user's projects and their status.

- **Frontend UI**:
    - A new "Projects" section in the main navigation.
    - A browse screen to view and filter available projects.
    - A detailed project view screen.
    - A mechanism for users to input their submission URL.

---

## 4. Dynamic Content - "What's New in AI" Feed

- **Goal**: To keep users engaged and the platform current by providing a feed of the latest AI news, research, and articles.

- **Core Requirements**:
    - **Content Sourcing**: A background job will monitor a predefined list of high-quality RSS feeds (e.g., Google AI Blog, OpenAI Blog, etc.).
    - **Content Processing**: The background job will run daily, fetch new articles, and use an LLM (like Gemini) to generate a concise summary for each.
    - **Database Schema**: A new `FeedItem` table will be created to store the article title, source, URL, AI-generated summary, and publication date.
    - **Backend**: A new background worker process will be implemented for sourcing/summarizing, and a new `GET /api/v1/feed` endpoint will serve the items.
    - **Frontend**: A new "What's New" section will be added to the app to display a scrolling list of these summarized articles.

---

## 5. Community-Curated Content

- **Goal**: To empower the community to suggest new learning resources and help keep the platform's content on the cutting edge.

- **Core Requirements**:
    - **Submission UI**: A simple form for users to submit a resource URL, suggest which track it belongs to, and add a comment.
    - **Moderation Workflow**:
        - Submissions will be saved to a `SuggestedContent` table with a `pending` status.
        - An admin interface will allow moderators to review, approve, or reject submissions.
        - Approved content can then be formally added to a course by a content manager.
    - **Backend/Frontend**: New API endpoints and UI screens for content submission. A moderation UI will be a future addition.

---

## 6. Integrated AI Ethics Modules

- **Goal**: To integrate AI ethics and safety into the curriculum as a core, mandatory component.

- **Core Requirements**:
    - **New Mandatory Course**: A new course, "Responsible AI Fundamentals," will be created.
    - **Automatic Enrollment**: This course will be automatically assigned to all new users upon registration.
    - **Curriculum Integration**:
        - The "Ethical AI User" module in the **User Track** will be based on this course.
        - A more advanced "Responsible AI Development" course will be required for the **Builder Track**.
        - Advanced topics in AI alignment and safety will be woven into the **Innovator Track**.
    - **Implementation**: This will be implemented primarily through curriculum and data structuring, building on the already-implemented `Track` system. No major new features are required, but it represents a core part of the content strategy.