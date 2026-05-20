{ const, ... }:

{
  virtualisation.docker.enable = true;

  users.users.${const.user}.extraGroups = [ "docker" ];
}
