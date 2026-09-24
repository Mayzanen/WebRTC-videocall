# SSL Certificates

This directory contains SSL certificates for development.

## Generating Certificates

### Linux/Mac/WSL:
```bash
chmod +x generate-certs.sh
./generate-certs.sh
```

### Windows (PowerShell):
```powershell
.\generate-certs.ps1
```

## Required Files

After running the script, you should have:
- `server.key` - Private key
- `server.crt` - Certificate
- `server.pem` - Combined (used by some services)

## Security Notice

⚠️ **These are self-signed certificates for DEVELOPMENT only!**

- Your browser will show security warnings - you need to accept them
- DO NOT use these certificates in production
- For production, use proper certificates (Let's Encrypt, etc.)

## Browser Trust Instructions

### Firefox
1. Navigate to `https://videocall.local`
2. Click "Advanced"
3. Click "Accept the Risk and Continue"

### Chrome/Edge
1. Navigate to `https://videocall.local`
2. Click "Advanced"
3. Click "Proceed to videocall.local (unsafe)"

### Safari
1. Navigate to `https://videocall.local`
2. Click "Show Details"
3. Click "visit this website"
