_: {
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      formatter = pkgs.writeShellApplication {
        name = "nixfmt-wrapper";

        runtimeInputs = with pkgs; [
          fd
          nixfmt-rfc-style
        ];

        text = ''
          fd "$@" -t f -e nix -x nixfmt '{}'
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          statix
          deadnix
          shellcheck
          nil
        ];
      };
    };
}
