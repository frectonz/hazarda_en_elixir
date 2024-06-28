{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      app = pkgs.beamPackages.buildMix rec {
        name = "hazarda_en_elixir";
        version = "0.0.1";
        src = ./.;

        postBuild = ''
          mix escript.build --no-deps-check
        '';

        buildInputs = [ pkgs.erlang ];

        installPhase = "install -Dt $out/bin ${name}";
      };
    in
    {
      packages.default = app;

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [ elixir elixir-ls erlang ];
      };

      formatter = pkgs.nixpkgs-fmt;
    }
  );
}
