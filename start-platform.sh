#!/bin/bash

# AI Education Platform - Quick Start Script

echo "==========================================="
echo "  AI Education Platform - Quick Start"
echo "==========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null
then
    echo "Error: Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "Error: Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "Starting AI Education Platform..."
echo ""

# Start backend services
echo "1. Starting backend services..."
cd backend
docker-compose up -d

# Wait for services to start
echo "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose ps | grep -q "running"; then
    echo "✅ Backend services started successfully!"
else
    echo "❌ Failed to start backend services."
    exit 1
fi

echo ""
echo "2. Starting frontend application..."
cd ../frontend

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Start the app
echo "Starting the application..."
flutter run

echo ""
echo "==========================================="
echo "  Platform Status"
echo "==========================================="
echo "✅ Backend API: http://localhost:8000"
echo "✅ Database: PostgreSQL (Docker container)"
echo "✅ Frontend: Flutter application"
echo ""
echo "To access the platform:"
echo "1. Open the Flutter app on your device/emulator"
echo "2. Register a new account or login with existing credentials"
echo "3. Complete the proficiency assessment to get personalized recommendations"
echo "4. Start learning AI/ML concepts at your level!"
echo ""
echo "To stop the platform:"
echo "1. Press Ctrl+C to stop the Flutter app"
echo "2. Run 'cd backend && docker-compose down' to stop backend services"
echo ""
echo "Happy learning! 🚀"