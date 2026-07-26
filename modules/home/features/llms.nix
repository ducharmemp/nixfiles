_:
{
  flake.homeModules.llms =
    { config, ... }:
    let
      context = ./llms/context.md;
      claude = ./llms/claude.md;
    in
    {
      home.file = {
        "AGENTS.md".source = context;
        ".claude/CLAUDE.md".source = claude;
      };
    };
}
