_:
{
  flake.homeModules.sketchybar =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        sketchybar-app-font
        nowplaying-cli
        switchaudio-osx
        sbarlua
        # sbarlua is built against Lua 5.5 (pkgs.sbarlua == lua5.5-sbarLua), so
        # the interpreter, the sketchybarrc shebang, and the cpath below must all
        # use lua5_5 or `require("sketchybar")` fails and the bar stays empty.
        lua5_5
        rift # provides rift-cli, used by items/spaces.lua
      ];

      xdg.configFile = {
        "sketchybar/sketchybarrc" = {
          text = "#!${pkgs.lua5_5}/bin/lua\n" + builtins.readFile ./sketchybarrc;
          executable = true;
        };
        "sketchybar/init.lua".source = ./init.lua;
        "sketchybar/bar.lua".source = ./bar.lua;
        "sketchybar/colors.lua".source = ./colors.lua;
        "sketchybar/default.lua".source = ./default.lua;
        "sketchybar/icons.lua".source = ./icons.lua;
        "sketchybar/settings.lua".source = ./settings.lua;

        # Items
        "sketchybar/items/init.lua".source = ./items/init.lua;
        "sketchybar/items/apple.lua".source = ./items/apple.lua;
        "sketchybar/items/calendar.lua".source = ./items/calendar.lua;
        "sketchybar/items/front_app.lua".source = ./items/front_app.lua;
        "sketchybar/items/media.lua".source = ./items/media.lua;
        "sketchybar/items/menus.lua".source = ./items/menus.lua;
        "sketchybar/items/spaces.lua".source = ./items/spaces.lua;
        "sketchybar/items/keybindings.lua".source = ./items/keybindings.lua;

        # Widgets
        "sketchybar/items/widgets/init.lua".source = ./items/widgets/init.lua;
        "sketchybar/items/widgets/battery.lua".source = ./items/widgets/battery.lua;
        "sketchybar/items/widgets/cpu.lua".source = ./items/widgets/cpu.lua;
        "sketchybar/items/widgets/volume.lua".source = ./items/widgets/volume.lua;
        "sketchybar/items/widgets/wifi.lua".source = ./items/widgets/wifi.lua;

        # Helpers
        "sketchybar/helpers/init.lua".text = ''
          package.cpath = package.cpath .. ";${pkgs.sbarlua}/lib/lua/${pkgs.lua5_5.luaversion}/?.so"
          os.execute("(cd $CONFIG_DIR/helpers && make)")
        '';
        "sketchybar/helpers/app_icons.lua".source = ./helpers/app_icons.lua;
        "sketchybar/helpers/makefile".source = ./helpers/makefile;

        # Event providers
        "sketchybar/helpers/event_providers/sketchybar.h".source = ./helpers/event_providers/sketchybar.h;
        "sketchybar/helpers/event_providers/makefile".source = ./helpers/event_providers/makefile;
        "sketchybar/helpers/event_providers/cpu_load/cpu.h".source = ./helpers/event_providers/cpu_load/cpu.h;
        "sketchybar/helpers/event_providers/cpu_load/cpu_load.c".source = ./helpers/event_providers/cpu_load/cpu_load.c;
        "sketchybar/helpers/event_providers/cpu_load/makefile".source = ./helpers/event_providers/cpu_load/makefile;
        "sketchybar/helpers/event_providers/network_load/network.h".source = ./helpers/event_providers/network_load/network.h;
        "sketchybar/helpers/event_providers/network_load/network_load.c".source = ./helpers/event_providers/network_load/network_load.c;
        "sketchybar/helpers/event_providers/network_load/makefile".source = ./helpers/event_providers/network_load/makefile;

        # Menus helper
        "sketchybar/helpers/menus/menus.c".source = ./helpers/menus/menus.c;
        "sketchybar/helpers/menus/makefile".source = ./helpers/menus/makefile;
      };
    };
}
