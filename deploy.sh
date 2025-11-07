#!/bin/bash

# AI Education Platform Production Deployment Script
set -e

# Configuration
PROJECT_ID=${GOOGLE_CLOUD_PROJECT:-"your-project-id"}
REGION="us-central1"

echo "🚀 Starting deployment for AI Education Platform"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    echo "📋 Checking prerequisites..."

    if ! command_exists gcloud; then
        echo "❌ gcloud CLI not found. Please install Google Cloud SDK."
        exit 1
    fi

    if ! command_exists flutter; then
        echo "❌ Flutter not found. Please install Flutter SDK."
        exit 1
    fi

    if ! command_exists docker; then
        echo "❌ Docker not found. Please install Docker."
        exit 1
    fi

    echo "✅ All prerequisites met"
}

# Setup Google Cloud resources
setup_gcloud_resources() {
    echo "☁️ Setting up Google Cloud resources..."

    # Enable required APIs
    echo "Enabling required APIs..."
    gcloud services enable cloudbuild.googleapis.com \
        run.googleapis.com \
        sqladmin.googleapis.com \
        secretmanager.googleapis.com \
        compute.googleapis.com \
        --project=$PROJECT_ID

    # Set up Cloud SQL if it doesn't exist
    if ! gcloud sql instances describe aiteach-db --project=$PROJECT_ID >/dev/null 2>&1; then
        echo "Setting up Cloud SQL..."
        ./setup-cloud-sql.sh
    else
        echo "✅ Cloud SQL instance already exists"
    fi

    # Set up secrets if they don't exist
    if ! gcloud secrets describe jwt-secret-key --project=$PROJECT_ID >/dev/null 2>&1; then
        echo "Setting up secrets..."
        ./setup-secrets.sh
    else
        echo "✅ Secrets already exist"
    fi
}

# Deploy backend
deploy_backend() {
    echo "🔧 Deploying backend..."

    cd backend

    # Submit build to Cloud Build
    gcloud builds submit --config cloudbuild.yaml --project=$PROJECT_ID

    echo "✅ Backend deployed successfully"
    cd ..
}

# Deploy frontend
deploy_frontend() {
    echo "🎨 Deploying frontend..."

    cd frontend

    # Build Flutter web
    ./web-build.sh

    # Deploy to App Engine (or you could use Firebase Hosting, Cloud Storage, etc.)
    echo "Creating app.yaml for frontend..."
    cat > app.yaml << 'EOF'
runtime: python39

handlers:
# Serve Flutter web app
- url: /
  static_files: build/web/index.html
  upload: build/web/index.html
  secure: always
  redirect_http_response_code: 301

- url: /(.*)
  static_files: build/web/\1
  upload: build/web/(.*)
  secure: always
  redirect_http_response_code: 301

# Security headers
- url: /.*
  secure: always
  redirect_http_response_code: 301

# Add security headers
env_variables:
  SECURE_SSL_REDIRECT: true
EOF

    # Deploy to App Engine
    gcloud app deploy app.yaml --project=$PROJECT_ID --promote --stop-previous-version

    echo "✅ Frontend deployed successfully"
    cd ..
}

# Configure custom domain and SSL
setup_domain() {
    echo "🌐 Setting up domain and SSL..."

    # You'll need to manually configure your domain
    echo "📋 Manual steps required:"
    echo "1. Go to Google Cloud Console > App Engine > Settings > Custom domains"
    echo "2. Add your domain (e.g., aiteach.app)"
    echo "3. Follow DNS configuration instructions"
    echo "4. SSL certificates will be automatically managed by Google"

    # For Cloud Run backend, you can map custom domain:
    echo "🔧 Backend domain mapping:"
    echo "gcloud run domain-mappings create --service=aiteach-backend --domain=api.aiteach.app --region=$REGION --project=$PROJECT_ID"
}

# Post-deployment verification
verify_deployment() {
    echo "🧪 Verifying deployment..."

    # Get backend URL
    BACKEND_URL=$(gcloud run services describe aiteach-backend --region=$REGION --project=$PROJECT_ID --format="value(status.url)")
    echo "Backend URL: $BACKEND_URL"

    # Test backend health
    if curl -s "$BACKEND_URL/health" | grep -q "healthy"; then
        echo "✅ Backend health check passed"
    else
        echo "❌ Backend health check failed"
    fi

    # Get frontend URL
    FRONTEND_URL="https://$PROJECT_ID.appspot.com"
    echo "Frontend URL: $FRONTEND_URL"

    echo "🎉 Deployment completed!"
    echo ""
    echo "📋 URLs:"
    echo "  Frontend: $FRONTEND_URL"
    echo "  Backend:  $BACKEND_URL"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Configure custom domain (see setup_domain function output)"
    echo "2. Set up monitoring and alerting"
    echo "3. Configure CDN for frontend assets"
    echo "4. Set up backup strategy for database"
}

# Main deployment flow
main() {
    case "${1:-full}" in
        "prereq")
            check_prerequisites
            ;;
        "setup")
            check_prerequisites
            setup_gcloud_resources
            ;;
        "backend")
            check_prerequisites
            deploy_backend
            ;;
        "frontend")
            check_prerequisites
            deploy_frontend
            ;;
        "domain")
            setup_domain
            ;;
        "verify")
            verify_deployment
            ;;
        "full"|*)
            check_prerequisites
            setup_gcloud_resources
            deploy_backend
            deploy_frontend
            setup_domain
            verify_deployment
            ;;
    esac
}

# Run main function with all arguments
main "$@"