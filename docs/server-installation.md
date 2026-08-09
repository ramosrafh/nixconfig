# Instalação do `server`

O instalador apaga completamente o SSD selecionado e cria:

- partição EFI de 2 GiB;
- LUKS2 no restante do SSD;
- Btrfs separado por política: sistema, estado persistente, K3s e dados de
  serviços em `/srv`;
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

Tenha disponível a chave pública SSH da máquina administrativa. O nome do
arquivo não é obrigatório: `id_ed25519.pub` é apenas o nome padrão sugerido
pelo OpenSSH. Por exemplo, para criar uma chave exclusiva para o homelab:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/homelab_server -C "homelab-server"
```

Passe ao instalador o arquivo público terminado em `.pub`; mantenha o arquivo
sem `.pub` somente na máquina administrativa:

```bash
sudo -i
cd /tmp/nixconfig
bash scripts/install-server /dev/sda /home/seu-usuario/.ssh/homelab_server.pub
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

O comando mostra uma URL para concluir o login em outro dispositivo. Assim que
o peer aparecer como conectado no painel do NetBird, obtenha o IP do servidor
com `netbird status`. De qualquer dispositivo conectado à mesma rede NetBird e
autorizado pela política:

```bash
ssh -i ~/.ssh/homelab_server ramos@IP_NETBIRD_DO_SERVER
```

O SSH aceita somente chave e a porta 22 está liberada apenas na interface
NetBird `wt0`. Depois do primeiro registro, o serviço reconecta automaticamente
a cada boot. Antes de configurar o desbloqueio TPM2, cada reinício ainda exige
a senha LUKS no console; depois dele, basta `sudo reboot` e aguardar o servidor
voltar à rede. Comandos diretos de desligamento são bloqueados no `sudo` para
evitar desligamentos remotos acidentais, enquanto o reinício continua permitido.

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
sudo cryptsetup open --test-passphrase /dev/disk/by-partlabel/cryptroot
sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-with-pin=false \
  --tpm2-pcrs=7 \
  /dev/disk/by-partlabel/cryptroot
```

O PCR 7 vincula o desbloqueio à política e às chaves do Secure Boot. O measured
boot avançado permanece desativado somente neste host porque o firmware gera um
event log incompatível com `systemd-pcrlock`.

Reinicie e confirme o desbloqueio automático. A senha e a recovery key
continuam disponíveis como fallback.

## Conferência

```bash
findmnt / /boot /nix /var/log /var/lib /var/lib/rancher/k3s /srv
systemctl status netbird sshd k3s
systemctl --failed
```
