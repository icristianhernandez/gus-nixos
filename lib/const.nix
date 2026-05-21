let
  user = "gus-nixos";
  homeDir = "/home/${user}";
in
{
  inherit user;
  inherit homeDir;
  dotfilesDir = "${homeDir}/gus-nixos";
  systemState = "25.11";
  homeState = "25.11";
  hostName = "wsl";
  timezone = "America/Caracas";
  systemLanguage = "en_US.UTF-8";
  parametersLanguage = "es_ES.UTF-8";
  userDescription = "gustavo alviarez";
  git = {
    name = "gustavo";
    email = "gusalv2001@gmail.com";
  };
}
