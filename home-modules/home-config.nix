{
  const,
  hostName,
  ...
}:

{
  home = {
    username = const.user;
    homeDirectory = const.homeDir;
    stateVersion = const.homeState;

    sessionVariables = {
      NIXOS_HOST = hostName;
    };
  };
}
