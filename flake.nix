{
  description = "test-repo-1: a small flake shaped like noctalia.";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs.lib) genAttrs;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      rev = self.shortRev or self.dirtyShortRev;

      forEachSystem = perSystem: genAttrs systems (system: perSystem nixpkgs.legacyPackages.${system});
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      packages = forEachSystem (pkgs: {
        default = pkgs.runCommand "test-repo-1-${rev}" { } ''
          echo ${rev} > $out
        '';
      });
    };
}
