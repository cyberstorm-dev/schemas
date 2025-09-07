# Frequently Asked Questions

## General Questions

**Q: Why use Protocol Buffers instead of JSON schemas?**

A: Protocol Buffers offer several advantages for the Cyberstorm attestation system:

- **Schema Evolution**: Forward and backward compatibility through field numbering
- **Type Safety**: Strong typing across all supported languages
- **Performance**: Efficient binary serialization for on-chain storage
- **Multi-language Support**: Generate clients for TypeScript, Python, Go automatically
- **Validation**: Built-in validation rules and constraints
- **Tooling**: Professional development tools via buf.build ecosystem

**Q: How do I handle schema evolution?**

A: Follow these practices for safe schema evolution:

```protobuf
message EvolvingMessage {
  // Original fields (never change numbers)
  string name = 1;
  int64 timestamp = 2;
  
  // Reserved for removed fields
  reserved 3, 5;
  reserved "old_field", "deprecated_field";
  
  // New fields (always optional or with defaults)
  optional string description = 4;
  repeated string tags = 6;
  
  // Use oneof for mutually exclusive fields
  oneof kind {
    UserContribution user_contrib = 7;
    SystemContribution system_contrib = 8;
  }
}
```

**Q: What are the performance considerations?**

A: Key performance factors:

- **Message Size**: Keep messages lean for on-chain storage costs
- **Nested Messages**: Minimize deep nesting for faster serialization
- **Repeated Fields**: Use packed encoding for numeric arrays
- **String Fields**: Consider using bytes for large text content
- **Validation**: Complex validation rules add processing overhead

## Development Questions

**Q: How do I test schema changes before submitting a PR?**

A: Use our comprehensive testing workflow:

```bash
# Test all generated languages
task validate

# Test specific scenarios
task generate:typescript && cd gen/typescript && npm test
task generate:python && cd gen/python && python -m pytest
task generate:go && cd gen/go && go test ./...

# Test against real data
buf breaking --against '.git#branch=main'
```

**Q: How do I debug generated clients?**

A: Debugging strategies by language:

**TypeScript/JavaScript**:
```javascript
import { Identity } from '@cyberstorm/attestor-schemas';

// Enable debug logging
const identity = new Identity({
  domain: { name: 'GitHub', domain: 'github.com' },
  identifier: 'test-user'
});

// Inspect serialized data
console.log(identity.toBinary());
console.log(identity.toJsonString());
```

**Python**:
```python
from cyberstorm.attestor.v1 import Identity
import logging

# Enable protobuf logging
logging.basicConfig(level=logging.DEBUG)

identity = Identity()
identity.domain.name = 'GitHub'

# Debug serialization
print(f"Serialized size: {identity.ByteSize()}")
print(f"JSON: {identity}")
```

**Go**:
```go
import (
    "log"
    "google.golang.org/protobuf/proto"
    attestorv1 "github.com/cyberstorm-dev/attestor-schemas/gen/cyberstorm/attestor/v1"
)

identity := &attestorv1.Identity{
    Domain: &attestorv1.Domain{Name: "GitHub"},
}

// Debug serialization
data, _ := proto.Marshal(identity)
log.Printf("Serialized size: %d bytes", len(data))
```

**Q: How do I contribute new message types?**

A: Follow this process for adding new schemas:

1. **Design the schema** with future evolution in mind
2. **Add comprehensive comments** explaining fields and usage
3. **Include validation rules** where appropriate
4. **Add usage examples** in all supported languages
5. **Test thoroughly** across all language bindings
6. **Update documentation** with new message types

## Integration Questions

**Q: How do I integrate these schemas with EAS (Ethereum Attestation Service)?**

A: The schemas are designed to be EAS-compatible:

```javascript
import { SchemaEncoder } from '@ethereum-attestation-service/eas-sdk';
import { Identity } from '@cyberstorm/attestor-schemas';

// Create the identity data
const identity = new Identity({
  domain: { name: 'GitHub', domain: 'github.com' },
  identifier: 'developer123',
  registrant: '0x742d35Cc6634C0532925a3b8D16f5a2C01234567'
});

// Encode for EAS
const schemaEncoder = new SchemaEncoder("bytes data");
const encodedData = schemaEncoder.encodeData([
  { name: "data", value: identity.toBinary(), type: "bytes" }
]);
```

**Q: Can I use these schemas with other blockchain networks?**

A: Yes, the schemas are blockchain-agnostic. While designed for Ethereum/EAS, you can:

- Serialize to any blockchain that supports arbitrary data
- Adapt the address fields for different address formats
- Use with IPFS for off-chain storage with on-chain references
- Integrate with other attestation systems