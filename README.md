# nixconfig

NixOS configuration for `desk` and `book`.

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
