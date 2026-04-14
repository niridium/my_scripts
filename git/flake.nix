{
  description = "Tools for Git";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.init-git-repo =
          let
            my_name = "init-git-repo";
            my_buildInputs = with pkgs; [
              git-conventional-commits
              ggshield
            ];
            init_git_repo =
              (pkgs.writeScriptBin my_name (builtins.readFile ../src/git/init-git-repo.sh)).overrideAttrs
                (old: {
                  buildCommand = "${old.buildCommand}\n patchShebangs $out";
                });
          in
          pkgs.symlinkJoin {
            name = my_name;
            paths = [ init_git_repo ] ++ my_buildInputs;
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/${my_name} --prefix PATH : $out/bin";
          };
      }
    );
}
