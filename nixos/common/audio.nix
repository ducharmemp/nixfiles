_:
let
  quantum = 64;
  rate = 48000;
  qr = "${toString quantum}/${toString rate}";
in
{
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    extraConfig = {
      pipewire."99-lowlatency" = {
        "context.properties"."default.clock.min-quantum" = quantum;
        "context.modules" = [
          {
            name = "libpipewire-module-rt";
            flags = [
              "ifexists"
              "nofail"
            ];
            args = {
              "nice.level" = -15;
              "rt.prio" = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
          }
        ];
      };

      pipewire-pulse."99-lowlatency"."pulse.properties" = {
        "pulse.min.req" = qr;
        "pulse.min.quantum" = qr;
        "pulse.min.frag" = qr;
      };

      client."99-lowlatency"."stream.properties" = {
        "node.latency" = qr;
        "resample.quality" = 1;
      };
    };
  };
}
