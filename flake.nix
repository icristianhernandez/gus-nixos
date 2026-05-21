{
  description = "Personal NixOS configuration for WSL with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs =
    inputs:
    let
      inherit (inputs) nixpkgs nixos-wsl home-manager;
      inherit (nixpkgs) lib;
      const = import ./lib/const.nix;

      systems = [ "x86_64-linux" ];
      unstableOverlay = final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
          };
        };
      };
      eachSystem =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ unstableOverlay ];
            };
          }
        );

    in
    {
      nixosConfigurations = {
        wsl = lib.nixosSystem {
          system = builtins.head systems;
          specialArgs = {
            inherit const;
            inherit inputs;
            input = inputs;
          };

          modules = [
            {
              nixpkgs = {
                overlays = [ unstableOverlay ];
                config.allowUnfree = true;
              };
            }

            {
              imports = import ./lib/import-modules.nix {
                inherit lib;
                dir = ./system-modules;
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit const;
                  inherit inputs;
                  input = inputs;
                };
                users = {
                  "${const.user}" = {
                    imports = import ./lib/import-modules.nix {
                      inherit lib;
                      dir = ./home-modules;
                    };
                  };
                };
              };
            }

            nixos-wsl.nixosModules.default
          ];
        };
      };

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
