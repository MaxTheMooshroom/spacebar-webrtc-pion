{
  inputs =
    {
      flake-parts.url = "github:hercules-ci/flake-parts";
      nixpkgs.url = "github:NixOS/nixpkgs/26.05";

      pion-webrtc-src =
        {
          url = "github:spacebarchat/pion-webrtc/f69636f";
          flake = false;
        };
    };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake
      { inherit inputs; }
      (
        { lib, ... }:
        {
          systems = lib.systems.flakeExposed;

          imports =
            with flake-parts.flakeModules;
            [
              modules
              flakeModules

              ./persystem-containers.nix
            ];

          perSystem =
            { self', pkgs, ... }:
            {
              containers =
                {
                  pion-webrtc =
                    pkgs.dockerTools.buildLayeredImage
                      {
                        name = "spacebar-webrtc-pion";
                        tag =
                          builtins.replaceStrings
                            [ "+" ]
                            [ "_" ]
                            self'.packages.pion-webrtc.version;

                        contents =
                          with pkgs.dockerTools;
                          [
                            self'.packages.pion-webrtc

                            binSh
                            usrBinEnv
                            caCertificates
                          ];

                        # NOTE: Marked TODO in the original repo.
                        config =
                          {
                            Cmd = [ (lib.getExe self'.packages.pion-webrtc) ];
                            WorkingDir = "/data";
                            Env = [ "PORT=3001" ];
                            Expose = [ "3001" ];
                          };
                      };
                };

              packages =
                {
                  default = self'.packages.pion-webrtc;

                  pion-webrtc = pkgs.callPackage ./package.nix {
                    inherit (inputs) pion-webrtc-src;
                  };
                };

              devShells.default =
                pkgs.mkShellNoCC
                  {
                    packages = [ pkgs.go_1_26 ];
                  };
            };
        }
      );
}
