# Feluda APT Repository Setup Guide

This guide will walk you through setting up the APT repository for Feluda on GitHub.

## Prerequisites

- A GitHub account
- `reprepro` installed on your system
- `gpg` installed on your system
- Basic knowledge of GitHub Actions

## Step 1: Create the APT Repository on GitHub

1. Go to GitHub and create a new repository named `feluda-apt-repo`
2. Make it public (required for raw.githubusercontent.com access)
3. Clone the repository locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/feluda-apt-repo.git
   cd feluda-apt-repo
   ```

## Step 2: Copy the Repository Files

Copy all the files from the `feluda-apt-repo` directory in this project to your new repository:

```bash
cp -r feluda-apt-repo/* /path/to/your/feluda-apt-repo/
```

## Step 3: Set Up GPG Keys

### Option A: Using the Setup Script (Recommended)

1. Make sure you have `reprepro` and `gpg` installed:
   ```bash
   sudo apt install reprepro gnupg
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

3. The script will:
   - Generate a GPG key for repository signing
   - Initialize the APT repository structure
   - Export the public key

### Option B: Manual Setup

1. Generate a GPG key:
   ```bash
   gpg --full-generate-key
   ```
   - Choose RSA and RSA (default)
   - Key size: 4096
   - Expiration: 0 (does not expire)
   - Name: Feluda APT Repository
   - Email: feluda-apt@example.com

2. Initialize the repository:
   ```bash
   reprepro -V export
   ```

3. Export the public key:
   ```bash
   gpg --armor --export feluda-apt@example.com > Release.gpg
   ```

## Step 4: Configure GitHub Secrets

1. Go to your `feluda-apt-repo` repository on GitHub
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secrets:

   **GPG_PRIVATE_KEY**:
   ```bash
   gpg --armor --export-secret-key feluda-apt@example.com
   ```
   Copy the entire output (including `-----BEGIN PGP PRIVATE KEY BLOCK-----` and `-----END PGP PRIVATE KEY BLOCK-----`)

   **GPG_PASSPHRASE**:
   - If you set a passphrase when creating the GPG key, add it here
   - If you didn't set a passphrase, leave this empty

## Step 5: Configure Main Repository Integration

1. Go to your main `feluda` repository on GitHub
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secret:

   **REPO_ACCESS_TOKEN**:
   - Go to Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate a new token with `repo` scope
   - Add the token as `REPO_ACCESS_TOKEN`

## Step 6: Update Repository URLs

1. Update the repository URLs in the following files:
   - `README.md`: Replace `anistark/feluda-apt-repo` with `YOUR_USERNAME/feluda-apt-repo`
   - `test-installation.sh`: Replace the repository URL
   - `.github/workflows/build-deb.yml`: Update the repository reference

2. Update the main Feluda repository workflow:
   - In `.github/workflows/trigger-apt-build.yml`: Update the repository name

## Step 7: Push and Test

1. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Initial APT repository setup"
   git push origin main
   ```

2. Test the repository:
   ```bash
   ./test-installation.sh
   ```

## Step 8: Build the First Package

1. Go to the Actions tab in your `feluda-apt-repo` repository
2. Click "Build and Publish DEB Package"
3. Enter the version number (e.g., "1.9.8")
4. Click "Run workflow"

## Step 9: Test Installation

Once the workflow completes, test the installation on a Debian/Ubuntu system:

```bash
# Add the GPG key
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/feluda-apt-repo/master/public-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/feluda-archive-keyring.gpg

# Add the repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/feluda-archive-keyring.gpg] https://raw.githubusercontent.com/YOUR_USERNAME/feluda-apt-repo/master bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list

# Update and install
sudo apt update
sudo apt install feluda

# Test
feluda --version
```

## Step 10: Update Main Repository README

Add the APT installation instructions to your main Feluda repository README:

```markdown
<details>
<summary>APT Repository (Debian/Ubuntu)</summary>

![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

Feluda is available via APT repository for Debian-based systems:

```bash
# Add the GPG key
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/feluda-apt-repo/master/public-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/feluda-archive-keyring.gpg

# Add the repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/feluda-archive-keyring.gpg] https://raw.githubusercontent.com/YOUR_USERNAME/feluda-apt-repo/master bionic main" | sudo tee /etc/apt/sources.list.d/feluda.list

# Update and install
sudo apt update
sudo apt install feluda
```

</details>
```

## Troubleshooting

### Common Issues

1. **GPG key not found**: Make sure you've exported the correct key and added it to GitHub secrets
2. **Repository not accessible**: Ensure the repository is public
3. **Workflow fails**: Check the GitHub Actions logs for specific error messages
4. **Package not found**: Make sure the workflow completed successfully and the package was added to the repository

### Debugging

- Check the GitHub Actions logs for detailed error messages
- Use the `test-installation.sh` script to verify repository accessibility
- Verify GPG key setup with `gpg --list-keys`

## Maintenance

- The repository will automatically build new packages when you create releases in the main Feluda repository
- You can manually trigger builds from the Actions tab
- Monitor the repository for any issues or updates needed

## Security Considerations

- Keep your GPG private key secure
- Regularly rotate the GPG key if needed
- Monitor the repository for any security issues
- Consider using GitHub's security features like Dependabot alerts
