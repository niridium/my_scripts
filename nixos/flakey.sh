nix flake update --quiet

echo "Building package diff..."
nixos-rebuild build --quiet

nix run nixpkgs#nvd -- diff /run/current-system result
