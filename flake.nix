{
  description = "My home configuration";

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: {
      default =
        pkgs.mkShell {packages = [pkgs.lefthook];};
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    homeConfigurations.andrewgarner = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [./home.nix];
    };
  };
}
