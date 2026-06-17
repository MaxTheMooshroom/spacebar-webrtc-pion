{ flake-parts-lib, lib, ... }:
flake-parts-lib.mkTransposedPerSystemModule
  {
    name = "containers";
    option =
      lib.mkOption
        {
          type = lib.types.lazyAttrsOf lib.types.package;
          default = {};
          description = ''
            per-system containers, such as oci containers or docker containers.
          '';

          # NOTE: Does this want to require annotating the container
          # type using a name-prefix?
          #
          # type =
          #   lib.types.addCheck
          #     lib.types.package
          #     (a: builtins.any (b: lib.hasPrefix b a) ["docker-" "oci-"]);
        };
    file = ./persystem-containers.nix;
  }
