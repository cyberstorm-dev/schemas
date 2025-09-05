# Contributing

We welcome contributions to improve the attestor schemas! This guide provides comprehensive guidelines to help you contribute effectively.

## Quick Contributing Flow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Run validation (`task validate`)
5. Commit your changes
6. Push to the branch
7. Open a Pull Request

## Pre-commit Hooks Setup

Set up pre-commit hooks to catch issues early and maintain code quality:

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install the git hook scripts
pre-commit install

# (Optional) Run against all files
pre-commit run --all-files
```

Our pre-commit configuration includes:
- **buf lint**: Ensures proto files follow style guidelines
- **buf format**: Auto-formats proto files
- **buf breaking**: Prevents breaking changes
- **trailing-whitespace**: Removes trailing whitespace
- **end-of-file-fixer**: Ensures files end with newline

## Testing Changes Locally

Before submitting a PR, ensure your changes work across all supported languages:

```bash
# Full validation pipeline
task validate

# Test specific language generations
task generate:typescript
task generate:python
task generate:go

# Run all checks
task check:all

# Test individual languages
cd gen/typescript && npm test
cd gen/python && python -m pytest
cd gen/go && go test ./...
```

## Schema Design Best Practices

When modifying or adding schemas:

### 1. **Backward Compatibility**
- Never remove existing fields
- Never change field numbers
- Use `reserved` for removed fields
- Add new fields with appropriate defaults

```protobuf
message ExampleMessage {
  // Never change this field number
  string existing_field = 1;
  
  // Reserve removed field numbers
  reserved 2;
  reserved "removed_field_name";
  
  // New fields should be optional or have defaults
  optional string new_field = 3;
}
```

### 2. **Naming Conventions**
- Use `snake_case` for field names
- Use `PascalCase` for message and enum names
- Use descriptive, unambiguous names
- Avoid abbreviations unless widely understood

### 3. **Documentation**
- Add comments for all public messages and fields
- Explain complex business logic
- Document field constraints and validations

```protobuf
// Represents a verified contribution to a registered repository
message Contribution {
  // The identity making the contribution (required)
  Identity identity = 1;
  
  // The repository receiving the contribution (required)
  Repository repository = 2;
  
  // URL to the contribution (e.g., GitHub PR/issue URL)
  // Must be a valid HTTPS URL
  string url = 3;
}
```

### 4. **Validation Rules**
Use `buf validate` annotations where possible:

```protobuf
import "validate/validate.proto";

message EmailAddress {
  // Email must be valid format
  string email = 1 [(validate.rules).string.email = true];
  
  // Name must be 1-100 characters
  string name = 2 [(validate.rules).string = {min_len: 1, max_len: 100}];
}
```

## Breaking Change Workflow

We strictly prevent breaking changes to maintain client compatibility:

### Detecting Breaking Changes
```bash
# Our CI automatically runs this on every PR
buf breaking --against '.git#branch=main'

# Check against a specific commit
buf breaking --against '.git#commit=abc123'
```

### If You Must Make Breaking Changes
1. **Create an issue** describing the necessity
2. **Version bump**: Increment the major version in proto packages
3. **Migration guide**: Document how clients should adapt
4. **Deprecation period**: Mark old fields as deprecated first

```protobuf
// Mark for future removal
message OldMessage {
  string deprecated_field = 1 [deprecated = true];
  string new_field = 2;
}
```

## Code Review Process

### What Reviewers Look For
- **Schema design**: Follows best practices and conventions
- **Breaking changes**: Verified as non-breaking
- **Documentation**: Adequate comments and examples
- **Testing**: All generated clients compile and pass tests
- **Performance**: No unnecessary complexity

### Review Checklist
- [ ] `task validate` passes locally
- [ ] No breaking changes detected
- [ ] New fields documented with comments
- [ ] Example usage updated if needed
- [ ] All language bindings generated successfully
- [ ] CI passes all checks

## Contribution Guidelines

### Required Standards
- **Code Quality**: Follow existing code style and patterns
- **Documentation**: Update relevant docs and examples
- **Testing**: Ensure all generated libraries pass tests
- **CI Compliance**: All automated checks must pass

### Supported Changes
- ✅ Adding new messages, fields, or enums
- ✅ Adding validation rules or comments
- ✅ Improving documentation and examples
- ✅ Bug fixes that maintain compatibility

### Prohibited Changes (without major version bump)
- ❌ Removing fields or messages
- ❌ Changing field numbers or types
- ❌ Renaming existing fields
- ❌ Changing semantic meaning of existing fields