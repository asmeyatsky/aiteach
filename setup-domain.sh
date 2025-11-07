#!/bin/bash

# Domain and SSL Configuration Script
set -e

PROJECT_ID=${GOOGLE_CLOUD_PROJECT:-"your-project-id"}
REGION="us-central1"
DOMAIN=${1:-"example.com"}
API_DOMAIN="api.$DOMAIN"

echo "🌐 Setting up domain and SSL for: $DOMAIN"
echo "API Domain: $API_DOMAIN"
echo "Project: $PROJECT_ID"

# Function to check if domain mapping exists
check_domain_mapping() {
    local service=$1
    local domain=$2
    gcloud run domain-mappings describe "$domain" \
        --region="$REGION" \
        --project="$PROJECT_ID" >/dev/null 2>&1
}

# Setup Cloud Run domain mapping for backend
setup_backend_domain() {
    echo "🔧 Setting up backend domain mapping..."

    if check_domain_mapping "aiteach-backend" "$API_DOMAIN"; then
        echo "✅ Domain mapping for $API_DOMAIN already exists"
    else
        echo "Creating domain mapping for backend..."
        gcloud run domain-mappings create \
            --service=aiteach-backend \
            --domain="$API_DOMAIN" \
            --region="$REGION" \
            --project="$PROJECT_ID"

        echo "✅ Backend domain mapping created"
    fi
}

# Setup App Engine custom domain for frontend
setup_frontend_domain() {
    echo "🎨 Setting up frontend domain..."

    echo "📋 Manual steps required for frontend domain:"
    echo "1. Go to: https://console.cloud.google.com/appengine/settings/domains?project=$PROJECT_ID"
    echo "2. Click 'Add a custom domain'"
    echo "3. Enter your domain: $DOMAIN"
    echo "4. Follow the verification steps"
    echo "5. Configure DNS records as instructed"
}

# Get DNS configuration instructions
get_dns_instructions() {
    echo "📋 DNS Configuration Instructions:"
    echo ""
    echo "For your domain registrar, add these DNS records:"
    echo ""

    # Get Cloud Run domain mapping details
    if gcloud run domain-mappings describe "$API_DOMAIN" \
        --region="$REGION" \
        --project="$PROJECT_ID" >/dev/null 2>&1; then

        echo "🔧 Backend API ($API_DOMAIN):"
        echo "Type: CNAME"
        echo "Name: api"
        echo "Value: ghs.googlehosted.com"
        echo ""
    fi

    echo "🎨 Frontend ($DOMAIN):"
    echo "You'll get the specific DNS records from App Engine custom domains setup."
    echo "Typically these are A records pointing to Google's IP addresses."
    echo ""

    echo "⏰ SSL Certificate Provisioning:"
    echo "- SSL certificates are automatically provisioned by Google"
    echo "- May take 15-30 minutes after DNS propagation"
    echo "- You can check status in Google Cloud Console"
}

# Check SSL certificate status
check_ssl_status() {
    echo "🔐 Checking SSL certificate status..."

    # Check Cloud Run domain mapping SSL
    if gcloud run domain-mappings describe "$API_DOMAIN" \
        --region="$REGION" \
        --project="$PROJECT_ID" --format="value(status.certificateStatus)" 2>/dev/null; then

        STATUS=$(gcloud run domain-mappings describe "$API_DOMAIN" \
            --region="$REGION" \
            --project="$PROJECT_ID" \
            --format="value(status.certificateStatus)" 2>/dev/null || echo "NOT_FOUND")

        echo "Backend SSL Status: $STATUS"
    fi

    echo ""
    echo "To check frontend SSL status:"
    echo "Visit: https://console.cloud.google.com/appengine/settings/domains?project=$PROJECT_ID"
}

# Verify domain configuration
verify_domains() {
    echo "🧪 Verifying domain configuration..."

    # Test backend domain
    echo "Testing backend domain: https://$API_DOMAIN/health"
    if curl -s "https://$API_DOMAIN/health" >/dev/null 2>&1; then
        echo "✅ Backend domain is working"
    else
        echo "❌ Backend domain not accessible yet"
        echo "   - Check DNS propagation"
        echo "   - Verify SSL certificate status"
    fi

    # Test frontend domain
    echo "Testing frontend domain: https://$DOMAIN"
    if curl -s "https://$DOMAIN" >/dev/null 2>&1; then
        echo "✅ Frontend domain is working"
    else
        echo "❌ Frontend domain not accessible yet"
        echo "   - Complete App Engine custom domain setup"
        echo "   - Check DNS configuration"
    fi
}

# Update environment configuration
update_environment_config() {
    echo "🔧 Updating environment configuration..."

    # Update backend environment
    if [ -f "backend/.env.production" ]; then
        sed -i.bak "s|https://aiteach.app|https://$DOMAIN|g" backend/.env.production
        sed -i.bak "s|https://www.aiteach.app|https://www.$DOMAIN|g" backend/.env.production
        echo "✅ Updated backend environment config"
    fi

    # Update frontend environment
    if [ -f "frontend/lib/config/environment.dart" ]; then
        sed -i.bak "s|https://api.aiteach.app|https://$API_DOMAIN|g" frontend/lib/config/environment.dart
        sed -i.bak "s|https://aiteach.app|https://$DOMAIN|g" frontend/lib/config/environment.dart
        echo "✅ Updated frontend environment config"
    fi

    # Update web index.html
    if [ -f "frontend/web/index.html" ]; then
        sed -i.bak "s|https://aiteach.app|https://$DOMAIN|g" frontend/web/index.html
        echo "✅ Updated web index.html"
    fi

    echo ""
    echo "⚠️  Remember to redeploy after updating configuration:"
    echo "   ./deploy.sh backend"
    echo "   ./deploy.sh frontend"
}

# Main function
main() {
    case "${1:-setup}" in
        "backend")
            setup_backend_domain
            ;;
        "frontend")
            setup_frontend_domain
            ;;
        "dns")
            get_dns_instructions
            ;;
        "ssl")
            check_ssl_status
            ;;
        "verify")
            verify_domains
            ;;
        "update")
            shift
            DOMAIN=${1:-"example.com"}
            update_environment_config
            ;;
        "setup"|*)
            if [ -z "$1" ]; then
                echo "Usage: $0 <domain> [action]"
                echo "       $0 example.com setup    # Full domain setup"
                echo "       $0 example.com backend  # Backend domain only"
                echo "       $0 example.com frontend # Frontend domain only"
                echo "       $0 example.com dns      # Show DNS instructions"
                echo "       $0 example.com ssl      # Check SSL status"
                echo "       $0 example.com verify   # Verify domains"
                echo "       $0 update example.com   # Update config files"
                exit 1
            fi

            setup_backend_domain
            setup_frontend_domain
            get_dns_instructions
            check_ssl_status
            ;;
    esac
}

# If domain is provided as first argument, shift and use it
if [ -n "$1" ] && [[ ! "$1" =~ ^(backend|frontend|dns|ssl|verify|update|setup)$ ]]; then
    DOMAIN="$1"
    API_DOMAIN="api.$DOMAIN"
    shift
fi

# Run main function
main "$@"