# nixconfig

NixOS configuration for `desk`, `book` (ASUS Zenbook S 16 UM5606GA), and
`server` (Intel Core i7-6700, 32 GiB RAM, 128 GB SATA SSD).

The Disko, LUKS2, Secure Boot, TPM2, and recovery procedure is in
[docs/book-installation.md](docs/book-installation.md). The `book` host uses Btrfs home snapshots with 24
hourly, 7 daily, and 4 weekly retention points.

The server installation and recovery procedure is in
[docs/server-installation.md](docs/server-installation.md).

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#desk
sudo nixos-rebuild switch --flake .#book
sudo nixos-rebuild switch --flake .#server
```

## Development shells

From a project directory:

```bash
dev driva
dev spark
dev node
```

Python shells use the nearest project containing `uv.lock`, `pyproject.toml`, or
`requirements.txt`. The environment is stored in the project's `.venv` and is
only synchronized when its dependency file changes.

Projects using uv should commit:

```text
.python-version
pyproject.toml
uv.lock
```

Projects using pip should commit `requirements.txt`. Add `.venv/` to each
project's `.gitignore`.

## Validation

```bash
nix flake check --no-build
```
