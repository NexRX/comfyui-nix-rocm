{
  comfyui = {
    version = "0.7.0";
    releaseDate = "2025-12-31T07:50:53Z";
    rev = "f59f71cf34067d46713f6243312f7f0b360d061f";
    hash = "sha256-cMi27y1KCiZTjzx3J6FuHqEYjZjL/VChPtlUnTxHVAg=";
  };

  vendored = {
    spandrel = {
      version = "0.4.1";
      url = "https://files.pythonhosted.org/packages/d3/1e/5dce7f0d3eb2aa418bd9cf3e84b2f5d2cf45b1c62488dd139fc93c729cfe/spandrel-0.4.1-py3-none-any.whl";
      hash = "sha256-SaOaqXl2l0mkIgNCg1W8SEBFKFTWM0zg1GWvRgmN1Eg=";
    };

    frontendPackage = {
      version = "1.37.1";
      url = "https://files.pythonhosted.org/packages/b4/2c/d398ac619998788533a3f13572c358c6db9bf19830049d04314f7414f967/comfyui_frontend_package-1.37.1-py3-none-any.whl";
      hash = "sha256-qjgzFd+FSEvYjqdXUDep8mG1sac40s6miwe6Sp6Do3Q=";
    };

    workflowTemplates = {
      version = "0.7.65";
      url = "https://files.pythonhosted.org/packages/d7/4e/7bf0afd53f29b0339615fff5987f205b9f0038f86079812d6e00b1c70972/comfyui_workflow_templates-0.7.65-py3-none-any.whl";
      hash = "sha256-RWdfcM4z0JE29NM7RIY9TQCK5YYR5D3zSsQzti1Ur3o=";
    };

    workflowTemplatesCore = {
      version = "0.3.65";
      url = "https://files.pythonhosted.org/packages/08/d6/39686f2208c01d611267aeeaa23482abc13bce8e2b168a2a452b4e17a845/comfyui_workflow_templates_core-0.3.65-py3-none-any.whl";
      hash = "sha256-D7MwujlEAmawa0QewlwjTxgkdNu756PVaqxT/+mOtPU=";
    };

    workflowTemplatesMediaApi = {
      version = "0.3.34";
      url = "https://files.pythonhosted.org/packages/ab/95/3ad3a007aee5866aa99953c52d5f6111e82ff8e9273763ab23810424d89d/comfyui_workflow_templates_media_api-0.3.34-py3-none-any.whl";
      hash = "sha256-7gMGVwo1x/XN98eP5GoR4eQh62JoosJIFplKGS1QBrM=";
    };

    workflowTemplatesMediaVideo = {
      version = "0.3.22";
      url = "https://files.pythonhosted.org/packages/74/be/72e7e1c6fd7b27aeb016a4d1ab96d0246dd41d8b41d9b95007b00df9578a/comfyui_workflow_templates_media_video-0.3.22-py3-none-any.whl";
      hash = "sha256-jcDfKcbpO5jgkUtxSEUTG84cgJNGISCrzG6tMecf09s=";
    };

    workflowTemplatesMediaImage = {
      version = "0.3.47";
      url = "https://files.pythonhosted.org/packages/30/9a/bba708199512ea0d4c03cb2248b178c847f4f158c19723e2eee76294590a/comfyui_workflow_templates_media_image-0.3.47-py3-none-any.whl";
      hash = "sha256-YbNxK5XXgXCwW7N7viaQtQuI6LLs1Cjc7fXWloPvGKc=";
    };

    workflowTemplatesMediaOther = {
      version = "0.3.63";
      url = "https://files.pythonhosted.org/packages/92/27/7959fe6008fc0bee3a360292b0ff7d47e600aad1c33b74aafad514ac643c/comfyui_workflow_templates_media_other-0.3.63-py3-none-any.whl";
      hash = "sha256-9i5pxESyYeEtFif8Q4FeU7M/zsjayO0O7tTb0/b05lg=";
    };

    embeddedDocs = {
      version = "0.3.1";
      url = "https://files.pythonhosted.org/packages/25/29/84cf6f3cb9ef558dc5056363d1676174f0f4444a741f5cb65554af06836c/comfyui_embedded_docs-0.3.1-py3-none-any.whl";
      hash = "sha256-+7sO+Z6r2Hh8Zl7+I1ZlsztivV+bxNlA6yBV02g0yRw=";
    };

    manager = {
      version = "4.0.4";
      url = "https://files.pythonhosted.org/packages/24/52/ecc15ce24f7ed9c336a13553e6b4dc0777e2082f1e6afca0ecbe5e02564f/comfyui_manager-4.0.4-py3-none-any.whl";
      hash = "sha256-H08Wrr2ZDk5NfeQhF5Csr1QUBa/Ohmpvkwrp1tuRu50=";
    };

    # Python packages not in nixpkgs (vendored for custom nodes)
    segment-anything = {
      version = "1.0";
      rev = "dca509fe793f601edb92606367a655c15ac00fdf";
      hash = "sha256-28XHhv/hffVIpbxJKU8wfPvDB63l93Z6r9j1vBOz/P0=";
    };

    sam2 = {
      version = "1.0";
      rev = "2b90b9f5ceec907a1c18123530e92e794ad901a4";
      hash = "sha256-pUPaUD/5wOhdJcNYPH9LV5oA1noDeWKconfpIFOyYBQ=";
    };

    color-matcher = {
      version = "0.6.0";
      url = "https://files.pythonhosted.org/packages/a0/3a/f3c2c5012f59235ff5885db7cc75dc209eca90e42ae3728db56f8a9e28a4/color_matcher-0.6.0-py3-none-any.whl";
      hash = "sha256-/WQvlBTDO38+vJb+CIjBxiAINhQmZFic4sy1LrzadzQ=";
    };

    # facexlib - face processing library needed by PuLID
    facexlib = {
      version = "0.3.0";
      url = "https://files.pythonhosted.org/packages/36/7b/2147339dafe1c4800514c9c21ee4444f8b419ce51dfc7695220a8e0069a6/facexlib-0.3.0-py3-none-any.whl";
      hash = "sha256-JF1YhhU3uCDGFuiz72GMz60qJHJKLXS+KwVCZDwBqHg=";
    };
  };

  # Pre-built PyTorch wheels from pytorch.org
  # These avoid compiling PyTorch from source (which requires 30-60GB RAM)
  # ROCm wheels bundle ROCm libraries, so no separate ROCm toolkit needed at runtime
  # macOS wheels use PyTorch 2.5.1 to avoid MPS issues on macOS 26 (Tahoe)
  pytorchWheels = {
    # macOS Apple Silicon (arm64) - PyTorch 2.5.1 (2.9.x has MPS bugs on macOS 26)
    darwinArm64 = {
      torch = {
        version = "2.5.1";
        url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp312-none-macosx_11_0_arm64.whl";
        hash = "sha256-jHEt9hEBlk6xGRCoRlFAEfC29ZIMVdv1Z7/4o0Fj1bE=";
      };
      torchvision = {
        version = "0.20.1";
        url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp312-cp312-macosx_11_0_arm64.whl";
        hash = "sha256-GjElb/lF1k8Aa7MGgTp8laUx/ha/slNcg33UwQRTPXo=";
      };
      torchaudio = {
        version = "2.5.1";
        url = "https://download.pytorch.org/whl/cpu/torchaudio-2.5.1-cp312-cp312-macosx_11_0_arm64.whl";
        hash = "sha256-8cv9/Ru9++conUenTzb/bF2HwyBWBiAv71p/tpP2HPA=";
      };
    };
    # Linux x86_64 ROCm 7.1
    rocm = {
      torch = {
        version = "2.10.0";
        url = "https://download.pytorch.org/whl/rocm7.1/torch-2.10.0%2Brocm7.1-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=008ee0d77bb8b5f9f4ee1f00212019c4619171e3c4195de56f253331b3bc320d";
        hash = "sha256-AI7g13u4tfn07h8AISAZxGGRcePEGV3lbyUzMbO8Mg0=";
      };
      torchvision = {
        version = "0.25.0";
        url = "https://download.pytorch.org/whl/rocm7.1/torchvision-0.25.0%2Brocm7.1-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=8aea3ddbdb74801d3374577a10b3f04d49897c27add235cb25313df6e65b1929";
        hash = "sha256-iuo929t0gB0zdFd6ELPwTUmJfCet0jXLJTE99uZbGSk=";
      };
      torchaudio = {
        version = "2.10.0";
        url = "https://download.pytorch.org/whl/rocm7.1/torchaudio-2.10.0%2Brocm7.1-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=a54b8c1f61de01b1ab946589aa015821dd11093544702249d20aba56913c68bb";
        hash = "sha256-pUuMH2HeAbGrlGWJqgFYId0RCTVEcCJJ0gq6VpE8aLs=";
      };
    };
  };

  # Custom nodes with pinned versions
  customNodes = {
    impact-pack = {
      version = "8.28";
      owner = "ltdrdata";
      repo = "ComfyUI-Impact-Pack";
      rev = "8.28";
      hash = "sha256-V/gMPqo9Xx21+KpG5LPzP5bML9nGlHHMyVGoV+YgFWE=";
    };

    rgthree-comfy = {
      version = "1.0.2512112053";
      owner = "rgthree";
      repo = "rgthree-comfy";
      rev = "8ff50e4521881eca1fe26aec9615fc9362474931";
      hash = "sha256-MueLFV5gaK6vPI0BEPxL3ZueOK2eFcZzajLyo95HrOE=";
    };

    kjnodes = {
      version = "2025-12-28";
      owner = "kijai";
      repo = "ComfyUI-KJNodes";
      rev = "7b1327192e4729085788a3020a9cbb095e0c7811";
      hash = "sha256-5poI2WQb8ZDfFFqL/INVQICgkshD61YUL2lcXw/nS+U=";
    };

    gguf = {
      version = "2025-12-18";
      owner = "city96";
      repo = "ComfyUI-GGUF";
      rev = "795e45156ece99afbc3efef911e63fcb46e6a20d";
      hash = "sha256-A/mI+S7WqxGi0eHvmM8VuyjWPIshxjeWdPoi0osaBpM=";
    };

    ltxvideo = {
      version = "2025-12-02";
      owner = "Lightricks";
      repo = "ComfyUI-LTXVideo";
      rev = "08f892eace7a20ea441440f320dfa92f6d2abf5f";
      hash = "sha256-6oAp+7dd5rmZrxV8K3q0Z6vQZSJ35mQ6hC/e2EmftB0=";
    };

    florence2 = {
      version = "1.0.7";
      owner = "kijai";
      repo = "ComfyUI-Florence2";
      rev = "6c766b13f4908a86cfbd6357d6d485c80e0f3a2f";
      hash = "sha256-XNr5DFT18hhxb9DwQZxlkLVVRgF2B6ZK9LR/1ukLWIo=";
    };

    bitsandbytes-nf4 = {
      version = "2024-08-15";
      owner = "comfyanonymous";
      repo = "ComfyUI_bitsandbytes_NF4";
      rev = "6c65152bc48b28fc44cec3aa44035a8eba400eb9";
      hash = "sha256-akwKtwW3uDOe/anox5B/WT7Fx2n+7hP0elaYO2cyJFk=";
    };

    x-flux = {
      version = "2024-10-30";
      owner = "XLabs-AI";
      repo = "x-flux-comfyui";
      rev = "00328556efc9472410d903639dc9e68a8471f7ac";
      hash = "sha256-9487Ijtwz0VZGOHknMTbrJgZHsNjDHJnLK9NtohpO0A=";
    };

    mmaudio = {
      version = "2025-12-12";
      owner = "kijai";
      repo = "ComfyUI-MMAudio";
      rev = "e2f9b93aa81fd40ab9f7c71c631863f8b70a72dc";
      hash = "sha256-uNeblSy7z/BGG3NiqMWvXRN4qGcRTGFrfJTvnZ8Tbkw=";
    };

    pulid = {
      version = "2025-04-14";
      owner = "cubiq";
      repo = "PuLID_ComfyUI";
      rev = "93e0c4c226b87b23c0009d671978bad0e77289ff";
      hash = "sha256-gzAqb8rNIKBOR41tPWMM1kUoKOQTOHtPIdS0Uv1Keac=";
    };

    wanvideo = {
      version = "2025-12-31";
      owner = "kijai";
      repo = "ComfyUI-WanVideoWrapper";
      rev = "bf1d77fe155c0bdbefd3d48bf5b320dce8c55849";
      hash = "sha256-H7YMFd0LVCgY3ZpTBu1a47DQ6R25ulJkuteRV2/zgD8=";
    };

    comfyui-easy-use = {
      version = "2026-02-05";
      owner = "yolain";
      repo = "ComfyUI-Easy-Use";
      rev = "7c470c67d6df44498e52c902173c1ac77cd5bdfd";
      hash = "sha256-O92ufDImvD7Dx2a96zlg6bX2QUPRAUmmtr/mPfaINVc=";
    };

    comfyui-lora-manager = {
      version = "2026-02-05";
      owner = "willmiao";
      repo = "ComfyUI-Lora-Manager";
      rev = "b313f36be96a202a36fa2d8bcf24cbb52fb354fc";
      hash = "sha256-8T3KMPWyFYNrI8sV82hai+posz2LP1oaLyzKtnDjo1Y=";
    };

    comfyui-impact-subpack = {
      version = "2026-02-05";
      owner = "ltdrdata";
      repo = "ComfyUI-Impact-Subpack";
      rev = "50c7b71a6a224734cc9b21963c6d1926816a97f1";
      hash = "sha256-+qYmGdHjrWYfJ+uqGURWk1y8kVR0pBc+ObjUyM0A7UA=";
    };

    comfyui-custom-scripts = {
      version = "2026-02-05";
      owner = "pythongosssss";
      repo = "ComfyUI-Custom-Scripts";
      rev = "f2838ed5e59de4d73cde5c98354b87a8d3200190";
      hash = "sha256-0DgPrOFXOjQ4K1RKxLQdtGfJHbopP8iovoJqna8d+Gg=";
    };

    comfyui-videohelpersuite = {
      version = "2026-02-05";
      owner = "Kosinkadink";
      repo = "ComfyUI-VideoHelperSuite";
      rev = "993082e4f2473bf4acaf06f51e33877a7eb38960";
      hash = "sha256-oII4aAK8O44MBaxOATG7tAXmF1ESRm7nacNmj1E3pE8=";
    };

    comfyui-seedvr2_videoupscaler = {
      version = "2026-02-05";
      owner = "numz";
      repo = "ComfyUI-SeedVR2_VideoUpscaler";
      rev = "4df5cef5937001bcef056d5508c6a884849ffe13";
      hash = "sha256-OTFawBd92k4jWpCaroX5civ2KPMAlIrqwg/r/+tDEkg=";
    };

    comfyui-logic = {
      version = "2026-02-05";
      owner = "theUpsider";
      repo = "ComfyUI-Logic";
      rev = "ce53961d17a172fe06f96f5ab6540fd3ef8a353f"; # v1.0.0
      hash = "sha256-ak3+XTBArZKkmU7XIq1nXi0XK1gvZ1wh1CVc/bs3Y3U=";
    };

    comfyui_essentials_mb = {
      version = "2026-02-05";
      owner = "MinorBoy";
      repo = "ComfyUI_essentials_mb";
      rev = "67d7ceb97d465d66a8768069775fc30edee66991"; # v1.1.1
      hash = "sha256-c/oUbt5S2eEv5Y6ZrijHMWys6SYlou+lSfjZ9Q9NVSM=";
    };

    comfyliterals = {
      version = "2026-02-05";
      owner = "M1kep";
      repo = "ComfyLiterals";
      rev = "bdddb08ca82d90d75d97b1d437a652e0284a32ac";
      hash = "sha256-4sP87Ntm5mrNcvKhbUjLVIsVtch/oMLAoGR1OCSfAaM=";
    };

    comfyui_comfyroll_customnodes = {
      version = "2026-02-05";
      owner = "Suzie1";
      repo = "ComfyUI_Comfyroll_CustomNodes";
      rev = "d78b780ae43fcf8c6b7c6505e6ffb4584281ceca";
      hash = "sha256-+qhDJ9hawSEg9AGBz8w+UzohMFhgZDOzvenw8xVVyPc=";
    };

    intelligentvramnode = {
      version = "2026-02-05";
      owner = "eddyhhlure1Eddy";
      repo = "IntelligentVRAMNode";
      rev = "09bae855c3f9630d01c144f81610987e072bb6b9";
      hash = "sha256-OLCaj+FO4LRY6QtBYPTJY4upkVHbmG9ZKP+AdB6pi0k=";
    };

    comfyui-frame-interpolation_cudafull = {
      version = "2026-02-05";
      owner = "eddyhhlure1Eddy";
      repo = "comfyui-frame-interpolation_cudafull";
      rev = "795c28e79036f243a6818b3492907fa475a03882";
      hash = "sha256-5zFhI8HdYvkuv7CBiZMBT1BbKBnC2Dit0xRXWiBjJsQ=";
    };

    comfy_mtb = {
      version = "2026-02-05";
      owner = "melMass";
      repo = "comfy_mtb";
      rev = "d87e52ea2c112fd95f257dcd6a54a5db77a34fc3";
      hash = "sha256-5zFhI8HdYvkuv7CBiZMBT1BbKBnC2Dit0xRXWiBABCD=";
    };

    comfyui-mxtoolkit = {
      version = "2026-02-05";
      owner = "Smirnov75";
      repo = "ComfyUI-mxToolkit";
      rev = "7f7a0e584f12078a1c589645d866ae96bad0cc35";
      hash = "sha256-5zFhI8HdYvkuv7CBiZMBT1BbKBnC2Dit0xRXWiBQWER=";
    };
  };
}
