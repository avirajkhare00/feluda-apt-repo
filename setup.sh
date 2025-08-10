#!/bin/bash

# Feluda APT Repository Setup Script
# This script helps set up the initial APT repository structure

set -e

echo "🔧 Setting up Feluda APT Repository..."

# Check if reprepro is installed
if ! command -v reprepro &> /dev/null; then
    echo "❌ reprepro is not installed. Please install it first:"
    echo "   sudo apt install reprepro"
    exit 1
fi

# Check if GPG is available
if ! command -v gpg &> /dev/null; then
    echo "❌ GPG is not installed. Please install it first:"
    echo "   sudo apt install gnupg"
    exit 1
fi

echo "✅ Dependencies check passed"

# Generate GPG key if it doesn't exist
if ! gpg --list-keys feluda-apt@example.com &> /dev/null; then
    echo "🔑 Generating GPG key for repository signing..."

    # Create GPG key configuration
    cat > gpg-key-config << EOF
%echo Generating GPG key for Feluda APT repository
Key-Type: RSA
Key-Length: 4096
Name-Real: Feluda APT Repository
Name-Email: feluda-apt@example.com
Expire-Date: 0
%commit
%echo GPG key generation complete
EOF

    # Generate the key
    gpg --batch --generate-key gpg-key-config

    # Clean up
    rm gpg-key-config

    echo "✅ GPG key generated successfully"
else
    echo "✅ GPG key already exists"
fi

# Initialize the repository
echo "📦 Initializing APT repository..."
reprepro -V export

echo "✅ Repository initialized successfully"

# Export the public key
echo "🔑 Exporting public key..."
gpg --armor --export feluda-apt@example.com > Release.gpg

echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Push this repository to GitHub"
echo "2. Add the following secrets to your GitHub repository:"
echo "   - GPG_PRIVATE_KEY: $(gpg --armor --export-secret-key feluda-apt@example.com)"
echo "   - GPG_PASSPHRASE: (if you set one)"
echo "3. Update the repository URL in the README.md file"
echo "4. Test the workflow by running it manually"
echo ""
echo "🔗 Repository URL format:"
echo "   https://raw.githubusercontent.com/YOUR_USERNAME/feluda-apt-repo/master"
