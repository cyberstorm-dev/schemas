#!/bin/bash
set -e

echo "📦 Publishing Python package to PyPI..."

if [ ! -d "dist/python-dist" ]; then
    echo "❌ No distribution files found. Run 'task build:python' first."
    exit 1
fi

# Check if we have credentials based on mode
if [ "$1" = "--test" ]; then
    if [ -z "$TEST_PYPI_API_TOKEN" ]; then
        echo "❌ TEST_PYPI_API_TOKEN environment variable not set"
        echo "Set TEST_PYPI_API_TOKEN to publish to TestPyPI"
        exit 1
    fi
    export TWINE_USERNAME="__token__"
    export TWINE_PASSWORD="$TEST_PYPI_API_TOKEN"
else
    if [ -z "$PYPI_API_TOKEN" ]; then
        echo "❌ PYPI_API_TOKEN environment variable not set"
        echo "Set PYPI_API_TOKEN to publish to PyPI"
        exit 1
    fi
    export TWINE_USERNAME="__token__"
    export TWINE_PASSWORD="$PYPI_API_TOKEN"
fi

echo "Installing twine..."
if [ -f "./venv/bin/pip" ]; then
    ./venv/bin/pip install twine --quiet
    TWINE_CMD="./venv/bin/twine"
elif [ -f "./venv/Scripts/pip" ]; then
    ./venv/Scripts/pip install twine --quiet
    TWINE_CMD="./venv/Scripts/twine"
else
    echo "Error: Could not find pip in virtual environment"
    exit 1
fi

echo "Checking distribution files..."
$TWINE_CMD check dist/python-dist/*

echo "Uploading to PyPI..."
if [ "$1" = "--test" ]; then
    echo "📤 Uploading to TestPyPI..."
    $TWINE_CMD upload --repository testpypi --verbose --skip-existing dist/python-dist/*
else
    echo "📤 Uploading to PyPI..."
    $TWINE_CMD upload --verbose dist/python-dist/*
fi

echo "✅ Python package published successfully!"