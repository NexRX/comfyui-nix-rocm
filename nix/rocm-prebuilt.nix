# Prebuilt ROCm 7.2 libraries from repo.radeon.com
# These are fetched from AMD's official repository and provide ROCm 7.2 runtime libraries
# without requiring compilation or the broken nixpkgs ROCm 7.2 PR.
{ pkgs, lib }:

let
  rocmVersion = "7.2.0";
  rocmPath = "rocm-7.2.0"; # Full version path used in deb packages

  # Helper to create a derivation from Ubuntu .deb packages
  mkRocmPackageFromDeb =
    {
      pname,
      version,
      debUrl,
      debHash,
      description ? "ROCm ${pname} library",
      buildInputs ? [ ],
      autoPatchelfIgnoreMissingDeps ? [ ],
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;

      src = pkgs.fetchurl {
        url = debUrl;
        hash = debHash;
      };

      nativeBuildInputs = [
        pkgs.dpkg
        pkgs.autoPatchelfHook
      ];

      buildInputs = [
        pkgs.stdenv.cc.cc.lib # libstdc++, libgcc_s
      ]
      ++ buildInputs;

      inherit autoPatchelfIgnoreMissingDeps;

      unpackPhase = ''
        dpkg-deb -x $src .
      '';

      installPhase = ''
        runHook preInstall

        # Copy libraries
        if [ -d opt/${rocmPath}/lib ]; then
          mkdir -p $out/lib
          cp -r opt/${rocmPath}/lib/* $out/lib/
        fi

        # Copy include files
        if [ -d opt/${rocmPath}/include ]; then
          mkdir -p $out/include
          cp -r opt/${rocmPath}/include/* $out/include/
        fi

        # Copy share files
        if [ -d opt/${rocmPath}/share ]; then
          mkdir -p $out/share
          cp -r opt/${rocmPath}/share/* $out/share/
        fi

        # Copy bin files
        if [ -d opt/${rocmPath}/bin ]; then
          mkdir -p $out/bin
          cp -r opt/${rocmPath}/bin/* $out/bin/
        fi

        # Copy libexec files
        if [ -d opt/${rocmPath}/libexec ]; then
          mkdir -p $out/libexec
          cp -r opt/${rocmPath}/libexec/* $out/libexec/
        fi

        runHook postInstall
      '';

      # Fix broken symlinks by making them relative or removing them
      postFixup = ''
        # Remove or fix broken symlinks
        find $out -type l ! -exec test -e {} \; -print | while read -r link; do
          echo "Removing broken symlink: $link"
          rm "$link"
        done
      '';

      meta = {
        inherit description;
        homepage = "https://rocm.docs.amd.com/";
        license = lib.licenses.mit;
        platforms = [ "x86_64-linux" ];
      };
    };

  baseUrl = "https://repo.radeon.com/rocm/apt/7.2/pool/main";

in
rec {
  # ROCm SMI Library - System Management Interface
  rocm-smi-lib = mkRocmPackageFromDeb {
    pname = "rocm-smi-lib";
    version = "7.8.0.70200-43";
    debUrl = "${baseUrl}/r/rocm-smi-lib/rocm-smi-lib_7.8.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-yzo6u2GggD5nAnWZtOeyFMhF3AQotaDyR/APh6VIlV8=";
    description = "ROCm System Management Interface library";
    buildInputs = [ pkgs.libdrm ];
  };

  # HSA Runtime - required by PyTorch and ROCm runtime
  hsa-rocr = mkRocmPackageFromDeb {
    pname = "hsa-rocr";
    version = "1.18.0.70200-43";
    debUrl = "${baseUrl}/h/hsa-rocr/hsa-rocr_1.18.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-R0Gx00aYpCatlzamdb+chFbnI5vOXMA9ajPb6dxQd2s=";
    description = "HSA runtime for AMD GPUs";
    buildInputs = [
      pkgs.numactl
      pkgs.libdrm
      pkgs.elfutils
    ];
    # Ignore rocprofiler-register to break circular dependency
    # It will be available at runtime via LD_LIBRARY_PATH
    autoPatchelfIgnoreMissingDeps = [
      "librocprofiler-register.so.0"
    ];
  };

  # ROCm Profiler Register - required by PyTorch and many ROCm libraries
  rocprofiler-register = mkRocmPackageFromDeb {
    pname = "rocprofiler-register";
    version = "0.6.0.70200-43";
    debUrl = "${baseUrl}/r/rocprofiler-register/rocprofiler-register_0.6.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-Pyuy+K8G0G9zD4rK6nRrBUM+mxw7xfDW26CFucRpvRs=";
    description = "ROCm profiler register library";
    buildInputs = [ hsa-rocr ];
  };

  # AMD Code Object Manager (comgr) - required by many ROCm libraries
  comgr = mkRocmPackageFromDeb {
    pname = "comgr";
    version = "3.0.0.70200-43";
    debUrl = "${baseUrl}/c/comgr/comgr_3.0.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-+7Fxk3n/+LWoATs7iKF5/gWY11/3XPM9qiN8eHEd86k=";
    description = "AMD Code Object Manager library";
    buildInputs = [
      rocm-device-libs
      pkgs.zlib
      pkgs.zstd
      rocprofiler-register
      hsa-rocr
    ];
  };

  # Core ROCm runtime
  rocm-core = mkRocmPackageFromDeb {
    pname = "rocm-core";
    version = "7.2.0.70200-43";
    debUrl = "${baseUrl}/r/rocm-core/rocm-core_7.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-LgDnQmU8wq4nERN5PgoRBuaiPSKaKm9ZbckPWCCsT0Y=";
    description = "ROCm core runtime components";
  };

  # HIP runtime (clr - Common Language Runtime)
  hip-runtime-amd = mkRocmPackageFromDeb {
    pname = "hip-runtime-amd";
    version = "7.2.26015.70200-43";
    debUrl = "${baseUrl}/h/hip-runtime-amd/hip-runtime-amd_7.2.26015.70200-43~24.04_amd64.deb";
    debHash = "sha256-bIQSZTLTAuzECrg3zDBC6d1fcrMZ8IdyEnvtfKYnUDc=";
    description = "HIP runtime for AMD GPUs";
    buildInputs = [
      comgr
      rocprofiler-register
      hsa-rocr
    ];
  };

  # ROCm device libraries
  rocm-device-libs = mkRocmPackageFromDeb {
    pname = "rocm-device-libs";
    version = "1.0.0.70200-43";
    debUrl = "${baseUrl}/r/rocm-device-libs/rocm-device-libs_1.0.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-z8skQ43i0YHxbOVo0N+sh3FkwtqzeEAH1aFZ+6xwjik=";
    description = "ROCm device libraries";
  };

  # rocBLAS - BLAS library
  rocblas = mkRocmPackageFromDeb {
    pname = "rocblas";
    version = "5.2.0.70200-43";
    debUrl = "${baseUrl}/r/rocblas/rocblas_5.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-c3J1v4YwBj0CmB7RfLwVW5sbbCljeXV6OdeO4OX8vBM=";
    description = "ROCm BLAS library";
    buildInputs = [ hip-runtime-amd ];
    # libhipblaslt causes circular dependency, will be available at runtime
    autoPatchelfIgnoreMissingDeps = [ "libhipblaslt.so.1" ];
  };

  # hipBLAS - HIP BLAS wrapper
  hipblas = mkRocmPackageFromDeb {
    pname = "hipblas";
    version = "3.2.0.70200-43";
    debUrl = "${baseUrl}/h/hipblas/hipblas_3.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-g357ETZeca0zFrcWeRFQR5WoR3FB4X6+2YzEzYYEa9k=";
    description = "HIP BLAS wrapper library";
    buildInputs = [
      rocblas
      rocsolver
      comgr
    ];
  };

  # hipSPARSELt - critical missing library
  hipsparselt = mkRocmPackageFromDeb {
    pname = "hipsparselt";
    version = "0.2.6.70200-43";
    debUrl = "${baseUrl}/h/hipsparselt/hipsparselt_0.2.6.70200-43~24.04_amd64.deb";
    debHash = "sha256-WyECm93dqstAEBMcmo8/G4KBO+xzCMcAqLSrWPqinYA=";
    description = "HIP SPARSE Lt library";
    buildInputs = [ hip-runtime-amd ];
    # libroctx64 is provided by PyTorch wheels at runtime
    autoPatchelfIgnoreMissingDeps = [ "libroctx64.so.4" ];
  };

  # MIOpen - ML primitives library
  miopen-hip = mkRocmPackageFromDeb {
    pname = "miopen-hip";
    version = "3.5.1.70200-43";
    debUrl = "${baseUrl}/m/miopen-hip/miopen-hip_3.5.1.70200-43~24.04_amd64.deb";
    debHash = "sha256-bDEF14Wnwzl4OSBmPcUaJA/ymnEdmeVMzw04SLnIP9Q=";
    description = "MIOpen ML primitives library";
    buildInputs = [
      hip-runtime-amd
      rocm-core
      rocblas
      rocrand
      comgr
      pkgs.zstd
    ];
    # These dependencies are provided by PyTorch wheels or ROCm drivers at runtime
    autoPatchelfIgnoreMissingDeps = [
      "libhipblaslt.so.1"
      "libroctx64.so.4"
    ];
  };

  # rocRAND - random number generator
  rocrand = mkRocmPackageFromDeb {
    pname = "rocrand";
    version = "4.2.0.70200-43";
    debUrl = "${baseUrl}/r/rocrand/rocrand_4.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-Zh2QK64ZHj7aS7wSbGWT4ws0Zzey4vn5v2UJfmZQCnU=";
    description = "ROCm random number generator library";
    buildInputs = [ hip-runtime-amd ];
  };

  # rocSOLVER - linear algebra solver
  rocsolver = mkRocmPackageFromDeb {
    pname = "rocsolver";
    version = "3.32.0.70200-43";
    debUrl = "${baseUrl}/r/rocsolver/rocsolver_3.32.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-y+HjMKakOyE/ghjNGELJSAeHLFH5Qj7jBRI4h0jyrd4=";
    description = "ROCm linear algebra solver library";
    buildInputs = [
      hip-runtime-amd
      rocblas
    ];
  };

  # rocSPARSE - sparse linear algebra
  rocsparse = mkRocmPackageFromDeb {
    pname = "rocsparse";
    version = "4.2.0.70200-43";
    debUrl = "${baseUrl}/r/rocsparse/rocsparse_4.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-Ena4LyGaagfhbs5q2nAcgXdH6EnDlhjJ/8wVeB5nfk0=";
    description = "ROCm sparse linear algebra library";
    buildInputs = [
      hip-runtime-amd
      rocblas
    ];
    # libroctx64 is provided by PyTorch wheels at runtime
    autoPatchelfIgnoreMissingDeps = [ "libroctx64.so.4" ];
  };

  # rocFFT - FFT library
  rocfft = mkRocmPackageFromDeb {
    pname = "rocfft";
    version = "1.0.36.70200-43";
    debUrl = "${baseUrl}/r/rocfft/rocfft_1.0.36.70200-43~24.04_amd64.deb";
    debHash = "sha256-1YS7UAukx8QVhnKiyGp/duKaMkZqbZWro5RoYrtp3U4=";
    description = "ROCm FFT library";
    buildInputs = [ hip-runtime-amd ];
  };

  # RCCL - collective communications library
  rccl = mkRocmPackageFromDeb {
    pname = "rccl";
    version = "2.27.7.70200-43";
    debUrl = "${baseUrl}/r/rccl/rccl_2.27.7.70200-43~24.04_amd64.deb";
    debHash = "sha256-uoMf04u+enM3IRhcvlBciHeDpRewWjG8W61ey2b6i9o=";
    description = "ROCm collective communications library";
    buildInputs = [
      hip-runtime-amd
      rocprofiler-register
      rocm-smi-lib
    ];
  };

  # roctracer - ROCm tracer library (provides libroctx64.so.4)
  roctracer = mkRocmPackageFromDeb {
    pname = "roctracer";
    version = "4.1.70200.70200-43";
    debUrl = "${baseUrl}/r/roctracer/roctracer_4.1.70200.70200-43~24.04_amd64.deb";
    debHash = "sha256-Tlde8UvB2MvTjmFMEwyaNAZRz0mcTHpaUdesxvOKoUY=";
    description = "ROCm tracer library for profiling";
    buildInputs = [
      hip-runtime-amd
      comgr
      rocprofiler-register
      hsa-rocr
    ];
  };

  # hipFFT - FFT library for HIP
  hipfft = mkRocmPackageFromDeb {
    pname = "hipfft";
    version = "1.0.22.70200-43";
    debUrl = "${baseUrl}/h/hipfft/hipfft_1.0.22.70200-43~24.04_amd64.deb";
    debHash = "sha256-xiN3/La1bBw6e2ALApp6awfUHlgPxg3ut91QolOE3WM=";
    description = "HIP FFT library";
    buildInputs = [
      hip-runtime-amd
      rocfft
    ];
  };

  # hipSPARSE - sparse linear algebra for HIP
  hipsparse = mkRocmPackageFromDeb {
    pname = "hipsparse";
    version = "4.2.0.70200-43";
    debUrl = "${baseUrl}/h/hipsparse/hipsparse_4.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-fNZ8dtgPvgVMIjAMjsOjCAb+mWZ+ZdHrUCJSFx3gI60=";
    description = "HIP sparse linear algebra library";
    buildInputs = [
      hip-runtime-amd
      rocsparse
    ];
    # libroctx64 is provided by PyTorch wheels at runtime
    autoPatchelfIgnoreMissingDeps = [ "libroctx64.so.4" ];
  };

  # hipSOLVER - linear algebra solver for HIP
  hipsolver = mkRocmPackageFromDeb {
    pname = "hipsolver";
    version = "3.2.0.70200-43";
    debUrl = "${baseUrl}/h/hipsolver/hipsolver_3.2.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-7j5872o+MkV2RB1bFNUYCSwnZqTbBxhI35/JeS5Y/GU=";
    description = "HIP linear algebra solver library";
    buildInputs = [
      hip-runtime-amd
      rocsolver
      rocblas
    ];
  };

  # hipRAND - random number generator for HIP
  hiprand = mkRocmPackageFromDeb {
    pname = "hiprand";
    version = "3.1.0.70200-43";
    debUrl = "${baseUrl}/h/hiprand/hiprand_3.1.0.70200-43~24.04_amd64.deb";
    debHash = "sha256-IE4H8wvlJcv9HJbyxtWTty2MA5Q/F7ge9msQsn4GPQQ=";
    description = "HIP random number generator library";
    buildInputs = [
      hip-runtime-amd
      rocrand
    ];
  };

  # hipBLASLt - BLAS-like library optimized for AMD GPUs
  hipblaslt = mkRocmPackageFromDeb {
    pname = "hipblaslt";
    version = "1.2.1.70200-43";
    debUrl = "${baseUrl}/h/hipblaslt/hipblaslt_1.2.1.70200-43~24.04_amd64.deb";
    debHash = "sha256-s0GEwdwKWQtvKxSfQjiR/UFnMN6s/U5JkcwyiqldYPQ=";
    description = "HIP BLAS-like library optimized for matrix multiplication";
    buildInputs = [
      hip-runtime-amd
      rocblas
      comgr
    ];
    # These dependencies are provided by PyTorch wheels or ROCm drivers at runtime
    autoPatchelfIgnoreMissingDeps = [
      "libroctx64.so.4"
    ];
  };
}
