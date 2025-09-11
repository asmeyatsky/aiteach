# AI Education Platform

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Flutter%20%7C%20FastAPI-blue)](#)
[![Contributors](https://img.shields.io/github/contributors/asmeyatsky/aiteach)](https://github.com/asmeyatsky/aiteach/graphs/contributors)

An innovative AI/ML education platform with personalized learning paths based on user proficiency levels.

## 🌟 Key Features

### Personalized Learning Paths
- **Proficiency Assessment**: Interactive questionnaire to determine your current AI/ML knowledge
- **Adaptive Recommendations**: Course suggestions tailored to your skill level
- **Progressive Difficulty**: Content that scales with your growing expertise
- **Level-Based Organization**: Beginner → Intermediate → Advanced courses

### Rich Educational Content
Integrated from leading sources:
- **Academic Institutions**: MIT OCW, Stanford CS229, Harvard CS50 AI
- **Industry Leaders**: Google AI, Microsoft AI, Fast.ai
- **Specialized Platforms**: Coursera, edX, Kaggle Learn
- **Cutting-Edge Research**: Latest papers and techniques

### Comprehensive Platform
- 🔐 **Secure Authentication**: JWT-based login and registration
- 📚 **Course Management**: Full CRUD operations for courses and lessons
- 🎯 **Progress Tracking**: Monitor completion status and learning milestones
- 🏆 **Gamification**: Badges and points system to motivate learning
- 💬 **Community Forum**: Discussion boards for peer interaction
- 📱 **Responsive Design**: Works on mobile, tablet, and web

## 🚀 Technology Stack

### Backend
- **FastAPI**: High-performance Python web framework
- **PostgreSQL**: Robust relational database
- **Docker**: Containerized deployment
- **JWT**: Secure authentication
- **RESTful API**: Well-documented endpoints

### Frontend
- **Flutter**: Cross-platform mobile and web application
- **Riverpod**: State management
- **Dio**: HTTP client
- **Responsive UI**: Adaptive layouts for all devices

## 📁 Project Structure

```
aiteach/
├── backend/           # FastAPI backend with PostgreSQL
│   ├── app/           # API application code
│   │   ├── models/    # Database models
│   │   ├── schemas/   # Pydantic schemas
│   │   ├── routers/    # API route handlers
│   │   ├── crud.py    # Database operations
│   │   └── main.py    # Application entry point
│   ├── tests/         # Backend API tests
│   ├── Dockerfile     # Container configuration
│   └── docker-compose.yml
├── frontend/          # Flutter application
│   ├── lib/           # Dart source code
│   │   ├── models/    # Data models
│   │   ├── providers/  # Riverpod providers
│   │   ├── services/   # API service classes
│   │   ├── presentation/ # UI components
│   │   │   ├── screens/   # Screen widgets
│   │   │   ├── widgets/   # Reusable components
│   │   │   └── animations/ # Animation utilities
│   │   └── main.dart     # Application entry point
│   └── test/          # Frontend tests
├── content.md         # Content strategy and sources
└── start-platform.sh  # Quick start script
```

## 🏁 Quick Start

### Prerequisites
- Docker and Docker Compose
- Flutter SDK (3.9.2 or higher)
- Python 3.9+

### Running the Platform

```bash
# Clone the repository
git clone https://github.com/asmeyatsky/aiteach.git
cd aiteach

# Start the platform
./start-platform.sh
```

Or manually:

```bash
# Start backend services
cd backend
docker-compose up -d

# Start frontend application
cd ../frontend
flutter pub get
flutter run
```

## 🎯 Learning Path Levels

### Beginner (No prior experience required)
- Introduction to AI/ML concepts
- Basic Python programming for data science
- Fundamental mathematics (statistics, linear algebra)
- Simple machine learning algorithms

### Intermediate (Programming/math background recommended)
- Supervised and unsupervised learning
- Neural networks and deep learning basics
- Frameworks (TensorFlow, PyTorch, Scikit-learn)
- Real-world project development

### Advanced (Experienced practitioners)
- Cutting-edge research topics
- Advanced neural network architectures
- AI leadership and strategy
- Research methodology and publication

## 🧪 Testing

### Backend Tests
```bash
cd backend
python -m pytest
```

### Frontend Tests
```bash
cd frontend
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to all educational content providers who make AI/ML education accessible
- Inspired by the need for personalized learning in technical education
- Built with passion for making AI education more approachable

## 📞 Contact

For questions, suggestions, or feedback, please open an issue on GitHub.