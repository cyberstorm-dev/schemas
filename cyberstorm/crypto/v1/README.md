# Cyberstorm Crypto Schemas
**IPLD Cryptographic Primitives**

Protocol buffer schemas for content-addressed data structures and cryptographic primitives in the Cyberstorm ecosystem.

## What It Does

The Crypto module provides **IPLD (InterPlanetary Linked Data) cryptographic primitives** that enable:

- **Self-Describing Content**: CIDs (Content Identifiers) that contain all necessary addressing information
- **Secure Encryption**: Modern encryption key management with CEK (Content Encryption Key) and KEK (Group Encryption Key)
- **Verifiable Links**: Context references that build cryptographically-verifiable content graphs
- **Decentralized Storage**: Compatible with IPFS and other content-addressed storage systems

## Core Components

- **Content Identifiers (CID)**: Self-describing content addressing with built-in validation
- **Encryption Keys**: CEK/KEK management for content and group-level encryption
- **Context References**: IPLD links for building verifiable content graphs
- **Modern Crypto**: ChaCha20-Poly1305 as the standard for EVM ecosystems
- **Validation Rules**: Built-in field validation using protovalidate

## Why Use Crypto Module?

### For Content Creators
- **Verifiable Content**: Create tamper-proof, content-addressed data structures
- **Secure Sharing**: Modern encryption standards for protecting sensitive content
- **Future-Proof**: Built on IPLD standards for maximum ecosystem compatibility

### For Developers
- **Standard Primitives**: Battle-tested cryptographic building blocks
- **Self-Describing**: No external URI schemes needed - CIDs contain all addressing info
- **Validation Built-In**: Automatic field validation prevents common mistakes

### For Platform Builders
- **Interoperability**: IPLD compatibility enables cross-platform data sharing
- **Decentralized**: No single point of failure for content addressing
- **Modern Standards**: ChaCha20-Poly1305 optimized for blockchain ecosystems

## Usage

### Buf Schema Registry (Recommended)

```bash
# Generate clients
buf generate buf.build/cyberstorm/crypto

# Add as dependency
echo "buf.build/cyberstorm/crypto" >> buf.yaml
```

### Language Clients

**TypeScript/JavaScript**
```typescript
import { 
  CID, 
  ContentEncryptionKey, 
  GroupEncryptionKey,
  ContextReference,
  EncryptionType,
  ReferenceType 
} from 'buf.build/cyberstorm/crypto';

// Create self-describing content identifier
const contentCID = new CID({
  cid: "bafkreig6mqa4p36x77qf5r3r7n4n4k3q3q3q3q3q3q3q3q3q3q3q3q3q"
});

// Set up content encryption with modern cipher
const cek = new ContentEncryptionKey({
  type: EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
  encryptedKey: new Uint8Array([/* encrypted key bytes */])
});

// Create group key for multi-party access
const gek = new GroupEncryptionKey({
  type: EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
  encryptedKey: new Uint8Array([/* encrypted group key */]),
  groupId: "project-contributors-2024"
});

// Build content graph with verifiable links
const contextRef = new ContextReference({
  targetCid: relatedContentCID,
  referenceType: ReferenceType.REFERENCE_TYPE_UNSPECIFIED
});
```

**Python**  
```python
from cyberstorm.crypto.v1 import crypto_pb2

# Create IPFS-compatible content identifier
cid = crypto_pb2.CID(
    cid="bafybeihdwdcefgh4dqkjv67uzcmw7ojee6xedzdetojuzjevtenxquvyku"
)

# Set up encryption for sensitive content
content_key = crypto_pb2.ContentEncryptionKey(
    type=crypto_pb2.EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
    encrypted_key=b"encrypted_content_key_material..."
)

# Create group access control
group_key = crypto_pb2.GroupEncryptionKey(
    type=crypto_pb2.EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
    encrypted_key=b"encrypted_group_key_material...",
    group_id="research-team-alpha"
)

# Link related content
context_link = crypto_pb2.ContextReference(
    target_cid=related_cid,
    reference_type=crypto_pb2.ReferenceType.REFERENCE_TYPE_UNSPECIFIED
)
```

**Go**
```go
import (
    cryptov1 "buf.build/cyberstorm/crypto/cyberstorm/crypto/v1"
)

// Self-describing content addressing
contentID := &cryptov1.CID{
    Cid: "bafkreiewc7stgzjysxkzqxqzqxqzqxqzqxqzqxqzqxqzqxqzqxqzqxqzq",
}

// Modern encryption for EVM ecosystems
contentKey := &cryptov1.ContentEncryptionKey{
    Type: cryptov1.EncryptionType_ENCRYPTION_TYPE_CHACHA20_POLY1305,
    EncryptedKey: []byte("encrypted_key_material_here..."),
}

// Multi-party group access
groupKey := &cryptov1.GroupEncryptionKey{
    Type: cryptov1.EncryptionType_ENCRYPTION_TYPE_CHACHA20_POLY1305,
    EncryptedKey: []byte("encrypted_group_key_material..."),
    GroupId: "dao-contributors",
}

// Build verifiable content graphs
contextRef := &cryptov1.ContextReference{
    TargetCid: targetContentID,
    ReferenceType: cryptov1.ReferenceType_REFERENCE_TYPE_UNSPECIFIED,
}
```

## IPLD Integration

Built for **[IPLD](https://ipld.io/)** compatibility, enabling:

### Self-Describing CIDs
```
CID = version + codec + hash function + hash digest
```

**Benefits**:
- **No URI schemes needed**: All addressing information is self-contained
- **Version agnostic**: Forward-compatible with IPLD evolution
- **Codec flexible**: Supports multiple content formats (DAG-CBOR, DAG-JSON, etc.)
- **Hash agnostic**: Not tied to any specific hash function

### Content Graphs
- **Merkle DAG structures**: Build verifiable data structures
- **Cryptographic links**: Each reference is content-addressed
- **Decentralized verification**: No trusted third parties needed
- **Efficient deduplication**: Identical content has identical CIDs

## Real-World Use Cases

### Verifiable Reputation Data
```typescript
// Content-address contribution attestations
const attestationCID = new CID({
  cid: "bafkreig6mqa4p36x77qf5r3r7n4n4k3q3q3q3q3q3q3q3q3q3q3q3q3q"
});

// Link to supporting evidence
const evidenceRef = new ContextReference({
  targetCid: prDiffCID,
  referenceType: ReferenceType.REFERENCE_TYPE_UNSPECIFIED
});
```

### Encrypted Project Data
```python
# Encrypt sensitive project documents
project_key = crypto_pb2.ContentEncryptionKey(
    type=crypto_pb2.EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
    encrypted_key=encrypted_project_key
)

# Share access with team
team_key = crypto_pb2.GroupEncryptionKey(
    type=crypto_pb2.EncryptionType.ENCRYPTION_TYPE_CHACHA20_POLY1305,
    encrypted_key=encrypted_team_key,
    group_id="project-phoenix-core-team"
)
```

### Decentralized Content Networks
```go
// Build content discovery networks
contentNode := &cryptov1.ContextReference{
    TargetCid: &cryptov1.CID{
        Cid: "bafybeihdwdcefgh4dqkjv67uzcmw7ojee6xedzdetojuzjevtenxquvyku",
    },
    ReferenceType: cryptov1.ReferenceType_REFERENCE_TYPE_UNSPECIFIED,
}
```

## Encryption Standards

### ChaCha20-Poly1305 (Recommended)
- **Modern AEAD cipher**: Authenticated encryption with associated data
- **EVM Optimized**: Efficient on blockchain virtual machines
- **Security**: Resistant to timing attacks, constant-time operations
- **Performance**: Faster than AES on platforms without hardware acceleration

### AES-256-GCM (Legacy Support)
- **Industry Standard**: Widely supported and battle-tested
- **Hardware Acceleration**: Optimized on Intel/AMD processors with AES-NI
- **Compatibility**: Broad ecosystem support for legacy systems

## Getting Started

1. **Set up your development environment**:
   ```bash
   buf generate buf.build/cyberstorm/crypto
   ```

2. **Choose your encryption standard** (ChaCha20-Poly1305 recommended for new projects)

3. **Create content-addressed data** using CIDs for tamper-proof content

4. **Build verifiable links** between related content using ContextReference

5. **Integrate with IPFS** or other content-addressed storage systems

## Related Projects

- **[IPLD](https://ipld.io/)**: InterPlanetary Linked Data specifications
- **[IPFS](https://ipfs.io/)**: InterPlanetary File System for decentralized storage
- **[Cyberstorm Attestor](../../../attestor/v1/README.md)**: Reputation engine that uses crypto primitives

## Repository

Part of the [Cyberstorm Schemas](https://github.com/cyberstorm-dev/schemas) monorepo.

## License

MIT License - see [LICENSE](LICENSE) file.