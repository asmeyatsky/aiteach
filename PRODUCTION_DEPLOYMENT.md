# 🚀 Production Deployment Guide

This guide walks you through deploying the AI Education Platform to production on Google Cloud Platform.

## 📋 Prerequisites

Before deploying, ensure you have:

- **Google Cloud Project** with billing enabled
- **Domain name** (e.g., `aiteach.app`)
- **gcloud CLI** installed and authenticated
- **Flutter SDK** (3.9.2 or higher)
- **Docker** installed
- **Node.js** and **npm** (for any additional tooling)

## 🔧 Pre-Deployment Setup

### 1. Configure Google Cloud Project

```bash
# Set your project ID
export GOOGLE_CLOUD_PROJECT="your-project-id"

# Authenticate with Google Cloud
gcloud auth login
gcloud config set project $GOOGLE_CLOUD_PROJECT

# Enable billing for your project (required for Cloud SQL, Cloud Run, etc.)
# Do this through the Google Cloud Console
```

### 2. Update Configuration

1. **Update domain references:**
   - Edit `backend/.env.production` - set your domain in `ALLOWED_ORIGINS`
   - Edit `frontend/lib/config/environment.dart` - set production API URL
   - Edit `frontend/web/index.html` - update Open Graph URLs

2. **Set project ID in scripts:**
   ```bash
   # Update these files with your project ID:
   sed -i 's/your-project-id/your-actual-project-id/g' setup-cloud-sql.sh
   sed -i 's/your-project-id/your-actual-project-id/g' setup-secrets.sh
   sed -i 's/your-project-id/your-actual-project-id/g' deploy.sh
   ```

## 🚀 Deployment Process

### Option 1: Full Automated Deployment

```bash
# Run the complete deployment process
./deploy.sh full
```

### Option 2: Step-by-Step Deployment

#### Step 1: Setup Infrastructure

```bash
# Check prerequisites
./deploy.sh prereq

# Setup Google Cloud resources
./deploy.sh setup
```

#### Step 2: Deploy Backend

```bash
# Deploy FastAPI backend to Cloud Run
./deploy.sh backend
```

#### Step 3: Deploy Frontend

```bash
# Deploy Flutter web to App Engine
./deploy.sh frontend
```

#### Step 4: Configure Domain

```bash
# Get domain configuration instructions
./deploy.sh domain
```

#### Step 5: Verify Deployment

```bash
# Test the deployment
./deploy.sh verify
```

## 🔐 Security Configuration

### Environment Variables & Secrets

The deployment automatically creates these secrets in Google Secret Manager:

- `database-url` - PostgreSQL connection string
- `jwt-secret-key` - JWT signing key

### Security Features Included

- **Rate limiting** (60 requests/minute per IP)
- **CORS protection** with domain allowlisting
- **Security headers** (CSP, HSTS, X-Frame-Options, etc.)
- **Input validation** and sanitization
- **SQL injection protection** via SQLAlchemy ORM
- **Password hashing** with bcrypt
- **JWT token authentication**

## 🗄️ Database Setup

### Cloud SQL Configuration

The deployment creates:
- **PostgreSQL 15** instance (`aiteach-db`)
- **Automated backups** (daily at 2 AM UTC)
- **Connection security** via Cloud SQL Proxy
- **Database migrations** system

### Running Migrations

```bash
# Migrations run automatically on deployment
# To manually run migrations:
cd backend
python -c "from app.migrations import run_migrations; run_migrations()"
```

## 📊 Monitoring & Logging

### Google Cloud Logging

- All application logs are sent to Google Cloud Logging
- Structured logging with request/response tracking
- Error tracking and alerting

### Application Metrics

- Request count and response times
- Error rates and user activity
- Database query metrics

### Health Checks

- Backend: `https://api.yourdomain.com/health`
- Frontend: Built-in App Engine health checks

## 🌐 Domain & SSL Configuration

### Backend Domain (API)

1. **Create Cloud Run domain mapping:**
   ```bash
   gcloud run domain-mappings create \
     --service=aiteach-backend \
     --domain=api.yourdomain.com \
     --region=us-central1 \
     --project=$GOOGLE_CLOUD_PROJECT
   ```

2. **Configure DNS:**
   - Add CNAME record: `api.yourdomain.com` → `ghs.googlehosted.com`

### Frontend Domain

1. **Add custom domain in App Engine:**
   - Go to: Cloud Console → App Engine → Settings → Custom domains
   - Add your domain (e.g., `yourdomain.com`)
   - Follow DNS configuration instructions

2. **Configure DNS:**
   - Add A records as provided by Google Cloud Console
   - SSL certificates are automatically managed

## 🔄 CI/CD Pipeline

### Automatic Deployment

Set up Cloud Build triggers for automatic deployment:

1. **Connect repository:**
   ```bash
   gcloud builds triggers create github \
     --repo-name=aiteach \
     --repo-owner=yourusername \
     --branch-pattern="^main$" \
     --build-config=backend/cloudbuild.yaml
   ```

2. **Environment-specific builds:**
   - `main` branch → Production
   - `staging` branch → Staging environment

## 📈 Performance Optimization

### Backend Optimization

- **Connection pooling** configured for Cloud SQL
- **Rate limiting** to prevent abuse
- **Caching** headers for static content
- **Compression** enabled

### Frontend Optimization

- **Tree shaking** to reduce bundle size
- **Code splitting** for faster initial load
- **Service worker** for offline functionality
- **CDN** via Google's infrastructure

## 🔧 Maintenance Tasks

### Database Backups

```bash
# Manual backup
gcloud sql backups create \
  --instance=aiteach-db \
  --project=$GOOGLE_CLOUD_PROJECT
```

### Scaling

```bash
# Scale Cloud Run instances
gcloud run services update aiteach-backend \
  --max-instances=20 \
  --region=us-central1 \
  --project=$GOOGLE_CLOUD_PROJECT
```

### Log Analysis

```bash
# View recent logs
gcloud logging read "resource.type=cloud_run_revision" \
  --limit=50 \
  --project=$GOOGLE_CLOUD_PROJECT
```

## 🚨 Troubleshooting

### Common Issues

1. **Database connection timeout:**
   - Check Cloud SQL instance status
   - Verify connection string in secrets

2. **CORS errors:**
   - Update `ALLOWED_ORIGINS` in environment config
   - Redeploy backend

3. **SSL certificate issues:**
   - Wait 15-30 minutes for Google to provision certificates
   - Verify DNS configuration

4. **Build failures:**
   - Check Cloud Build logs
   - Verify all required APIs are enabled

### Useful Commands

```bash
# Check Cloud Run service status
gcloud run services describe aiteach-backend \
  --region=us-central1 \
  --project=$GOOGLE_CLOUD_PROJECT

# View Cloud SQL instance details
gcloud sql instances describe aiteach-db \
  --project=$GOOGLE_CLOUD_PROJECT

# Check secrets
gcloud secrets list --project=$GOOGLE_CLOUD_PROJECT

# View App Engine versions
gcloud app versions list --project=$GOOGLE_CLOUD_PROJECT
```

## 📞 Support

For deployment issues:
1. Check the troubleshooting section above
2. Review Google Cloud Console logs
3. Check service status pages
4. Contact your cloud administrator

## 🎉 Post-Deployment Checklist

- [ ] All services are healthy
- [ ] Custom domain resolves correctly
- [ ] SSL certificates are active
- [ ] API endpoints respond correctly
- [ ] Database connections work
- [ ] Monitoring and logging are active
- [ ] Backup strategy is in place
- [ ] Performance baselines established

---

**🚀 Your AI Education Platform is now live!**

Visit your production URLs:
- **Frontend:** `https://yourdomain.com`
- **Backend API:** `https://api.yourdomain.com`
- **API Documentation:** `https://api.yourdomain.com/docs` (if enabled)