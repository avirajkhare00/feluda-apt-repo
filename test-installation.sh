#!/bin/bash

# Test script for Feluda APT repository installation
# This script tests the complete installation process

set -e

echo "🧪 Testing Feluda APT repository installation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Test 1: Check if repository URL is accessible
echo "📡 Testing repository accessibility..."
REPO_URL="https://raw.githubusercontent.com/avirajkhare00/feluda-apt-repo/main"
if curl -s --head "$REPO_URL" | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null; then
    print_status "Repository URL is accessible"
else
    print_error "Repository URL is not accessible"
    exit 1
fi

# Test 2: Check if GPG key is available
echo "🔑 Testing GPG key availability..."
if curl -s "$REPO_URL/Release.gpg" > /dev/null; then
    print_status "GPG key is available"
else
    print_warning "GPG key not found - repository may not be signed"
fi

# Test 3: Check if package metadata is available
echo "📦 Testing package metadata..."
if curl -s "$REPO_URL/dists/bionic/main/binary-amd64/Packages" > /dev/null; then
    print_status "Package metadata is available"
else
    print_warning "Package metadata not found - repository may be empty"
fi

# Test 4: Simulate installation process
echo "🔧 Simulating installation process..."

# Create temporary directory for testing
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and verify package
echo "📥 Downloading package..."
if curl -s -L "$REPO_URL/pool/main/f/feluda/feluda_1.9.8_amd64.deb" -o feluda.deb; then
    print_status "Package downloaded successfully"

    # Check package structure
    if dpkg-deb -I feluda.deb > /dev/null 2>&1; then
        print_status "Package structure is valid"

        # Check package contents
        if dpkg-deb -c feluda.deb | grep -q "usr/local/bin/feluda"; then
            print_status "Package contains feluda binary"
        else
            print_error "Package does not contain feluda binary"
        fi
    else
        print_error "Package structure is invalid"
    fi
else
    print_warning "Could not download package - may not exist yet"
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Installation test completed!"
echo ""
echo "📋 Summary:"
echo "- Repository accessibility: ✅"
echo "- GPG key availability: $(curl -s "$REPO_URL/Release.gpg" > /dev/null && echo "✅" || echo "⚠️")"
echo "- Package metadata: $(curl -s "$REPO_URL/dists/bionic/main/binary-amd64/Packages" > /dev/null && echo "✅" || echo "⚠️")"
echo "- Package download: $(curl -s -L "$REPO_URL/pool/main/f/feluda/feluda_1.9.8_amd64.deb" > /dev/null && echo "✅" || echo "⚠️")"
echo ""
echo "💡 Next steps:"
echo "1. Push the repository to GitHub"
echo "2. Run the GitHub Actions workflow to build the first package"
echo "3. Test the actual installation on a Debian/Ubuntu system"
