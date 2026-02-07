# Custom node packages for ComfyUI
#
# These are pre-packaged custom nodes with their source code.
# Python dependencies are provided by the main ComfyUI environment.
#
# Users can reference these in their NixOS config:
#
#   services.comfyui.customNodes = {
#     impact-pack = comfyui-nix.customNodes.impact-pack;
#   };
#
{
  pkgs,
  lib,
  python,
  versions,
}:
let
  # Impact Pack custom node
  impact-pack = pkgs.stdenv.mkDerivation {
    pname = "comfyui-impact-pack";
    version = versions.customNodes.impact-pack.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.impact-pack.owner;
      repo = versions.customNodes.impact-pack.repo;
      rev = versions.customNodes.impact-pack.rev;
      hash = versions.customNodes.impact-pack.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required by Impact Pack
    passthru.pythonDeps =
      ps: with ps; [
        scikit-image
        piexif
        scipy
        numpy
        opencv4
        matplotlib
        dill
        segment-anything
        sam2
      ];

    meta = with lib; {
      description = "ComfyUI Impact Pack - Detection, segmentation, and more";
      homepage = "https://github.com/ltdrdata/ComfyUI-Impact-Pack";
      license = licenses.gpl3;
    };
  };

  # rgthree-comfy - Quality of life nodes
  rgthree-comfy = pkgs.stdenv.mkDerivation {
    pname = "rgthree-comfy";
    version = versions.customNodes.rgthree-comfy.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.rgthree-comfy.owner;
      repo = versions.customNodes.rgthree-comfy.repo;
      rev = versions.customNodes.rgthree-comfy.rev;
      hash = versions.customNodes.rgthree-comfy.hash;
    };

    # Convert CRLF to LF and patch __init__.py to use WEB_DIRECTORY
    # instead of shutil.copytree (which fails with read-only Nix store)
    postPatch = ''
      # Convert line endings
      sed -i 's/\r$//' __init__.py py/power_prompt.py

      # Remove shutil import and PromptServer import
      sed -i '/^import shutil$/d' __init__.py
      sed -i '/^from server import PromptServer$/d' __init__.py

      # Replace the copytree logic with WEB_DIRECTORY
      sed -i '/^DIR_WEB_JS=/,/^shutil.copytree/d' __init__.py
      sed -i '/^DIR_PY=/a # Use ComfyUI'"'"'s WEB_DIRECTORY for serving web assets (Nix-compatible)' __init__.py
      sed -i '/WEB_DIRECTORY for serving/a WEB_DIRECTORY = "./js"' __init__.py

      # Fix SyntaxWarning: invalid escape sequence in power_prompt.py
      # Change pattern='<lora:...' to pattern=r'<lora:...'
      sed -i "s/pattern='<lora:/pattern=r'<lora:/" py/power_prompt.py
    '';

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # No additional Python dependencies needed
    passthru.pythonDeps = ps: [ ];

    meta = with lib; {
      description = "rgthree-comfy - Quality of life nodes for ComfyUI";
      homepage = "https://github.com/rgthree/rgthree-comfy";
      license = licenses.mit;
    };
  };

  # KJNodes - Utility nodes
  kjnodes = pkgs.stdenv.mkDerivation {
    pname = "comfyui-kjnodes";
    version = versions.customNodes.kjnodes.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.kjnodes.owner;
      repo = versions.customNodes.kjnodes.repo;
      rev = versions.customNodes.kjnodes.rev;
      hash = versions.customNodes.kjnodes.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required by KJNodes
    passthru.pythonDeps =
      ps: with ps; [
        color-matcher
        mss
        # sageattention # broke
        triton-rocm
      ];

    meta = with lib; {
      description = "ComfyUI KJNodes - Various utility nodes";
      homepage = "https://github.com/kijai/ComfyUI-KJNodes";
      license = licenses.gpl3;
    };
  };

  # ComfyUI-GGUF - GGUF quantization support for native ComfyUI models
  gguf = pkgs.stdenv.mkDerivation {
    pname = "comfyui-gguf";
    version = versions.customNodes.gguf.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.gguf.owner;
      repo = versions.customNodes.gguf.repo;
      rev = versions.customNodes.gguf.rev;
      hash = versions.customNodes.gguf.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required by ComfyUI-GGUF
    passthru.pythonDeps =
      ps: with ps; [
        gguf
        sentencepiece
        protobuf
      ];

    meta = with lib; {
      description = "ComfyUI-GGUF - GGUF quantization support for native ComfyUI models";
      homepage = "https://github.com/city96/ComfyUI-GGUF";
      license = licenses.asl20;
    };
  };

  # ComfyUI-LTXVideo - LTX-Video support for ComfyUI
  ltxvideo = pkgs.stdenv.mkDerivation {
    pname = "comfyui-ltxvideo";
    version = versions.customNodes.ltxvideo.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.ltxvideo.owner;
      repo = versions.customNodes.ltxvideo.repo;
      rev = versions.customNodes.ltxvideo.rev;
      hash = versions.customNodes.ltxvideo.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        diffusers
        einops
        huggingface-hub
        transformers
        timm
      ];

    meta = with lib; {
      description = "ComfyUI-LTXVideo - LTX-Video support for ComfyUI";
      homepage = "https://github.com/Lightricks/ComfyUI-LTXVideo";
      license = licenses.asl20;
    };
  };

  # ComfyUI-Florence2 - Microsoft Florence2 VLM inference
  florence2 = pkgs.stdenv.mkDerivation {
    pname = "comfyui-florence2";
    version = versions.customNodes.florence2.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.florence2.owner;
      repo = versions.customNodes.florence2.repo;
      rev = versions.customNodes.florence2.rev;
      hash = versions.customNodes.florence2.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        transformers
        matplotlib
        timm
        pillow
        peft
        accelerate
      ];

    meta = with lib; {
      description = "ComfyUI-Florence2 - Microsoft Florence2 VLM inference";
      homepage = "https://github.com/kijai/ComfyUI-Florence2";
      license = licenses.mit;
    };
  };

  # ComfyUI_bitsandbytes_NF4 - NF4 quantization support
  bitsandbytes-nf4 = pkgs.stdenv.mkDerivation {
    pname = "comfyui-bitsandbytes-nf4";
    version = versions.customNodes.bitsandbytes-nf4.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.bitsandbytes-nf4.owner;
      repo = versions.customNodes.bitsandbytes-nf4.repo;
      rev = versions.customNodes.bitsandbytes-nf4.rev;
      hash = versions.customNodes.bitsandbytes-nf4.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        bitsandbytes
      ];

    meta = with lib; {
      description = "ComfyUI_bitsandbytes_NF4 - NF4 quantization for Flux models";
      homepage = "https://github.com/comfyanonymous/ComfyUI_bitsandbytes_NF4";
      license = licenses.agpl3Only;
    };
  };

  # x-flux-comfyui - XLabs Flux LoRA and ControlNet
  x-flux = pkgs.stdenv.mkDerivation {
    pname = "x-flux-comfyui";
    version = versions.customNodes.x-flux.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.x-flux.owner;
      repo = versions.customNodes.x-flux.repo;
      rev = versions.customNodes.x-flux.rev;
      hash = versions.customNodes.x-flux.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        gitpython
        einops
        transformers
        diffusers
        sentencepiece
        opencv4
      ];

    meta = with lib; {
      description = "x-flux-comfyui - XLabs Flux LoRA and ControlNet support";
      homepage = "https://github.com/XLabs-AI/x-flux-comfyui";
      license = licenses.asl20;
    };
  };

  # ComfyUI-MMAudio - Audio generation from video
  mmaudio = pkgs.stdenv.mkDerivation {
    pname = "comfyui-mmaudio";
    version = versions.customNodes.mmaudio.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.mmaudio.owner;
      repo = versions.customNodes.mmaudio.repo;
      rev = versions.customNodes.mmaudio.rev;
      hash = versions.customNodes.mmaudio.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        librosa
        torchdiffeq
        einops
        timm
        omegaconf
        open-clip-torch
        accelerate
        ftfy
      ];

    meta = with lib; {
      description = "ComfyUI-MMAudio - Synchronized audio generation from video";
      homepage = "https://github.com/kijai/ComfyUI-MMAudio";
      license = licenses.mit;
    };
  };

  # PuLID_ComfyUI - PuLID face ID for ComfyUI
  pulid = pkgs.stdenv.mkDerivation {
    pname = "pulid-comfyui";
    version = versions.customNodes.pulid.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.pulid.owner;
      repo = versions.customNodes.pulid.repo;
      rev = versions.customNodes.pulid.rev;
      hash = versions.customNodes.pulid.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Face analysis dependencies - insightface works on all platforms via onnxruntime
    # (mxnet dependency is removed in python-overrides.nix for cross-platform support)
    passthru.pythonDeps =
      ps: with ps; [
        onnxruntime
        ftfy
        timm
        insightface
        facexlib
      ];

    meta = with lib; {
      description = "PuLID_ComfyUI - PuLID face ID implementation for ComfyUI";
      homepage = "https://github.com/cubiq/PuLID_ComfyUI";
      license = licenses.asl20;
    };
  };

  # ComfyUI-WanVideoWrapper - WanVideo wrapper for ComfyUI
  wanvideo = pkgs.stdenv.mkDerivation {
    pname = "comfyui-wanvideo";
    version = versions.customNodes.wanvideo.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.wanvideo.owner;
      repo = versions.customNodes.wanvideo.repo;
      rev = versions.customNodes.wanvideo.rev;
      hash = versions.customNodes.wanvideo.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    passthru.pythonDeps =
      ps: with ps; [
        ftfy
        accelerate
        peft
        diffusers
        sentencepiece
        protobuf
        gguf
        opencv4
        scipy
        einops
      ];

    meta = with lib; {
      description = "ComfyUI-WanVideoWrapper - WanVideo wrapper for ComfyUI";
      homepage = "https://github.com/kijai/ComfyUI-WanVideoWrapper";
      license = licenses.asl20;
    };
  };

  # comfyui-easy-use
  comfyui-easy-use = pkgs.stdenv.mkDerivation {
    pname = "comfyui-easy-use";
    version = versions.customNodes.comfyui-easy-use.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-easy-use.owner;
      repo = versions.customNodes.comfyui-easy-use.repo;
      rev = versions.customNodes.comfyui-easy-use.rev;
      hash = versions.customNodes.comfyui-easy-use.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required by comfyui-easy-use
    passthru.pythonDeps =
      ps: with ps; [
        diffusers
        accelerate
        clip_interrogator
        lark
        onnxruntime
        opencv-python-headless
        sentencepiece
        spandrel
        matplotlib
        peft
      ];

    meta = with lib; {
      description = "ComfyUI-Easy-Use - An efficiency custom nodes integration package";
      homepage = "https://github.com/yolain/ComfyUI-Easy-Use";
      license = licenses.gpl3;
    };
  };

  # ComfyUI-Lora-Manager
  comfyui-lora-manager = pkgs.stdenv.mkDerivation {
    pname = "comfyui-lora-manager";
    version = versions.customNodes.comfyui-lora-manager.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-lora-manager.owner;
      repo = versions.customNodes.comfyui-lora-manager.repo;
      rev = versions.customNodes.comfyui-lora-manager.rev;
      hash = versions.customNodes.comfyui-lora-manager.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required by ComfyUI-Lora-Manager
    passthru.pythonDeps =
      ps: with ps; [
        aiohttp
        jinja2
        safetensors
        piexif
        Pillow
        olefile
        toml
        numpy
        natsort
        gitpython
        aiosqlite
        beautifulsoup4
        platformdirs
      ];

    meta = with lib; {
      description = "ComfyUI-Lora-Manager - A powerful extension for organizing, previewing, and integrating LoRA models with metadata and workflow support.";
      homepage = "https://github.com/willmiao/ComfyUI-Lora-Manager";
      license = licenses.gpl3;
    };
  };

  # ComfyUI-Lora-Manager
  comfyui-impact-subpack = pkgs.stdenv.mkDerivation {
    pname = "comfyui-impact-subpack";
    version = versions.customNodes.comfyui-impact-subpack.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-impact-subpack.owner;
      repo = versions.customNodes.comfyui-impact-subpack.repo;
      rev = versions.customNodes.comfyui-impact-subpack.rev;
      hash = versions.customNodes.comfyui-impact-subpack.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        matplotlib
        ultralytics
        numpy
        opencv-python-headless
        dill
      ];

    meta = with lib; {
      description = "ComfyUI-Impact-Subpack - This extension serves as a complement to the Impact Pack, offering features that are not deemed suitable for inclusion by default in the ComfyUI Impact Pack";
      homepage = "https://github.com/ltdrdata/ComfyUI-Impact-Subpack";
      license = licenses.gpl3;
    };
  };

  # ComfyUI-Custom-Scripts
  comfyui-custom-scripts = pkgs.stdenv.mkDerivation {
    pname = "comfyui-custom-scripts";
    version = versions.customNodes.comfyui-custom-scripts.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-custom-scripts.owner;
      repo = versions.customNodes.comfyui-custom-scripts.repo;
      rev = versions.customNodes.comfyui-custom-scripts.rev;
      hash = versions.customNodes.comfyui-custom-scripts.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
      ];

    meta = with lib; {
      description = "ComfyUI-Custom-Scripts / PlaySound|pysssss - Enhancements & experiments for ComfyUI, mostly focusing on UI features";
      homepage = "https://github.com/pythongosssss/ComfyUI-Custom-Scripts";
      license = licenses.gpl3;
    };
  };

  # ComfyUI-VideoHelperSuite
  comfyui-videohelpersuite = pkgs.stdenv.mkDerivation {
    pname = "comfyui-videohelpersuite";
    version = versions.customNodes.comfyui-videohelpersuite.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-videohelpersuite.owner;
      repo = versions.customNodes.comfyui-videohelpersuite.repo;
      rev = versions.customNodes.comfyui-videohelpersuite.rev;
      hash = versions.customNodes.comfyui-videohelpersuite.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        opencv-python
        imageio-ffmpeg
      ];

    meta = with lib; {
      description = "ComfyUI-VideoHelperSuite";
      homepage = "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite";
      license = licenses.gpl3;
    };
  };

  # SeedVR2
  comfyui-seedvr2_videoupscaler = pkgs.stdenv.mkDerivation {
    pname = "comfyui-seedvr2_videoupscaler";
    version = versions.customNodes.comfyui-seedvr2_videoupscaler.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-seedvr2_videoupscaler.owner;
      repo = versions.customNodes.comfyui-seedvr2_videoupscaler.repo;
      rev = versions.customNodes.comfyui-seedvr2_videoupscaler.rev;
      hash = versions.customNodes.comfyui-seedvr2_videoupscaler.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        safetensors
        numpy
        tqdm
        psutil
        einops
        omegaconf
        diffusers
        peft
        rotary_embedding_torch
        opencv-python
        gguf
        matplotlib
      ];

    meta = with lib; {
      description = "ComfyUI-SeedVR2_VideoUpscaler";
      homepage = "https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler";
      license = licenses.gpl3;
    };
  };

  # comfyui-logic
  comfyui-logic = pkgs.stdenv.mkDerivation {
    pname = "comfyui-logic";
    version = versions.customNodes.comfyui-logic.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-logic.owner;
      repo = versions.customNodes.comfyui-logic.repo;
      rev = versions.customNodes.comfyui-logic.rev;
      hash = versions.customNodes.comfyui-logic.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
      ];

    meta = with lib; {
      description = "ComfyUI-Logic";
      homepage = "https://github.com/theUpsider/ComfyUI-Logic";
      license = licenses.gpl3;
    };
  };

  # comfyui_essentials_mb
  comfyui_essentials_mb = pkgs.stdenv.mkDerivation {
    pname = "comfyui_essentials_mb";
    version = versions.customNodes.comfyui_essentials_mb.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui_essentials_mb.owner;
      repo = versions.customNodes.comfyui_essentials_mb.repo;
      rev = versions.customNodes.comfyui_essentials_mb.rev;
      hash = versions.customNodes.comfyui_essentials_mb.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        numba
        colour-science
        rembg
        pixeloe
        transparent-background
      ];

    meta = with lib; {
      description = "ComfyUI_essentials_mb";
      homepage = "https://github.com/MinorBoy/ComfyUI_essentials_mb";
      license = licenses.gpl3;
    };
  };

  # comfyliterals
  comfyliterals = pkgs.stdenv.mkDerivation {
    pname = "comfyliterals";
    version = versions.customNodes.comfyliterals.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyliterals.owner;
      repo = versions.customNodes.comfyliterals.repo;
      rev = versions.customNodes.comfyliterals.rev;
      hash = versions.customNodes.comfyliterals.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
      ];

    meta = with lib; {
      description = "ComfyLiterals";
      homepage = "https://github.com/M1kep/ComfyLiterals";
      license = licenses.gpl3;
    };
  };

  # comfyui_comfyroll_customnodes
  comfyui_comfyroll_customnodes = pkgs.stdenv.mkDerivation {
    pname = "comfyui_comfyroll_customnodes";
    version = versions.customNodes.comfyui_comfyroll_customnodes.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui_comfyroll_customnodes.owner;
      repo = versions.customNodes.comfyui_comfyroll_customnodes.repo;
      rev = versions.customNodes.comfyui_comfyroll_customnodes.rev;
      hash = versions.customNodes.comfyui_comfyroll_customnodes.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
      ];

    meta = with lib; {
      description = "ComfyUI_Comfyroll_CustomNodes";
      homepage = "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes";
      license = licenses.gpl3;
    };
  };

  # intelligentvramnode
  intelligentvramnode = pkgs.stdenv.mkDerivation {
    pname = "intelligentvramnode";
    version = versions.customNodes.intelligentvramnode.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.intelligentvramnode.owner;
      repo = versions.customNodes.intelligentvramnode.repo;
      rev = versions.customNodes.intelligentvramnode.rev;
      hash = versions.customNodes.intelligentvramnode.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        psutil
        numpy
      ];

    meta = with lib; {
      description = "IntelligentVRAMNode";
      homepage = "https://github.com/eddyhhlure1Eddy/IntelligentVRAMNode";
      license = licenses.gpl3;
    };
  };

  # comfyui-frame-interpolation_cudafull
  comfyui-frame-interpolation_cudafull = pkgs.stdenv.mkDerivation {
    pname = "comfyui-frame-interpolation_cudafull";
    version = versions.customNodes.comfyui-frame-interpolation_cudafull.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-frame-interpolation_cudafull.owner;
      repo = versions.customNodes.comfyui-frame-interpolation_cudafull.repo;
      rev = versions.customNodes.comfyui-frame-interpolation_cudafull.rev;
      hash = versions.customNodes.comfyui-frame-interpolation_cudafull.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        numpy
        einops
        opencv-contrib-python
        kornia
        scipy
        Pillow
        torchvision
        tqdm
      ];

    meta = with lib; {
      description = "comfyui-frame-interpolation_cudafull";
      homepage = "https://github.com/Fannovel16/comfyui-frame-interpolation_cudafull";
      license = licenses.gpl3;
    };
  };

  # comfy_mtb
  comfy_mtb = pkgs.stdenv.mkDerivation {
    pname = "comfy_mtb";
    version = versions.customNodes.comfy_mtb.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfy_mtb.owner;
      repo = versions.customNodes.comfy_mtb.repo;
      rev = versions.customNodes.comfy_mtb.rev;
      hash = versions.customNodes.comfy_mtb.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        qrcode
        onnxruntime # onnxruntime-gpu
        requirements-parser
        # opencv-contrib
        rembg
        imageio-ffmpeg
        rich
        rich-argparse
        matplotlib
        pillow
        cachetools
        transformers
      ];

    meta = with lib; {
      description = "comfy_mtb";
      homepage = "https://github.com/melMass/comfy_mtb";
      license = licenses.gpl3;
    };
  };

  # comfyui-mxtoolkit
  comfyui-mxtoolkit = pkgs.stdenv.mkDerivation {
    pname = "comfyui-mxtoolkit";
    version = versions.customNodes.comfyui-mxtoolkit.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-mxtoolkit.owner;
      repo = versions.customNodes.comfyui-mxtoolkit.repo;
      rev = versions.customNodes.comfyui-mxtoolkit.rev;
      hash = versions.customNodes.comfyui-mxtoolkit.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [

      ];

    meta = with lib; {
      description = "comfyui-mxtoolkit";
      homepage = "https://github.com/Smirnov75/ComfyUI-mxToolkit";
      license = licenses.gpl3;
    };
  };

  # comfyui-vfi
  comfyui-vfi = pkgs.stdenv.mkDerivation {
    pname = "comfyui-vfi";
    version = versions.customNodes.comfyui-vfi.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-vfi.owner;
      repo = versions.customNodes.comfyui-vfi.repo;
      rev = versions.customNodes.comfyui-vfi.rev;
      hash = versions.customNodes.comfyui-vfi.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        numpy
        requests
      ];

    meta = with lib; {
      description = "comfyui-vfi";
      homepage = "https://github.com/GACLove/ComfyUI-VFI";
      license = licenses.gpl3;
    };
  };

  # comfyui-int-and-float
  comfyui-int-and-float = pkgs.stdenv.mkDerivation {
    pname = "comfyui-int-and-float";
    version = versions.customNodes.comfyui-int-and-float.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.comfyui-int-and-float.owner;
      repo = versions.customNodes.comfyui-int-and-float.repo;
      rev = versions.customNodes.comfyui-int-and-float.rev;
      hash = versions.customNodes.comfyui-int-and-float.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [

      ];

    meta = with lib; {
      description = "comfyui-int-and-float";
      homepage = "https://github.com/danTheMonk/comfyui-int-and-float";
      license = licenses.gpl3;
    };
  };

  # facerestore_cf
  facerestore_cf = pkgs.stdenv.mkDerivation {
    pname = "facerestore_cf";
    version = versions.customNodes.facerestore_cf.version;

    src = pkgs.fetchFromGitHub {
      owner = versions.customNodes.facerestore_cf.owner;
      repo = versions.customNodes.facerestore_cf.repo;
      rev = versions.customNodes.facerestore_cf.rev;
      hash = versions.customNodes.facerestore_cf.hash;
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';

    # Python dependencies required
    passthru.pythonDeps =
      ps: with ps; [
        opencv-python
        numpy
        torch
        torchvision
        addict
        future
        lmdb
        Pillow
        pyyaml
        requests
        scikit-image
        scipy
        tb-nightly
        tqdm
        yapf
        lpips
        gdown
      ];

    meta = with lib; {
      description = "facerestore_cf";
      homepage = "https://github.com/mav-rik/facerestore_cf";
      license = licenses.gpl3;
    };
  };

in
{
  inherit
    impact-pack
    rgthree-comfy
    kjnodes
    gguf
    ltxvideo
    florence2
    bitsandbytes-nf4
    x-flux
    mmaudio
    pulid
    wanvideo
    comfyui-easy-use
    comfyui-lora-manager
    comfyui-impact-subpack
    comfyui-custom-scripts
    comfyui-videohelpersuite
    comfyui-seedvr2_videoupscaler
    comfyui-logic
    comfyui_essentials_mb
    comfyliterals
    comfyui_comfyroll_customnodes
    intelligentvramnode
    comfyui-frame-interpolation_cudafull
    comfy_mtb
    comfyui-mxtoolkit
    comfyui-vfi
    comfyui-int-and-float
    facerestore_cf
    ;
}
