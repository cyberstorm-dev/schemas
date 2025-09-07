# Cyberstorm Attestor Schemas
**The Reputation Engine**

Protocol buffer schemas for the Cyberstorm attestation service - the foundational infrastructure for building verifiable professional reputation as an asset class.

## What It Does

The Attestor module powers the **three-step reputation network** that transforms your GitHub contributions into cryptographically-verified professional credentials:

### 1. **Identity Registration**
Link your GitHub account to an Ethereum address with cryptographic proof, creating a verifiable bridge between your development identity and blockchain-based credentials.

### 2. **Repository Registration** 
Project maintainers register their repositories on-chain, establishing them as legitimate sources of verifiable contributions within the reputation network.

### 3. **Contribution Attestation**
High-value contributions (PRs, issues, code reviews) are automatically converted to EAS attestations, creating portable reputation that follows developers throughout their careers.

## Core Components

- **Identity System**: Decentralized identity linking with cryptographic proof validation
- **Repository Registry**: On-chain repository registration with ownership verification
- **Contribution Tracking**: Structured data for pull requests, issues, and code reviews
- **Webhook Processing**: Real-time GitHub event processing for automated attestation
- **EAS Integration**: Built on [Ethereum Attestation Service](https://attest.sh/) for maximum interoperability

## Why Use Attestor Module?

### For Repository Maintainers
- **Attract Contributors**: Make your project more valuable by offering verifiable reputation rewards
- **Build Community**: Create measurable value for contributors beyond traditional recognition
- **Future-Proof**: Participate in the growing ecosystem of reputation-aware hiring and collaboration

### For Developers
- **Portable Reputation**: Your contributions follow you across companies, platforms, and careers
- **Proof of Expertise**: Demonstrate technical skills with cryptographic proof, not just claims
- **Network Effects**: Join an ecosystem where verified reputation creates measurable professional value

### For Platform Builders
- **Rich Data**: Access structured contribution data with cryptographic verification
- **Network Effects**: Build on a growing ecosystem of verified developer reputation
- **Standards-Based**: Leverage EAS compatibility for maximum interoperability

## Usage

### Buf Schema Registry (Recommended)

```bash
# Generate clients
buf generate buf.build/cyberstorm/attestor

# Add as dependency  
echo "buf.build/cyberstorm/attestor" >> buf.yaml
```

### Language Clients

**TypeScript/JavaScript**
```typescript
import { 
  Identity, 
  Domain, 
  Repository,
  PullRequestContribution,
  PullRequestEvent 
} from 'buf.build/cyberstorm/attestor';

// Register developer identity
const identity = new Identity({
  domain: new Domain({ name: 'GitHub', domain: 'github.com' }),
  identifier: 'alice-dev',
  registrant: '0x742d35Cc6634C0532925a3b8D16f5a2C01234567',
  proofUrl: 'https://gist.github.com/alice-dev/proof-of-ownership...',
  validator: '0x8ba1f109551bD432803012645Hac189451c24567'
});

// Register repository for contribution tracking
const repo = new Repository({
  repository: {
    domain: new Domain({ name: 'GitHub', domain: 'github.com' }),
    path: 'awesome-org/amazing-project'
  },
  registrant: maintainerIdentity,
  proofUrl: 'https://github.com/awesome-org/amazing-project/issues/42'
});

// Attest to merged pull request
const contribution = new PullRequestContribution({
  contribution: {
    identity: developerIdentity,
    repository: registeredRepo,
    url: 'https://github.com/awesome-org/amazing-project/pull/123'
  },
  eventType: PullRequestEvent.PULL_REQUEST_EVENT_MERGED,
  commitHash: 'a1b2c3d4e5f6789...',
  reviewedBy: [reviewerIdentity1, reviewerIdentity2]
});
```

**Python**
```python
from cyberstorm.attestor.v1 import (
    identity_pb2, 
    repository_pb2, 
    webhook_pb2
)

# Link GitHub account to Ethereum address
identity = identity_pb2.Identity(
    domain=identity_pb2.Domain(name='GitHub', domain='github.com'),
    identifier='bob-developer',
    registrant='0x742d35Cc6634C0532925a3b8D16f5a2C01234567',
    proof_url='https://gist.github.com/bob-developer/ownership-proof...'
)

# Process webhook event for attestation
webhook_event = webhook_pb2.WebhookEvent(
    event_type=webhook_pb2.WebhookEventType.WEBHOOK_EVENT_TYPE_PULL_REQUEST,
    repository=registered_repository,
    payload=pr_payload,
    timestamp=int(time.time())
)
```

**Go**
```go
import (
    attestorv1 "buf.build/cyberstorm/attestor/cyberstorm/attestor/v1"
    "google.golang.org/protobuf/types/known/timestamppb"
)

// Register repository for contribution tracking
repoRegistration := &attestorv1.Repository{
    Repository: &attestorv1.RepositoryReference{
        Domain: &attestorv1.Domain{
            Name:   "GitHub",
            Domain: "github.com",
        },
        Path: "cyberstorm-dev/awesome-project",
    },
    Registrant: maintainerIdentity,
    ProofUrl:   "https://github.com/cyberstorm-dev/awesome-project/issues/1",
    RegisteredAt: timestamppb.Now(),
}

// Create contribution attestation
contribution := &attestorv1.Contribution{
    Identity:   developerIdentity,
    Repository: registeredRepository,
    Url:        "https://github.com/cyberstorm-dev/awesome-project/pull/42",
    CreatedAt:  timestamppb.Now(),
}
```

## Getting Started

1. **Set up your development environment**:
   ```bash
   buf generate buf.build/cyberstorm/attestor
   ```

2. **Register your identity** (developers) or **register your repository** (maintainers)

3. **Integrate with [cyberstorm-attestor](https://github.com/cyberstorm-dev/attestor)** service for automated attestation processing

4. **Start building** reputation-aware applications with verified contribution data

## Architecture

Built on **[Ethereum Attestation Service (EAS)](https://attest.sh/)** schemas, providing:

- **Cryptographic Verification**: All attestations are cryptographically signed and verifiable
- **Decentralized Storage**: Attestations live on-chain, not controlled by any platform
- **Standard Compatibility**: EAS-compatible for maximum ecosystem interoperability
- **Future-Proof**: Built on proven blockchain infrastructure

### Integration Points

- **GitHub Webhooks**: Real-time processing of contribution events
- **EAS Schemas**: Direct compatibility with Ethereum Attestation Service
- **Multi-Chain Support**: Extensible to other blockchain ecosystems
- **IPFS Storage**: Optional decentralized storage for larger payloads

## Related Projects

- **[cyberstorm-attestor](https://github.com/cyberstorm-dev/attestor)**: The service that processes GitHub webhooks and creates attestations
- **[cyberstorm-attestor-client](https://github.com/cyberstorm-dev/attestor-client)**: Client libraries for easy integration
- **[Ethereum Attestation Service](https://attest.sh/)**: The underlying attestation infrastructure

## Repository

Part of the [Cyberstorm Schemas](https://github.com/cyberstorm-dev/schemas) monorepo.

## License

MIT License - see [LICENSE](LICENSE) file.