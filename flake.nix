{
  description = "STProDact-Linux dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {

          buildInputs = with pkgs; [
            nodejs

            nixfmt
            nixd
            docker
            docker-credential-helpers
            docker-compose
          ];

          shellHook = ''
            echo "Dev environment ready"

            if ! docker info >/dev/null 2>&1; then
              if groups | grep -q docker; then
                echo "⚠️  Docker daemon doesn't seem to be running."
                echo "    Try: sudo systemctl start docker"
              else
                echo "⚠️  You're not in the 'docker' group yet (or session hasn't refreshed)."
                echo "    Try: sudo usermod -aG docker \$USER && newgrp docker"
              fi
            else
              echo "✅ Docker daemon is running."
            fi
          '';
        };
      }
    );
}
