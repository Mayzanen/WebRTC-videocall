#!/bin/bash

# SSL Certificate Generation Script for Development
# Generates self-signed certificates for WebRTC (requires HTTPS)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="$SCRIPT_DIR"

echo "🔐 Generating self-signed SSL certificates for development..."
echo "📁 Certificate directory: $CERT_DIR"

# Generate private key
openssl genrsa -out "$CERT_DIR/server.key" 2048

# Generate certificate signing request
openssl req -new -key "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.csr" \
  -subj "/C=FI/ST=Helsinki/L=Helsinki/O=VideoRTC Dev/OU=Development/CN=videocall.local"

# Generate self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 \
  -in "$CERT_DIR/server.csr" \
  -signkey "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -extfile <(printf "subjectAltName=DNS:videocall.local,DNS:localhost,IP:127.0.0.1,IP:91.157.161.57")

# Create .pem file (some services prefer this format)
cat "$CERT_DIR/server.crt" "$CERT_DIR/server.key" > "$CERT_DIR/server.pem"

# Set appropriate permissions
chmod 644 "$CERT_DIR/server.crt"
chmod 600 "$CERT_DIR/server.key"
chmod 600 "$CERT_DIR/server.pem"

echo "✅ SSL certificates generated successfully!"
echo ""
echo "Generated files:"
echo "  - server.key (private key)"
echo "  - server.crt (certificate)"
echo "  - server.pem (combined)"
echo ""
echo "⚠️  NOTE: These are self-signed certificates for DEVELOPMENT only."
echo "    Your browser will show a security warning - you need to accept it."
echo ""
echo "Firefox: Click 'Advanced' -> 'Accept the Risk and Continue'"
echo "Chrome:  Click 'Advanced' -> 'Proceed to videocall.local (unsafe)'"
echo "Safari:  Click 'Show Details' -> 'visit this website'"
