#!/bin/bash
set -e

echo "📦 Publishing TypeScript/JavaScript package to npm..."

# Check if we have npm token
if [ -z "$NPM_TOKEN" ]; then
    echo "❌ NPM_TOKEN environment variable not set"
    echo "Set NPM_TOKEN to publish to npm registry"
    exit 1
fi

# Configure npm to use token authentication
echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc
echo "📋 Configured npm authentication with token"

echo "Running npm publish checks..."
npm run build >/dev/null 2>&1

echo "📋 Package contents:"
npm pack --dry-run

if [ "$1" = "--test" ]; then
    echo "📤 Publishing to npm with test tag..."
    npm publish --tag beta --access public
else
    echo "📤 Publishing to npm..."
    npm publish --access public
fi

echo "✅ TypeScript/JavaScript package published successfully!"