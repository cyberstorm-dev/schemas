#!/bin/bash
set -e

echo "🔍 Checking Python package generation..."

# Check that expected files were generated
if [ ! -f "dist/python/cyberstorm/attestor/v1/services_pb2.py" ]; then
    echo "❌ services_pb2.py not generated"
    exit 1
fi

if [ ! -f "dist/python/cyberstorm/attestor/v1/messages_pb2.py" ]; then
    echo "❌ messages_pb2.py not generated"
    exit 1
fi

echo "✅ Generated Python files exist:"
ls -la dist/python/cyberstorm/attestor/v1/

# Test imports
echo "📝 Testing Python imports..."

# Test imports - use venv python if available, otherwise system python
if [ -f "./venv/bin/python" ]; then
    PYTHON_CMD="./venv/bin/python"
elif [ -f "./venv/Scripts/python" ]; then
    PYTHON_CMD="./venv/Scripts/python"
elif command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python"
else
    echo "❌ No Python interpreter found"
    exit 1
fi

$PYTHON_CMD -c "
import sys
sys.path.append('dist/python')
try:
    from cyberstorm.attestor.v1 import services_pb2, messages_pb2
    print('✅ Python imports successful')
    print(f'Services: {len(dir(services_pb2))} attributes')
    print(f'Messages: {len(dir(messages_pb2))} attributes')
except ImportError as e:
    print(f'❌ Import failed: {e}')
    sys.exit(1)
"

# Test namespace cleanup - ensure buf.validate is under cyberstorm namespace
echo "📝 Testing namespace cleanup..."
$PYTHON_CMD -c "
import sys
sys.path.append('dist/python')
try:
    from cyberstorm.buf.validate import validate_pb2
    print('✅ cyberstorm.buf.validate import successful')
except ImportError as e:
    print('❌ cyberstorm.buf.validate import failed:', e)
    sys.exit(1)

# Verify buf namespace is NOT at top level in our package
import os
dist_python_path = 'dist/python'
if os.path.exists(os.path.join(dist_python_path, 'buf')):
    print('❌ Top-level buf namespace found - namespace pollution!')
    sys.exit(1)
else:
    print('✅ No top-level buf namespace - clean package')
"

echo "✅ Python package validation complete"