{
  description = "A development environment for this haskell project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    haskell-flake.url = "github:srid/haskell-flake";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.haskell-flake.flakeModule
      ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          pkgs,
          self',
          config,
          ...
        }:
        let
          stack-wrapped = pkgs.symlinkJoin {
            name = "stack";
            paths = [ pkgs.stack ];
            buildInputs = [
              pkgs.makeWrapper
              config.packages.hoom
            ];
            postBuild = ''
              wrapProgram $out/bin/stack \
                --add-flags "\
                  --nix \
                  --system-ghc \
                  --no-install-ghc \
                "
            '';
          };
        in
        {
          formatter = pkgs.nixfmt-rfc-style;
          packages.default = self'.packages.hoom;
          haskellProjects.default = {
            basePackages = pkgs.haskellPackages;
            packages = {
              # Dependencies
              # aeson.source = "1.5.0.0";
            };
            settings = {
              # Settings for dependecies
              # aeson = {
              #   check = false;
              # };
            };
            devShell = {
              enable = true;
              # tools = hp: { cabal = hp.cabal; };
              tools = hp: {
                inherit (hp)
                  cabal-install
                  haskell-language-server
                  hlint
                  ;
                inherit (pkgs)
                  ghciwatch
                  ;
                ghcid = null;
                stack = stack-wrapped;
              };
              hlsCheck.enable = false;
            };
          };
        };
    };
}
