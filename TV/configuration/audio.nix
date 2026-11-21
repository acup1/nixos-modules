{...}: {
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    # Prefer an available HDMI sink while preserving saved user selections.
    wireplumber.extraConfig."60-tv-hdmi"."monitor.alsa.rules" = [
      {
        matches = [
          {
            "media.class" = "Audio/Sink";
            "node.name" = "~alsa_output[.].*[.][hH][dD][mM][iI].*";
          }
          {
            "media.class" = "Audio/Sink";
            "alsa.name" = "~.*HDMI.*";
          }
        ];
        actions.update-props."priority.session" = 1200;
      }
    ];
  };
}
