{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    with pkgs; {
      devShells.default = mkShell {
        buildInputs = [ elixir elixir-ls erlang ];
      };

      formatter = nixpkgs-fmt;
    }
  );
}
