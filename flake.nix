{
  description = "NixOS Configuration";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # for base sys
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # for select pkgs
    home-manager = {
	url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
	inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
	url = "github:hyprwm/hyprland-plugins";
	inputs.hyprland.follows = "hyprland"; # stop vers. mismatch
    };
    nix-matlab = {
	# nix-matlab wants Nixpkgs-unstable, so need to add unstable branch and special care to make sure it uses said branch
	inputs.nixpkgs.follows = "nixpkgs-unstable";
	url = "gitlab:doronbehar/nix-matlab";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, nix-matlab, ... }@inputs: 
  let
    flake-overlays = [
      nix-matlab.overlay
    ];
    system = "x86_64-linux";
  in {
    # Please replace my-nixos with your hostname
    nixosConfigurations.NixG16 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs flake-overlays; }; # needed for MATLAB

      modules = [
	# add overlays from above
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix 
    home-manager.nixosModules.home-manager {
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.pupo = import ./home.nix;
	home-manager.extraSpecialArgs = { inherit inputs; };
   	}
      ];
    };
   };
}
