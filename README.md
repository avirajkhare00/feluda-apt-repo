# Feluda APT Repository

This repository contains the APT repository for installing Feluda on Debian-based systems (Ubuntu, Debian, etc.).

## Installation

### 1. Add the GPG key

```bash
# Get the GPG key
curl -fsSL https://raw.githubusercontent.com/avirajkhare00/feluda-apt-repo/master/Release.gpg | sudo gpg --dearmor -o /usr/share/keyrings/feluda-archive-keyring.gpg
```

### 2. Add the repository

```bash
# Add the repository to your sources
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/feluda-archive-keyring.gpg] https://raw.githubusercontent.com/avirajkhare00/feluda-apt-repo/master bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list
```

### 3. Update and install

```bash
# Update package list
sudo apt update

# Install Feluda
sudo apt install feluda
```

## Usage

After installation, you can use Feluda directly:

```bash
# Basic usage
feluda

# Check specific language
feluda --language rust

# Generate compliance files
feluda generate
```

## Manual Installation

If you prefer to install manually, you can download the `.deb` package directly:

```bash
# Download the latest version
wget https://raw.githubusercontent.com/avirajkhare00/feluda-apt-repo/master/pool/main/f/feluda/feluda_1.9.8_amd64.deb

# Install the package
sudo dpkg -i feluda_1.9.8_amd64.deb

# Fix any missing dependencies
sudo apt-get install -f
```

## Repository Structure

```
feluda-apt-repo/
├── conf/
│   └── distributions    # Repository configuration
├── incoming/           # New packages to be added
├── pool/              # Package pool (auto-generated)
├── dists/             # Distribution metadata (auto-generated)
└── .github/
    └── workflows/
        └── build-deb.yml  # Automated build workflow
```

## Building Packages

This repository uses GitHub Actions to automatically build and publish new packages when Feluda releases are created.

### Manual Build

To build a package manually:

1. Go to the Actions tab in this repository
2. Click "Build and Publish DEB Package"
3. Enter the version number (e.g., "1.9.8")
4. Click "Run workflow"

### Automated Build

The workflow can be triggered automatically by the main Feluda repository when new releases are published.

## GPG Key Management

The repository is signed with a GPG key for security. The public key is available in the repository and should be imported before adding the repository to your system.

## Support

For issues with the APT repository, please open an issue in this repository.

For issues with Feluda itself, please visit the main repository: https://github.com/anistark/feluda
