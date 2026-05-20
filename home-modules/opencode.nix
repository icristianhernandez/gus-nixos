{
  config,
  const,
  pkgs,
  ...
}:
{
  xdg.configFile = {
    "opencode/opencode.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/opencode.json";
    };

    # Capaz si vayas a user esos siguientes

    # "opencode/plugins" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/plugins/";
    # };
    #
    # "opencode/commands" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/opencode/commands/";
    # };
  };

  home.packages = with pkgs; [
    unstable.opencode
    libnotify
    libcanberra-gtk3
    sound-theme-freedesktop
  ];
}
