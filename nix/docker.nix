{
  pkgs,
  lib,
  versions,
}:
{
  mkDockerImage =
    {
      name,
      tag,
      comfyUiPackage,
      cudaSupport ? false,
      rocmSupport ? false,
      cudaVersion ? "cu124",
      rocmVersion ? "rocm7.1",
      extraLabels ? { },
    }:
    let
      baseEnv = [
        "HOME=/root"
        "COMFY_USER_DIR=/data"
        "TMPDIR=/tmp"
        "PATH=/bin:/usr/bin"
        "PYTHONUNBUFFERED=1"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib"
      ];
      cudaEnv = lib.optionals cudaSupport [
        "NVIDIA_VISIBLE_DEVICES=all"
        "NVIDIA_DRIVER_CAPABILITIES=compute,utility"
      ];
      rocmEnv = lib.optionals rocmSupport [
        "HSA_OVERRIDE_GFX_VERSION=10.3.0"
        "ROCR_VISIBLE_DEVICES=0"
      ];
      labels = {
        "org.opencontainers.image.title" = if cudaSupport then "ComfyUI CUDA" else "ComfyUI";
        "org.opencontainers.image.description" =
          if cudaSupport then
            "ComfyUI with CUDA support for NVIDIA GPU acceleration"
          else if rocmSupport then
            "ComfyUI with ROCm support for AMD GPU acceleration"
          else
            "ComfyUI - The most powerful and modular diffusion model GUI";
        "org.opencontainers.image.source" = "https://github.com/utensils/comfyui-nix";
        "org.opencontainers.image.licenses" = "GPL-3.0";
      }
      // extraLabels;
    in
    pkgs.dockerTools.buildImage {
      inherit name tag;
      created = versions.comfyui.releaseDate;

      copyToRoot = pkgs.buildEnv {
        name = "comfy-ui-root";
        paths = [
          pkgs.bash
          pkgs.coreutils
          pkgs.netcat
          pkgs.git
          pkgs.curl
          pkgs.jq
          pkgs.cacert
          pkgs.glib
          pkgs.libGL
          pkgs.libGLU
          pkgs.stdenv.cc.cc.lib
          comfyUiPackage
        ];
        pathsToLink = [
          "/bin"
          "/lib"
          "/share"
          "/etc"
        ];
      };

      config = {
        Entrypoint = [ "/bin/comfy-ui" ];
        Cmd = [
          "--listen"
          "0.0.0.0"
        ]
        ++ lib.optionals (!cudaSupport && !rocmSupport) [ "--cpu" ];
        Env = baseEnv ++ cudaEnv ++ rocmEnv;
        ExposedPorts = {
          "8188/tcp" = { };
        };
        WorkingDir = "/data";
        Volumes = {
          "/data" = { };
          "/tmp" = { };
        };
        Healthcheck = {
          Test = [
            "CMD"
            "nc"
            "-z"
            "localhost"
            "8188"
          ];
          Interval = 30000000000;
          Timeout = 5000000000;
          Retries = 3;
          StartPeriod = 60000000000;
        };
        Labels = labels;
      };
    };
}
