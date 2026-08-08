# nixconfig

NixOS configuration for `desk` and `book` (ASUS Zenbook S 16 UM5606GA).

The Disko, LUKS2, Secure Boot, TPM2, and recovery procedure is in
[install.md](install.md). The `book` host uses Btrfs home snapshots with 24
hourly, 7 daily, and 4 weekly retention points.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#desk
sudo nixos-rebuild switch --flake .#book
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
