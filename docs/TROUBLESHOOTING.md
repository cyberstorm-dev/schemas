# Troubleshooting

This guide helps resolve common issues when working with the Cyberstorm Attestor Schemas.

## Common Setup Issues

### buf CLI Installation Problems

**Issue**: `buf: command not found`
```bash
# Verify buf is installed
buf --version

# If not found, install via Homebrew (macOS)
brew install bufbuild/buf/buf

# Or download binary directly (Linux/macOS)
curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o "/usr/local/bin/buf"
chmod +x "/usr/local/bin/buf"
```

**Issue**: `buf: permission denied`
```bash
# Make buf executable
sudo chmod +x /usr/local/bin/buf

# Or install in user directory
mkdir -p $HOME/bin
curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o "$HOME/bin/buf"
chmod +x "$HOME/bin/buf"
export PATH="$HOME/bin:$PATH"
```

### Protocol Buffer Generation Errors

**Issue**: `protoc-gen-*: program not found`
```bash
# For TypeScript/JavaScript
npm install -g @bufbuild/protoc-gen-es @bufbuild/protoc-gen-connect-es

# For Python
pip install grpcio-tools

# For Go
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

**Issue**: `buf lint` failures
```bash
# Check specific lint rules
buf lint --error-format=json

# Fix common issues automatically
buf format -w

# See which rules are failing
buf lint --config '{"version":"v1","lint":{"use":["DEFAULT"],"except":["FIELD_LOWER_SNAKE_CASE"]}}'
```

### Build Failures on Different Platforms

**Issue**: Go build fails on Windows
```bash
# Use forward slashes in import paths
go mod tidy
go clean -modcache
go build ./...
```

**Issue**: Python import errors
```bash
# Ensure package is properly installed
pip install -e .

# Clear Python cache
find . -name "*.pyc" -delete
find . -name "__pycache__" -type d -exec rm -rf {} +

# Reinstall dependencies
pip install --force-reinstall -r requirements.txt
```

### Virtual Environment Issues (Python)

**Issue**: `venv` activation fails
```bash
# macOS/Linux
python3 -m venv venv
source venv/bin/activate

# Windows Command Prompt
python -m venv venv
venv\Scripts\activate.bat

# Windows PowerShell
python -m venv venv
venv\Scripts\Activate.ps1
```

**Issue**: Package not found in virtual environment
```bash
# Verify you're in the right environment
which python
python -m pip list

# Install in development mode
pip install -e .

# Or install requirements
pip install -r requirements.txt
```

## Performance Issues

**Issue**: Slow buf generate
```bash
# Use parallel generation (if supported)
buf generate --template buf.gen.yaml

# Clear buf cache
buf mod cache clear

# Use specific output directory
buf generate --template buf.gen.yaml -o gen/
```

**Issue**: Large generated files
```bash
# Consider splitting large proto files
# Use buf breaking to ensure compatibility
buf breaking --against '.git#branch=main'

# Optimize imports
buf mod prune
```

## Debugging Generated Clients

**Issue**: TypeScript types are incorrect
```bash
# Regenerate with latest protoc-gen-es
npm install -g @bufbuild/protoc-gen-es@latest
buf generate

# Check generated types
npx tsc --noEmit
```

**Issue**: Python stubs missing
```bash
# Install with type stubs
pip install types-protobuf mypy-protobuf

# Generate with stubs
buf generate --template buf.gen.yaml
```

**Issue**: Go module path issues
```bash
# Ensure go.mod has correct module path
go mod init github.com/your-org/your-project

# Update imports in generated files
go mod tidy
```