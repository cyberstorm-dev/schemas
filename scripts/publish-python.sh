#!/bin/bash
set -e

echo "📦 Publishing Python package to PyPI..."

if [ ! -d "dist/python-dist" ]; then
    echo "❌ No distribution files found. Run 'task build:python' first."
    exit 1
fi

# Check if we have credentials
if [ -z "$TWINE_USERNAME" ] && [ -z "$TWINE_PASSWORD" ] && [ ! -f ~/.pypirc ]; then
    echo "❌ No PyPI credentials found. Set TWINE_USERNAME/TWINE_PASSWORD or configure ~/.pypirc"
    exit 1
fi

echo "Checking distribution files..."
./venv/bin/twine check dist/python-dist/*

echo "Uploading to PyPI..."
if [ "$1" = "--test" ]; then
    echo "📤 Uploading to TestPyPI..."
    ./venv/bin/twine upload --repository testpypi dist/python-dist/*
else
    echo "📤 Uploading to PyPI..."
    ./venv/bin/twine upload dist/python-dist/*
fi

echo "✅ Python package published successfully!"