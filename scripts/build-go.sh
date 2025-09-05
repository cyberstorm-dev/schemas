#!/bin/bash
set -e

echo "🔨 Building Go module..."

cd dist/go

# Initialize go.mod if needed (should already exist from generate step)
if [ ! -f go.mod ]; then
    echo "❌ go.mod not found. Run 'task generate:go' first."
    exit 1
fi

# Download dependencies
echo "📦 Downloading Go dependencies..."
go mod download

# Tidy up dependencies
echo "🧹 Tidying Go module..."
go mod tidy

# Verify the module builds
echo "🔍 Verifying Go module builds..."
go build ./...

echo "✅ Go module ready for distribution"
echo "Module: $(grep '^module ' go.mod | cut -d' ' -f2)"
echo "Generated files:"
ls -la cyberstorm/attestor/v1/