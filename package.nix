{
  lib,

  buildGo126Module,

  pion-webrtc-src,
}:
let
  package-manifest =
    builtins.fromJSON
      (builtins.readFile "${pion-webrtc-src}/pion-signaling/package.json");
in
  buildGo126Module
    {
      pname = "spacebar-webrtc-pion";
      version = package-manifest.version;

      src = "${pion-webrtc-src}/pion-sfu";
      vendorHash = "sha256-tthWbVeyM4lw9i1XQO++8yUO9+oNBP44bbXTQTSC/Uk=";

      meta = {
        description = "Spacebar Go WebRTC server";
        homepage = "https://github.com/spacebarchat/pion-webrtc";
        license = lib.licenses.agpl3Plus;
        # maintainers = with lib.maintainers; [ RorySys ]; # for the nix package
        mainProgram = "pion-sfu";
      };

      passthru.manifest = package-manifest;
    }
