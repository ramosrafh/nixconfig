{ ... }: {
  # Ajustes de Bluetooth para estabilizar a troca A2DP <-> HFP
  # (ex.: HUAWEI FreeBuds Pro 5, cuja negociacao HFP travava o mic no
  # Meet/Teams). Mantem A2DP de alta qualidade fora de chamadas e troca
  # para HFP apenas enquanto o microfone esta em uso.
  xdg.configFile."wireplumber/wireplumber.conf.d/51-bluetooth.conf".text = ''
    monitor.bluez.properties = {
      # Backend HFP nativo (do PipeWire) em vez de oFono/hsphfpd.
      bluez5.hfphsp-backend = "native"
      # Desabilita mSBC no HFP: ele nao fecha o transporte SCO neste
      # controlador + FreeBuds Pro 5 (erro "Failure in Bluetooth audio
      # transport" / "port_set_param Format: Invalid argument"), travando
      # o mic no Meet/Teams. Sem mSBC o HFP usa CVSD (mono/banda estreita),
      # que e estavel. Os codecs A2DP de alta qualidade seguem intactos
      # fora de chamadas.
      bluez5.enable-msbc = false
      # Habilita SBC-XQ e volume por hardware.
      bluez5.enable-sbc-xq = true
      bluez5.enable-hw-volume = true
      # Papeis habilitados (inclui HFP handsfree).
      bluez5.roles = [ "a2dp_sink" "a2dp_source" "hfp_hf" "hfp_ag" ]
    }

    wireplumber.settings = {
      # Mantem o autoswitch ligado: mostra o microfone e troca para HFP
      # ao gravar; volta para A2DP quando o mic nao esta mais em uso.
      bluetooth.autoswitch-to-headset-profile = true
      # Prioriza latencia na selecao de perfil, o que simplifica a
      # negociacao HFP e tende a destravar a troca.
      bluetooth.profile-preference = "latency"
    }
  '';
}
