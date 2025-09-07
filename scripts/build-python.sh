#!/bin/bash
set -e

echo "🔨 Building Python distribution packages..."

# Create __init__.py files for proper Python package structure
echo "Creating __init__.py files..."
find dist/python -type d -name "*" -exec touch {}/__init__.py \;

echo "Installing build tools..."
# Use cross-platform pip detection (venv should already exist from install:python task)
if [ -f "./venv/bin/pip" ]; then
    ./venv/bin/pip install -e ".[build]" --quiet
elif [ -f "./venv/Scripts/pip" ]; then
    # Windows path
    ./venv/Scripts/pip install -e ".[build]" --quiet
else
    echo "Error: Virtual environment not found or not set up properly"
    echo "Make sure install:python task runs before this script"
    ls -la ./venv/ 2>/dev/null || echo "venv directory does not exist"
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf dist/python-dist/ build/

# Build the distribution
echo "Building wheel and source distribution..."
if [ -f "./venv/bin/python" ]; then
    ./venv/bin/python -m build --outdir dist/python-dist/
elif [ -f "./venv/Scripts/python" ]; then
    ./venv/Scripts/python -m build --outdir dist/python-dist/
else
    python3 -m build --outdir dist/python-dist/
fi

echo "✅ Python packages built in dist/python-dist/:"
ls -la dist/python-dist/