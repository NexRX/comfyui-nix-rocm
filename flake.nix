{
  description = "A Nix flake for ComfyUI with Python 3.12";

  nixConfig = {
    extra-substituters = [
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
    }:
    let
      versions = import ./nix/versions.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Supported systems: Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)
      # Note: ROCm support is only available on x86_64-linux
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config, # Module config, available for future use
          self', # Same-system outputs from this flake
          inputs', # Same-system outputs from input flakes
          pkgs, # Nixpkgs configured with our settings
          system, # Current system being evaluated
          lib, # Nixpkgs lib functions
          ...
        }:
        let
          # =======================================================================
          # ROCm Support via Pre-built Wheels
          # =======================================================================
          # ROCm support uses pre-built PyTorch wheels from pytorch.org instead of
          # compiling from source. This provides:
          # - Fast builds (download ~2GB vs compile for hours)
          # - Low memory usage (no 30-60GB RAM requirement)
          # - AMD GPU architectures supported (RX 6000/7000 series)
          # - ROCm 7.1 runtime bundled in wheels
          # =======================================================================

          # Linux pkgs for cross-building Docker images from any system
          # Note: We create separate pkgs instances here (instead of using _module.args.pkgs)
          # because we need specific target systems for cross-platform Docker builds.
          # These allow building Linux Docker images from macOS/other platforms.
          pkgsLinuxX86 = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              allowBrokenPredicate = pkg: (pkg.pname or "") == "open-clip-torch";
            };
          };
          pkgsLinuxArm64 = import nixpkgs {
            system = "aarch64-linux";
            config = {
              allowUnfree = true;
              allowBrokenPredicate = pkg: (pkg.pname or "") == "open-clip-torch";
              # Work around nixpkgs kornia-rs badPlatforms issue on aarch64-linux
              allowUnsupportedSystem = true;
            };
          };

          pythonOverridesFor =
            pkgs: rocmSupport:
            import ./nix/python-overrides.nix {
              inherit
                pkgs
                versions
                rocmSupport
                ;
            };

          mkPython =
            pkgs: rocmSupport:
            pkgs.python312.override { packageOverrides = pythonOverridesFor pkgs rocmSupport; };

          mkPythonEnv =
            pkgs:
            let
              python = mkPython pkgs false;
            in
            python.withPackages (ps: [
              ps.setuptools
              ps.wheel
              ps.pip
            ]);

          mkComfyPackages =
            pkgs:
            {
              rocmSupport ? false,
            }:
            import ./nix/packages.nix {
              inherit
                pkgs
                versions
                rocmSupport
                ;
              lib = pkgs.lib;
              pythonOverrides = pythonOverridesFor pkgs rocmSupport;
            };

          # Linux packages for Docker image cross-builds
          linuxX86Packages = mkComfyPackages pkgsLinuxX86 { };
          # Docker ROCm images use pre-built wheels (AMD GPU support)
          linuxX86PackagesRocm = mkComfyPackages pkgsLinuxX86 { rocmSupport = true; };
          linuxArm64Packages = mkComfyPackages pkgsLinuxArm64 { };

          nativePackages = mkComfyPackages pkgs { };
          # ROCm uses pre-built wheels (AMD GPU support)
          nativePackagesRocm = mkComfyPackages pkgs { rocmSupport = true; };

          pythonEnv = mkPythonEnv pkgs;

          # Custom nodes with bundled dependencies
          customNodes = import ./nix/custom-nodes.nix {
            inherit pkgs versions;
            lib = pkgs.lib;
            python = mkPython pkgs false;
          };

          source = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter =
              path: type:
              let
                rel = pkgs.lib.removePrefix (toString ./. + "/") (toString path);
                excluded = [
                  ".direnv"
                  ".git"
                  "data"
                  "dist"
                  "node_modules"
                  "tmp"
                ];
              in
              # Exclude exact matches, subdirectories, and result* symlinks
              !pkgs.lib.any (prefix: rel == prefix || pkgs.lib.hasPrefix (prefix + "/") rel) excluded
              && !pkgs.lib.hasPrefix "result" rel;
          };
        in
        {
          # Configure the pkgs instance used by perSystem with our required settings.
          # This ensures all native builds use consistent nixpkgs configuration.
          # Note: Cross-platform Docker builds still need their own pkgs instances (see above).
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowBrokenPredicate = pkg: (pkg.pname or "") == "open-clip-torch";
              # aarch64-linux needs this workaround for kornia-rs
              allowUnsupportedSystem = system == "aarch64-linux";
            };
          };

          packages = {
            default = nativePackages.default;
            comfyui = nativePackages.default;
            # Cross-platform Docker image builds (use remote builder on non-Linux)
            # These are always available regardless of host system
            dockerImageLinux = linuxX86Packages.dockerImage;
            dockerImageLinuxRocm = linuxX86PackagesRocm.dockerImageRocm;
            dockerImageLinuxArm64 = linuxArm64Packages.dockerImage;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            dockerImage = nativePackages.dockerImage;
          }
          // pkgs.lib.optionalAttrs (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) {
            # ROCm package uses pre-built wheels (AMD GPU support)
            rocm = nativePackagesRocm.default;
            dockerImageRocm = nativePackagesRocm.dockerImageRocm;
          };

          # Expose custom nodes for direct use
          legacyPackages = {
            customNodes = customNodes;
          };

          apps = import ./nix/apps.nix {
            inherit pkgs;
            packages = self'.packages;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pythonEnv
              pkgs.stdenv.cc
              pkgs.libGL
              pkgs.libGLU
              pkgs.git
              pkgs.nixfmt-rfc-style
              pkgs.ruff
              pkgs.pyright
              pkgs.shellcheck
              pkgs.jq
              pkgs.curl
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.apple-sdk_14 ];

            shellHook =
              let
                defaultDir =
                  if pkgs.stdenv.isDarwin then
                    "$HOME/Library/Application Support/comfy-ui"
                  else
                    "$HOME/.config/comfy-ui";
              in
              ''
                echo "ComfyUI development environment activated"
                echo "  ComfyUI version: ${versions.comfyui.version}"
                export COMFY_USER_DIR="${defaultDir}"
                mkdir -p "$COMFY_USER_DIR"
                echo "User data will be stored in $COMFY_USER_DIR"
                export PYTHONPATH="$PWD:$PYTHONPATH"
              '';
          };

          formatter = pkgs.nixfmt-rfc-style;

          checks = import ./nix/checks.nix {
            inherit pkgs source;
            packages = self'.packages;
            pythonRuntime = nativePackages.pythonRuntime;
          };
        };

      flake = {
        # System-independent lib with custom node helpers
        lib = import ./nix/lib/custom-nodes.nix {
          lib = nixpkgs.lib;
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Default for lib evaluation
        };

        overlays.default = final: prev: {
          comfyui-nix = self.legacyPackages.${final.system};
          comfyui = self.packages.${final.system}.default;
          comfy-ui = self.packages.${final.system}.default;
          # ROCm variant (x86_64 Linux only) - uses pre-built wheels for AMD GPU support
          comfy-ui-rocm =
            if final.stdenv.isLinux && final.stdenv.isx86_64 then
              self.packages.${final.system}.rocm
            else
              throw "comfy-ui-rocm is only available on x86_64 Linux";
          # Add custom nodes to overlay
          comfyui-custom-nodes = self.legacyPackages.${final.system}.customNodes;
        };

        nixosModules.default =
          { ... }:
          {
            imports = [ ./nix/modules/comfyui.nix ];
            nixpkgs.overlays = [ self.overlays.default ];
          };
      };
    };
}
