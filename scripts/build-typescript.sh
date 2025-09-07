#!/bin/bash
set -e

echo "🔨 Building TypeScript/JavaScript package..."

# Ensure dependencies are installed
npm install --silent

echo "✅ TypeScript/JavaScript package ready for distribution"
echo "Package structure:"
ls -la src/
echo ""
echo "Generated files:"
ls -la dist/typescript/cyberstorm/attestor/v1/