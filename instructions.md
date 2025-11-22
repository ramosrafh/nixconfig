You are a NixOS specialist who writes minimal, clean, best-practices configurations.

Your task:

I want you to generate **all files** for a full NixOS flake repository using this structure as reference only, not that need to be exacly these files:

nixconfig/
├── flake.nix
├── flake.lock
├── hosts/
│   ├── book/
│   │   ├── default.nix
│   │   └── hardware.nix
│   └── desk/
│       ├── default.nix
│       └── hardware.nix
├── modules/
│   ├── nixos/
│   │   ├── default.nix
│   │   ├── desktop.nix
│   │   ├── niri.nix
│   │   ├── wayland.nix
│   │   ├── fonts.nix
│   │   ├── networking.nix
│   │   ├── docker.nix
│   │   └── users.nix
│   └── home/
│       ├── default.nix
│       ├── helix.nix
│       ├── yazi.nix
│       ├── fuzzel.nix
│       ├── zellij.nix
│       ├── terminal.nix
│       ├── fish.nix
│       ├── waybar.nix
│       └── swww.nix
├── lib/
│   └── default.nix
└── overlays/
    └── default.nix

You must also generate **install.md** containing the complete step-by-step installation procedure for a minimal NixOS system using:

- EFI booting
- LUKS2 full-disk encryption
- LVM2 inside LUKS
- BTRFS with subvolumes:
  @, @home, @nix, @log, @docker
- no-COW for @docker
- zram
- Limine bootloader (this is **mandatory**)
- hardware: desktop has Ryzen 5700X + RX 7800 XT + dual 1440p monitors (165Hz + 170Hz)
- laptop is called **book**
- desktop is called **desk**

The installation.md must contain **only the code and commands required to install NixOS**, NOT Arch Linux. The Arch example shown earlier is only a conceptual reference of how I work, not something to replicate.

The flake must fully integrate all modules and configure everything cleanly and minimally.

For the home-manager modules, base them on the equivalent functionality of my dotfiles (check dotfiles folder for my actual dotfiles that you need to migrate maintaining the configs) for:
- niri
- helix
- fuzzel
- yazi
- zellij
- terminal (alacritty)
- fish (no oh-my-posh or zsh)
- waybar
- swww

The agent must think and fill in all missing pieces: I only provide the structure and requirements.

Your output must be a **complete, ready-to-use repository**, plus install.md.

All output should be in a **single final formatted markdown block** so I can copy it.

Do not include any explanation — only the files and install.md.

And super important: I want simple and clean files, without being super vebose, without unneeded comments and things.

Its important also that you use the beggining of install.md the list of all things i need to change in my flakes files if there is something I need to replace or add before run the installation.
