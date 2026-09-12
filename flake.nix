{
  description = "Development environment for the ACM Manoa website";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              docker-client
              docker-compose
              nodejs
              pkg-config
              postgresql_15
              python312
            ];

            shellHook = ''
              if [ -f .venv/bin/activate ]; then
                source .venv/bin/activate
              fi
            '';
          };
        });
    };
}
