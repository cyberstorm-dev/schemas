#!/bin/bash
set -e

# Check if OpenAPI files exist
if [ ! -f dist/openapi/cyberstorm/attestor/v1/services.openapi.json ]; then
    echo "OpenAPI 3.0 files not found. Run 'task generate:openapi' first."
    exit 1
fi

# Set up Swagger UI
echo "Setting up Swagger UI..."
mkdir -p dist/docs
cp templates/swagger-ui.html dist/docs/index.html
# Copy OpenAPI files to be accessible (match GitHub Pages structure)
cp -r dist/openapi dist/docs/

# Serve the docs
echo "🚀 Serving OpenAPI docs at http://localhost:8080"
echo "📖 View interactive API documentation with curl examples"
echo "💡 Uses OpenAPI 3.0 format with native server dropdown"
cd dist/docs && python3 -m http.server 8080