
# Spacebar's WebRTC Server

A WebRTC server implementation compatible with [Spacebar](https://spacebar.chat/),
using [Pion](https://pion.ly/)'s
[Go implementation of WebRTC](https://github.com/pion/webrtc).

## Docker

```sh
nix build github:MaxTheMooshroom/spacebar-webrtc-pion#containers.x86_64-linux.pion-webrtc
docker load -i result
```

## Nix

Example use of this flake.

```nix
{
  inputs =
    {
      flake-parts.url = "github:hercules-ci/flake-parts";
      nixpkgs.url = "github:NixOS/nixpkgs/26.05";

      spacebar-webrtc-pion.url = "github:MaxTheMooshroom/spacebar-webrtc-pion";
    };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake
      { inherit inputs; }
      (
        { lib, ... }:
        {
          systems = lib.systems.flakeExposed;

          perSystem =
            { inputs', self', pkgs, ... }:
            {
              packages.default = self'.packages.my-package;

              packages.my-package = pkgs.mkDerivation {
                name = "mypackage";
                version = "0.1.0";

                buildInputs = [ inputs'.spacebar-webrtc-pion.packages.default ];
                src = ./.;

                # ...
              };
            };
        }
      );
}
```

