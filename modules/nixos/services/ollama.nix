{ pkgs, ... }: {
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
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}