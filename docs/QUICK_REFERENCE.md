# Quick Reference

## Essential Commands

```bash
# Setup and Installation
git clone https://github.com/cyberstorm-dev/attestor-schemas.git
cd attestor-schemas
task deps                    # Install dependencies
task build                   # Generate all language bindings

# Development Workflow
task validate                # Run full validation pipeline
task lint                    # Lint proto files
task format                  # Format proto files
task generate:all           # Generate all language clients

# Language-specific Generation
task generate:typescript     # Generate TypeScript/JavaScript
task generate:python        # Generate Python
task generate:go            # Generate Go

# Testing and Validation
task check:all              # Test all generated libraries
buf breaking --against '.git#branch=main'  # Check for breaking changes
pre-commit run --all-files  # Run pre-commit hooks

# Publishing
task publish:typescript     # Publish to npm
task publish:python        # Publish to PyPI
./scripts/publish-go.sh v1.0.0  # Tag and publish Go module
```

## Package Installation

```bash
# TypeScript/JavaScript
npm install @cyberstorm/attestor-schemas

# Python
pip install cyberstorm-attestor-schemas

# Go
go get github.com/cyberstorm-dev/attestor-schemas
```

## Common Import Patterns

**TypeScript/JavaScript**:
```typescript
import { 
  Identity, 
  Repository, 
  PullRequestContribution,
  Domain 
} from '@cyberstorm/attestor-schemas';
```

**Python**:
```python
from cyberstorm.attestor.v1 import (
    Identity,
    Repository, 
    PullRequestContribution,
    Domain
)
```

**Go**:
```go
import attestorv1 "github.com/cyberstorm-dev/attestor-schemas/gen/cyberstorm/attestor/v1"
```

## Schema Structure Overview

```
cyberstorm/attestor/v1/
├── identity.proto          # Identity and domain definitions
├── repository.proto        # Repository registration schemas
├── contribution.proto      # Contribution tracking schemas  
├── webhook.proto          # GitHub webhook event schemas
└── common.proto           # Common types and enums
```

## Validation Rules Quick Reference

```protobuf
import "validate/validate.proto";

message Example {
  // String validation
  string email = 1 [(validate.rules).string.email = true];
  string name = 2 [(validate.rules).string = {min_len: 1, max_len: 100}];
  
  // Numeric validation
  int32 port = 3 [(validate.rules).int32 = {gte: 1, lte: 65535}];
  
  // URL validation
  string url = 4 [(validate.rules).string.uri = true];
  
  // Required fields
  string required_field = 5 [(validate.rules).string.min_len = 1];
  
  // Repeated field validation
  repeated string tags = 6 [(validate.rules).repeated.min_items = 1];
}
```