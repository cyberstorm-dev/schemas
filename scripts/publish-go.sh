#!/bin/bash
set -e

echo "📦 Publishing Go module..."

# Go modules are published via Git tags, not a package registry
# This script helps create and push the appropriate tags

cd dist/go

if [ -z "$1" ]; then
    echo "❌ Version required. Usage: $0 <version> [--test]"
    echo "Example: $0 v1.0.0"
    exit 1
fi

VERSION="$1"
IS_TEST="$2"

# Validate version format
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+.*$ ]]; then
    echo "❌ Invalid version format. Use semantic versioning with 'v' prefix (e.g., v1.0.0)"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository. Go module publishing requires git tags."
    exit 1
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Uncommitted changes detected. Commit all changes before publishing."
    exit 1
fi

echo "🏷️  Creating Git tag for Go module: $VERSION"

if [ "$IS_TEST" = "--test" ]; then
    echo "📋 Test mode - showing what would be published:"
    echo "Git tag: go/$VERSION"
    echo "Module path: $(grep '^module ' go.mod | cut -d' ' -f2)"
    echo "Files to include:"
    find . -name "*.go" -o -name "go.mod" -o -name "go.sum" | sort
else
    # Create and push the tag
    git tag "go/$VERSION"
    git push origin "go/$VERSION"
    
    echo "✅ Go module published successfully!"
    echo "Import path: $(grep '^module ' go.mod | cut -d' ' -f2)@$VERSION"
fi