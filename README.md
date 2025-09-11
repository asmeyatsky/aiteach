# AI Education Platform

An innovative learning platform for artificial intelligence and machine learning education, featuring personalized learning paths based on user proficiency levels.

## Features

### Personalized Learning Paths
- **Proficiency Assessment**: Interactive questionnaire to determine user's current AI/ML knowledge level
- **Adaptive Recommendations**: Course suggestions tailored to user's proficiency level
- **Progressive Difficulty**: Content that scales with user's growing expertise

### Core Functionality
- **User Authentication**: Secure JWT-based authentication system
- **Course Management**: Create, browse, and enroll in AI/ML courses
- **Multi-format Lessons**: Text, video, and interactive quiz content types
- **Progress Tracking**: Monitor completion status and learning milestones
- **Gamification**: Badges and points system to motivate learning
- **Community Forum**: Discuss topics and collaborate with peers

### Content Organization
Courses are organized by proficiency level:
- **Beginner**: No prior experience required. Covers fundamentals of AI/ML.
- **Intermediate**: Programming and math background recommended. Focuses on practical applications.
- **Advanced**: For experienced practitioners. Explores cutting-edge research and leadership topics.

### Technical Stack
- **Backend**: FastAPI with PostgreSQL database
- **Frontend**: Flutter for cross-platform mobile and web applications
- **Authentication**: JWT tokens with secure password handling
- **Containerization**: Docker for consistent deployment environments

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Flutter SDK (for frontend development)
- Python 3.9+ (for backend development)

### Quick Setup
1. Clone the repository
2. Navigate to the backend directory: `cd backend`
3. Start services: `docker-compose up`
4. In a new terminal, start the frontend: `cd ../frontend && flutter run`

## Content Sources

The platform integrates educational content from leading sources including:
- MIT OpenCourseWare
- Stanford CS229 (Andrew Ng)
- Harvard CS50 AI
- Fast.ai Practical Deep Learning
- Coursera/edX university courses
- And many more (see content.md for complete list)

## Contributing

Contributions are welcome! Please see our contributing guidelines for details on how to get involved.