#!/bin/bash

# Google Cloud Secret Manager Setup Script
# Run this script to set up secrets for your production deployment

set -e

PROJECT_ID=${GOOGLE_CLOUD_PROJECT:-"aiteach-472319"}

echo "Setting up secrets for project: $PROJECT_ID"

# Enable Secret Manager API
echo "Enabling Secret Manager API..."
gcloud services enable secretmanager.googleapis.com --project=$PROJECT_ID

# Generate JWT secret
JWT_SECRET=$(openssl rand -base64 64)

echo "Creating secrets in Secret Manager..."

# Create JWT secret
echo -n "$JWT_SECRET" | gcloud secrets create jwt-secret-key \
    --data-file=- \
    --project=$PROJECT_ID

# You'll need to manually set the database URL after running setup-cloud-sql.sh
echo "🔑 Secrets created:"
echo "  - jwt-secret-key: ✅"
echo "  - database-url: ⏳ (run setup-cloud-sql.sh first)"

echo ""
echo "📋 Manual steps required:"
echo "1. Run ./setup-cloud-sql.sh to create database and get DATABASE_URL"
echo "2. Update your domain name in the allowed origins"
echo "3. Grant Secret Manager access to Cloud Run service account:"
echo "   gcloud projects add-iam-policy-binding $PROJECT_ID \\"
echo "     --member='serviceAccount:$PROJECT_ID-compute@developer.gserviceaccount.com' \\"
echo "     --role='roles/secretmanager.secretAccessor'"

# Show current secrets
echo ""
echo "📋 Current secrets:"
gcloud secrets list --project=$PROJECT_ID --filter="name:jwt-secret-key OR name:database-url"