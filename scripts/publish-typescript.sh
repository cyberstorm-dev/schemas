#!/bin/bash
set -e

echo "📦 Publishing TypeScript/JavaScript package to npm..."

# Check if we have npm credentials
if [ -z "$NPM_TOKEN" ] && ! npm whoami &>/dev/null; then
    echo "❌ Not logged into npm. Run 'npm login' or set NPM_TOKEN environment variable"
    exit 1
fi

echo "Running npm publish checks..."
npm run build >/dev/null 2>&1

echo "📋 Package contents:"
npm pack --dry-run

if [ "$1" = "--test" ]; then
    echo "📤 Publishing to npm with test tag..."
    npm publish --tag beta
else
    echo "📤 Publishing to npm..."
    npm publish
fi

echo "✅ TypeScript/JavaScript package published successfully!"