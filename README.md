# Feluda APT Repository

This repository contains the APT repository for installing Feluda on Debian-based systems (Ubuntu, Debian, etc.).

## 📦 Installation

### 1. Add the GPG key

**Method A: Import Public Key (Recommended)**
```bash
# Download and import the public GPG key
curl -fsSL https://avirajkhare00.github.io/feluda-apt-repo/public-gpg.gpg | sudo apt-key add -
```

**Method B: Use Keyring (More Secure)**
```bash
# Download signature to keyring
curl -fsSL https://avirajkhare00.github.io/feluda-apt-repo/dists/bionic/Release.gpg | sudo gpg --dearmor -o /usr/share/keyrings/feluda-archive-keyring.gpg
```

### 2. Add the repository

**If using Method A (apt-key):**
```bash
# Add the repository to your sources
echo "deb [arch=amd64] https://avirajkhare00.github.io/feluda-apt-repo/ bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list
```

**If using Method B (keyring):**
```bash
# Add the repository to your sources
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/feluda-archive-keyring.gpg] https://avirajkhare00.github.io/feluda-apt-repo/ bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list
```

### 3. Update and install

```bash
sudo apt update
sudo apt install feluda
```

### Alternative: Unsigned Repository (if GPG doesn't work)

If you're having issues with GPG keys, you can use the unsigned repository:

```bash
# Add the repository without GPG verification
echo "deb [trusted=yes] https://avirajkhare00.github.io/feluda-apt-repo/ bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list

# Update and install
sudo apt update
sudo apt install feluda
```

**Note**: This method is less secure but will work if GPG signing isn't set up yet or if you encounter GPG verification issues.

## 🚀 Usage

After installation, you can use Feluda directly:

```bash
# Basic usage
feluda

# Check specific language
feluda --language rust

# Generate compliance files
feluda generate
```

## 🔧 For Maintainers

To build new packages:
1. Go to Actions → "Build and Publish DEB Package"
2. Enter version number and run workflow

For setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md).

## Support

For issues with the APT repository, please open an issue in this repository.

For issues with Feluda itself, please visit the main repository: https://github.com/anistark/feluda
