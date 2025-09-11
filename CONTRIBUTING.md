# Contributing to AI Education Platform

Thank you for your interest in contributing to the AI Education Platform! We welcome contributions from the community to help make AI/ML education more accessible and effective.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guides](#style-guides)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## 🛠 How Can I Contribute?

### Reporting Bugs
Before creating bug reports, please check the existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible.

### Suggesting Enhancements
Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- A clear and descriptive title
- A detailed description of the proposed enhancement
- Explanation of why this enhancement would be useful
- Examples of how the enhancement would work

### Code Contributions
1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Make your changes
4. Add tests if applicable
5. Ensure all tests pass
6. Submit a pull request

## 🏗 Development Setup

### Prerequisites
- Docker and Docker Compose
- Flutter SDK (3.9.2 or higher)
- Python 3.9+
- Git

### Backend Setup
```bash
cd backend
docker-compose up -d
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run
```

### Running Tests
```bash
# Backend tests
cd backend
python -m pytest

# Frontend tests
cd frontend
flutter test
```

## 📥 Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a build
2. Update the README.md with details of changes to the interface, this includes new environment variables, exposed ports, useful file locations and container parameters
3. Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent
4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you

## 📝 Style Guides

### Git Commit Messages
- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Backend (Python/FastAPI)
- Follow PEP 8 style guide
- Use type hints for all function signatures
- Write docstrings for all public methods and classes
- Keep functions small and focused
- Use meaningful variable names

### Frontend (Flutter/Dart)
- Follow Flutter style guide
- Use meaningful widget names
- Keep widgets small and focused
- Use const constructors where possible
- Prefer stateless widgets over stateful widgets when possible

## 🐛 Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

### Before Submitting A Bug Report
- Check the existing issues to see if the problem has already been reported
- Check if you can reproduce the problem in the latest version of the project

### How Do I Submit A Good Bug Report?
Bugs are tracked as GitHub issues. Create an issue on the repository and provide the following information:

1. **Use a clear and descriptive title** for the issue to identify the problem
2. **Describe the exact steps which reproduce the problem** in as many details as possible
3. **Provide specific examples to demonstrate the steps**
4. **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior
5. **Explain which behavior you expected to see instead and why**
6. **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem
7. **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below

## 💡 Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

### Before Submitting An Enhancement Suggestion
- Check the existing issues to see if the enhancement has already been suggested
- Determine which repository the enhancement should be suggested in

### How Do I Submit A Good Enhancement Suggestion?
Enhancement suggestions are tracked as GitHub issues. Create an issue on the repository and provide the following information:

1. **Use a clear and descriptive title** for the issue to identify the suggestion
2. **Provide a step-by-step description of the suggested enhancement** in as many details as possible
3. **Provide specific examples to demonstrate the steps**
4. **Describe the current behavior** and **explain which behavior you expected to see instead** and why
5. **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part which the suggestion is related to
6. **Explain why this enhancement would be useful** to most users
7. **Specify the name and version of the OS you're using**

## 🎯 Development Workflow

1. **Create a branch** for your feature or bug fix
2. **Write code** following the style guides
3. **Write tests** to ensure your code works as expected
4. **Run all tests** to make sure nothing is broken
5. **Commit your changes** with a clear, descriptive message
6. **Push your branch** to your fork
7. **Create a pull request** with a clear title and description

## 🧪 Testing

We maintain a comprehensive test suite to ensure code quality and prevent regressions.

### Backend Testing
- Write unit tests for all new functionality
- Use pytest for test framework
- Aim for 80%+ code coverage
- Test edge cases and error conditions

### Frontend Testing
- Write widget tests for all new UI components
- Use integration tests for complex user flows
- Test different device sizes and orientations
- Ensure accessibility compliance

## 📚 Documentation

- Keep documentation up-to-date with code changes
- Write clear, concise docstrings for all public APIs
- Update README.md when adding new features
- Include examples for complex functionality

Thank you for contributing to the AI Education Platform!