{
  description = "A basic flake using pyproject.toml project metadata";

  inputs.pyproject-nix.url = "github:nix-community/pyproject.nix";
  inputs.pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { nixpkgs, pyproject-nix, ... }:
    let
      inherit (nixpkgs) lib;
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      python = pkgs.python3;
    in
    {
      packages.x86_64-linux.default =
        let
          attrs = project.renderers.buildPythonPackage {
            inherit python;
            groups = [ "test" ];
          };
        in
        python.pkgs.buildPythonPackage attrs;
    };
}
