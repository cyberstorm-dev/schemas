#!/bin/bash
set -e

echo "🔍 Checking Go package generation..."

# Check that expected files were generated
if [ ! -f "dist/go/cyberstorm/attestor/v1/messages.pb.go" ]; then
    echo "❌ messages.pb.go not generated"
    exit 1
fi

if [ ! -f "dist/go/cyberstorm/attestor/v1/services.pb.go" ]; then
    echo "❌ services.pb.go not generated"
    exit 1
fi

if [ ! -f "dist/go/cyberstorm/attestor/v1/services_grpc.pb.go" ]; then
    echo "❌ services_grpc.pb.go not generated"
    exit 1
fi

echo "✅ Generated Go files exist:"
ls -la dist/go/cyberstorm/attestor/v1/

# Check that files are valid Go (syntax check)
if command -v go &> /dev/null; then
    echo "📝 Checking Go syntax..."
    
    # Create a temporary go.mod for validation
    cd dist/go
    if [ ! -f go.mod ]; then
        go mod init temp-validation >/dev/null 2>&1
        echo "require google.golang.org/protobuf v1.31.0" >> go.mod
        echo "require google.golang.org/grpc v1.58.0" >> go.mod
        echo "require google.golang.org/genproto/googleapis/api v0.0.0-20230803162519-f966b187b2e5" >> go.mod
    fi
    
    # Try to parse the files (syntax check without building)
    go mod download >/dev/null 2>&1 || echo "⚠️  Could not download dependencies for full validation"
    
    for go_file in cyberstorm/attestor/v1/*.go; do
        if [ -f "$go_file" ]; then
            go fmt "$go_file" >/dev/null 2>&1 || {
                echo "❌ $go_file has syntax errors"
                exit 1
            }
            echo "✅ $(basename "$go_file") has valid syntax"
        fi
    done
    
    # Clean up
    rm -f go.mod go.sum
    cd ../..
else
    echo "⚠️  Go not installed, skipping syntax validation"
fi

# Check file sizes (should not be empty)
for file in dist/go/cyberstorm/attestor/v1/*.go; do
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        echo "❌ $(basename "$file") is empty"
        exit 1
    fi
done

echo "✅ Go package validation complete"