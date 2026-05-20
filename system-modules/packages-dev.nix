{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI Utils
    cargo
    gnumake

    # Languages
    nodejs_24
    gcc
    (python313.withPackages (ps: [ ps.pip ]))
    go
    postgresql

    # Dev Environment
    statix
  ];
}
