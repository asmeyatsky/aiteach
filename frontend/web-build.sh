#!/bin/bash

# Flutter Web Production Build Script
set -e

echo "Building Flutter Web for Production..."

# Clean previous build
flutter clean

# Get dependencies
flutter pub get

# Generate code (for json_serializable, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for web with optimizations
flutter build web \
    --release \
    --web-renderer canvaskit \
    --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.35.0/ \
    --tree-shake-icons \
    --source-maps

echo "✅ Flutter Web build completed!"
echo "📂 Build output is in build/web/"

# Optional: Copy build to a specific directory for deployment
if [ "$1" = "deploy" ]; then
    echo "Preparing deployment files..."

    # Create deployment directory
    mkdir -p deploy/web

    # Copy build files
    cp -r build/web/* deploy/web/

    # Create deployment manifest
    cat > deploy/web/app.yaml << 'EOF'
runtime: python39

handlers:
# Serve Flutter web app
- url: /
  static_files: index.html
  upload: index.html
  secure: always
  redirect_http_response_code: 301

- url: /(.*)
  static_files: \1
  upload: (.*)
  secure: always
  redirect_http_response_code: 301

# Security headers
- url: /.*
  script: main.app
  secure: always
  redirect_http_response_code: 301
EOF

    echo "✅ Deployment files ready in deploy/web/"
fi