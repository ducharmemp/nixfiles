
{ inputs, ... }:
{
  flake.homeModules.llms =
    { pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        context = ./claude/context.md;
        rulesDir = ./claude/rules;
      };
    };
}
