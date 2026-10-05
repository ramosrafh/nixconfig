{ ... }: {
  nix.settings = {
    experimental-features = [ "fetch-closure" ];
    # Used only to verify the explicitly fetched goose-cli closure.
    trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
