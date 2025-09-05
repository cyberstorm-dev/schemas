#!/bin/bash
set -e

# Convert Swagger 2.0 to OpenAPI 3.0 using npx swagger2openapi
echo "Converting Swagger 2.0 to OpenAPI 3.0..."

# Convert all swagger files using npx (uses locally installed version)
for swagger_file in dist/openapi/*.swagger.json; do
    if [ -f "$swagger_file" ]; then
        openapi_file="${swagger_file%.swagger.json}.openapi.json"
        echo "Converting $(basename "$swagger_file") -> $(basename "$openapi_file")..."
        npx swagger2openapi "$swagger_file" --outfile "$openapi_file" >logs/swagger-convert.log 2>&1 || {
            echo "⚠️  Conversion failed, check logs/swagger-convert.log"
            exit 1
        }
    fi
done

# Add server configurations to the OpenAPI specs
echo "Adding server configurations..."
for openapi_file in dist/openapi/*.openapi.json; do
    if [ -f "$openapi_file" ]; then
        echo "Adding servers to $(basename "$openapi_file")..."
        # Use jq to add servers array after the info section
        jq '. + {
            "servers": [
                {
                    "url": "http://localhost:6001",
                    "description": "Local development server"
                },
                {
                    "url": "https://attestor.staging.cyberstorm.dev",
                    "description": "Staging environment"
                },
                {
                    "url": "https://attestor.cyberstorm.dev",
                    "description": "Production environment"
                }
            ]
        }' "$openapi_file" > "${openapi_file}.tmp" && mv "${openapi_file}.tmp" "$openapi_file"
    fi
done

echo "✅ Swagger 2.0 to OpenAPI 3.0 conversion complete"