// Main entry point for @cyberstorm-dev/attestor-schemas
// Exports all generated protobuf modules

// Export message types (always works)
const messages = require('../dist/typescript/cyberstorm/attestor/v1/messages_pb');

// Try to export service definitions (may fail if Google API deps missing)
let services;
try {
  services = require('../dist/typescript/cyberstorm/attestor/v1/services_pb');
} catch (err) {
  console.warn('Warning: Could not load services - missing Google API dependencies:', err.message);
  services = null;
}

module.exports = {
  messages,
  services,
  // Convenience exports for common message types
  AttestationValue: messages.AttestationValue,
  Identity: messages.Identity,
  Repository: messages.Repository,
  Contribution: messages.Contribution,
  Domain: messages.Domain,
  // Add other commonly used types as needed
};