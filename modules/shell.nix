{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
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
        packages =
          with pkgs;
          [
            statix
            shellcheck
            nil
          ]
          ++ [
            inputs.agenix.packages.${system}.default
          ];
      };
    };
}
