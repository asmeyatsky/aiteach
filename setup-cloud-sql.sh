#!/bin/bash

# Cloud SQL Setup Script for AI Teach Platform
# Run this script to set up your production database

set -e

# Configuration
PROJECT_ID=${GOOGLE_CLOUD_PROJECT:-"aiteach-472319"}
REGION="us-central1"
INSTANCE_NAME="aiteach-db"
DATABASE_NAME="aiteach"
DB_USER="aiteach_user"

echo "Setting up Cloud SQL for project: $PROJECT_ID"

# Enable required APIs
echo "Enabling required APIs..."
gcloud services enable sqladmin.googleapis.com --project=$PROJECT_ID
gcloud services enable compute.googleapis.com --project=$PROJECT_ID

# Create Cloud SQL instance
echo "Creating Cloud SQL PostgreSQL instance..."
gcloud sql instances create $INSTANCE_NAME \
    --database-version=POSTGRES_15 \
    --tier=db-f1-micro \
    --region=$REGION \
    --storage-type=SSD \
    --storage-size=10GB \
    --storage-auto-increase \
    --backup-start-time=02:00 \
    --maintenance-window-day=SUN \
    --maintenance-window-hour=02 \
    --project=$PROJECT_ID

# Set root password
echo "Setting root password..."
DB_ROOT_PASSWORD=$(openssl rand -base64 32)
gcloud sql users set-password postgres \
    --instance=$INSTANCE_NAME \
    --password="$DB_ROOT_PASSWORD" \
    --project=$PROJECT_ID

# Create application database
echo "Creating application database..."
gcloud sql databases create $DATABASE_NAME \
    --instance=$INSTANCE_NAME \
    --project=$PROJECT_ID

# Create application user
echo "Creating application user..."
DB_PASSWORD=$(openssl rand -base64 32)
gcloud sql users create $DB_USER \
    --instance=$INSTANCE_NAME \
    --password="$DB_PASSWORD" \
    --project=$PROJECT_ID

# Get connection name
CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(connectionName)")

# Create database URL
DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@/$DATABASE_NAME?host=/cloudsql/$CONNECTION_NAME"

echo "✅ Cloud SQL setup completed!"
echo "📋 Configuration Details:"
echo "  Instance: $INSTANCE_NAME"
echo "  Database: $DATABASE_NAME"
echo "  User: $DB_USER"
echo "  Connection Name: $CONNECTION_NAME"
echo ""
echo "🔑 Store these secrets in Secret Manager:"
echo "  DATABASE_URL: $DATABASE_URL"
echo "  DB_PASSWORD: $DB_PASSWORD"
echo "  DB_ROOT_PASSWORD: $DB_ROOT_PASSWORD"
echo ""
echo "Run the following commands to store secrets:"
echo "gcloud secrets create database-url --data-file=<(echo -n '$DATABASE_URL') --project=$PROJECT_ID"
echo "gcloud secrets create db-password --data-file=<(echo -n '$DB_PASSWORD') --project=$PROJECT_ID"
echo "gcloud secrets create db-root-password --data-file=<(echo -n '$DB_ROOT_PASSWORD') --project=$PROJECT_ID"