{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pixie-sddm.url = "github:xCaptaiN09/pixie-sddm";

    # Odysseus
    odysseus-nix = {
      url = "github:KangaZero/odysseus-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      disko,
      impermanence,
      nixos-hardware,
      nur,
      zen-browser,
      pixie-sddm,
      odysseus-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.mynixos = nixpkgs.lib.nixosSystem {
        inherit system;

        # Передаємо все, що потрібно
        specialArgs = {
          inherit inputs pixie-sddm; # pixie-sddm окремо + inputs
        };

        modules = [
          ./hosts/mynixos

          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence

          ({ pkgs, ... }: {
            nixpkgs.overlays = [ nur.overlays.default ];
          })

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sova = import ./home;

              sharedModules = [ zen-browser.homeModules.default ];

              # Для home-manager
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };
}
