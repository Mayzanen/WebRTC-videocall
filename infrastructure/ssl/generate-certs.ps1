# SSL Certificate Generation Script for Development (PowerShell)
# Generates self-signed certificates for WebRTC (requires HTTPS)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CertDir = $ScriptDir

Write-Host "🔐 Generating self-signed SSL certificates for development..." -ForegroundColor Cyan
Write-Host "📁 Certificate directory: $CertDir" -ForegroundColor Gray
Write-Host ""

# Check if OpenSSL is available
$opensslPath = Get-Command openssl -ErrorAction SilentlyContinue

if (-not $opensslPath) {
	Write-Host "❌ OpenSSL not found!" -ForegroundColor Red
	Write-Host ""
	Write-Host "Please install OpenSSL:" -ForegroundColor Yellow
	Write-Host "  - Windows: choco install openssl OR download from https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Gray
	Write-Host "  - Or use WSL and run the bash script instead" -ForegroundColor Gray
	exit 1
}

# Generate private key
Write-Host "Generating private key..." -ForegroundColor Yellow
& openssl genrsa -out "$CertDir/server.key" 2048 2>$null

# Generate certificate signing request
Write-Host "Generating certificate signing request..." -ForegroundColor Yellow
& openssl req -new -key "$CertDir/server.key" `
  -out "$CertDir/server.csr" `
  -subj "/C=FI/ST=Helsinki/L=Helsinki/O=VideoRTC Dev/OU=Development/CN=videocall.local" 2>$null

# Create temporary config file for SAN
$sanConfig = @"
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = FI
ST = Helsinki
L = Helsinki
O = VideoRTC Dev
OU = Development
CN = videocall.local

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = videocall.local
DNS.2 = localhost
IP.1 = 127.0.0.1
IP.2 = 91.157.161.57
"@

$tempConfig = "$CertDir/temp_openssl.cnf"
$sanConfig | Out-File -FilePath $tempConfig -Encoding ASCII

# Generate self-signed certificate (valid for 365 days)
Write-Host "Generating self-signed certificate..." -ForegroundColor Yellow
& openssl x509 -req -days 365 `
  -in "$CertDir/server.csr" `
  -signkey "$CertDir/server.key" `
  -out "$CertDir/server.crt" `
  -extensions v3_req `
  -extfile $tempConfig 2>$null

# Create .pem file (some services prefer this format)
Write-Host "Creating combined PEM file..." -ForegroundColor Yellow
Get-Content "$CertDir/server.crt", "$CertDir/server.key" | Set-Content "$CertDir/server.pem"

# Clean up temporary files
Remove-Item $tempConfig -ErrorAction SilentlyContinue
Remove-Item "$CertDir/server.csr" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "✅ SSL certificates generated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Generated files:" -ForegroundColor Cyan
Write-Host "  - server.key (private key)" -ForegroundColor Gray
Write-Host "  - server.crt (certificate)" -ForegroundColor Gray
Write-Host "  - server.pem (combined)" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  NOTE: These are self-signed certificates for DEVELOPMENT only." -ForegroundColor Yellow
Write-Host "    Your browser will show a security warning - you need to accept it." -ForegroundColor Yellow
Write-Host ""
Write-Host "Firefox: Click 'Advanced' -> 'Accept the Risk and Continue'" -ForegroundColor Gray
Write-Host "Chrome:  Click 'Advanced' -> 'Proceed to videocall.local (unsafe)'" -ForegroundColor Gray
Write-Host "Safari:  Click 'Show Details' -> 'visit this website'" -ForegroundColor Gray
