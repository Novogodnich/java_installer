# Java Installer

A Bash script that installs Java directly from official [Eclipse Adoptium](https://adoptium.net/) binaries.

### Features
- Supports JDK and JRE installation.
- Allows selecting the Java version.
- Automatically detects system architecture (`x64` and `aarch64`).
- Integrates Java with `update-alternatives`.
- Sets the newly installed version as the default.

### Requirements
- Linux
- Root privileges
- `curl`, `tar` and `update-alternatives`

### Usage

```bash
chmod +x install-java.sh
sudo ./install-java.sh
```

Follow the prompts to select the package type and Java version.

### Source

Java binaries are downloaded directly from the official Eclipse Adoptium API.
### Supported Distributions
All Debian-based distributions using `apt` and `update-alternatives`. Like:
- Ubuntu
- Debian

### Supported Architectures
- `x86_64` / `amd64`
- `aarch64` / `arm64`
### License
Distributed under MIT license
