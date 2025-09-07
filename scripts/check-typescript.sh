#!/bin/bash
set -e

echo "🔍 Checking TypeScript generation..."

# Check that expected files were generated (ConnectRPC generates .ts files)
if [ ! -f "dist/typescript/cyberstorm/attestor/v1/services_connect.ts" ]; then
    echo "❌ services_connect.ts not generated"
    exit 1
fi


echo "✅ Generated files exist:"
find dist/typescript -name "*.ts" -exec ls -la {} \;

# Check that files are valid TypeScript (basic syntax check)
echo "📝 Checking TypeScript syntax..."
if npm list typescript >/dev/null 2>&1; then
    # Use locally installed TypeScript
    npx tsc --noEmit --skipLibCheck dist/typescript/cyberstorm/attestor/v1/services_connect.ts || exit 1
    echo "✅ services_connect.ts has valid syntax"
elif command -v tsc >/dev/null 2>&1; then
    # Use globally installed TypeScript
    tsc --noEmit --skipLibCheck dist/typescript/cyberstorm/attestor/v1/services_connect.ts || exit 1
    echo "✅ services_connect.ts has valid syntax"
else
    echo "⚠️  TypeScript compiler not available, skipping syntax check"
fi

# Check file sizes (should not be empty)
if [ ! -s "dist/typescript/cyberstorm/attestor/v1/services_connect.ts" ]; then
    echo "❌ services_connect.ts is empty"
    exit 1
fi

echo "✅ TypeScript generation validation complete"