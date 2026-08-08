# Instalação do `server`

O instalador apaga completamente o SSD selecionado e cria:

- partição EFI de 2 GiB;
- LUKS2 no restante do SSD;
- Btrfs separado por política: sistema, estado persistente, PostgreSQL, K3s e
  dados de serviços em `/srv`;
- Lanzaboote/Secure Boot;
- recovery key do LUKS e desbloqueio TPM2 configurável após o primeiro boot.

## Instalar

No firmware, habilite UEFI e TPM 2.0, mas deixe Secure Boot desativado durante
a instalação. Inicie o NixOS live USB em modo UEFI, conecte a rede e clone este
repositório.

Identifique cuidadosamente o SSD SATA inteiro:

```bash
lsblk -d -e 7 -o NAME,PATH,SIZE,MODEL,SERIAL,TRAN
```

Tenha disponível a chave pública SSH da máquina administrativa e execute:

```bash
sudo -i
cd /tmp/nixconfig
bash scripts/install-server /dev/sda /caminho/para/id_ed25519.pub
```

Prefira `/dev/disk/by-id/...` quando houver mais de um disco conectado. O
script mostra o modelo, serial e capacidade e exige que o caminho seja digitado
novamente antes de apagar qualquer dado.

Durante a instalação, guarde a recovery key do LUKS fora do servidor. Ao fim,
defina a senha local/sudo do usuário e reinicie.

## Primeiro boot e NetBird

O primeiro boot solicita a senha LUKS. Pelo console local:

```bash
sudo netbird up
```

O SSH aceita somente chave e a porta 22 está liberada apenas na interface
NetBird `wt0`.

## Secure Boot

Confira e faça backup criptografado de `/var/lib/sbctl`, depois reinicie no
firmware:

```bash
sudo sbctl status
sudo sbctl verify
systemctl reboot --firmware-setup
```

Coloque o firmware em Setup Mode, preservando as chaves de revogação, inicie o
NixOS e inscreva as chaves:

```bash
sudo sbctl enroll-keys --microsoft
reboot
sudo sbctl status
sudo sbctl verify
```

## TPM2 autounlock

Somente depois de confirmar o Secure Boot ativo e guardar a recovery key:

```bash
PCRLOCK=/run/current-system/systemd/lib/systemd/systemd-pcrlock
"$PCRLOCK" is-supported
sudo test -s /var/lib/systemd/pcrlock.json
sudo cryptsetup open --test-passphrase /dev/disk/by-partlabel/cryptroot
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-with-pin=false \
  --tpm2-pcrlock=/var/lib/systemd/pcrlock.json \
  /dev/disk/by-partlabel/cryptroot
```

Reinicie e confirme o desbloqueio automático. A senha e a recovery key
continuam disponíveis como fallback.

## Conferência

```bash
findmnt / /boot /nix /var/log /var/lib /var/lib/postgresql \
  /var/lib/rancher/k3s /srv
systemctl status netbird sshd k3s
systemctl --failed
```
