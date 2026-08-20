{ pkgs, ... }:

let
  # llama.cpp compilado com ROCm, dirigido à 7800 XT (gfx11 / gfx1100)
  llama-cpp-rocm = pkgs.llama-cpp.override {
    rocmSupport = true;
    rocmPackages = pkgs.rocmPackages.gfx11;
  };
in
{
  services.ollama = {
    enable = true;
    # Nova sintaxe: define o pacote com suporte a ROCm diretamente
    package = pkgs.ollama-rocm;

    # Override para RDNA3 (7800XT / gfx1100)
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };

  # Adiciona pacotes ROCm necessários para a GPU
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # Variável de ambiente global para RDNA3 (7800 XT)
  environment.sessionVariables.HSA_OVERRIDE_GFX_VERSION = "11.0.0";

  # Servidor Qwen via llama.cpp, compilado agora com ROCm
  systemd.services.qwen-ai-server = {
    description = "Qwen MoE (llama.cpp) API server";
    wantedBy = [ "multi-user.target" ];
    # Garante que a interface de NetBird já subiu antes de abrir o server.
    after = [ "network-online.target" ];
    environment.HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    script = ''
      ${llama-cpp-rocm}/bin/llama-server \
        -m /var/lib/ai-models/qwen/unsloth-qwen3.6-35b-a3b-q6_k.gguf \
        --host 0.0.0.0 --port 8080 \
        -c 131072 -b 512 -ngl 41 -t 31 -fa \
        --draft-mtp --draft 2 --kv-cache-type q8_0
    '';
    serviceConfig.Restart = "on-failure";
  };

  # Acesso à API through NetBird / LAN
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
