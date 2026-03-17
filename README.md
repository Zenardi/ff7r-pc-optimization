# FF7 Remake: The Ultimate Performance & Stuttering Fix (Windows & Linux)

This repository provides a comprehensive guide to fixing the notorious Unreal Engine 4 stuttering issues in *Final Fantasy VII Remake Intergrade* on PC, while offering options for modern upscaling technologies (DLSS/FSR) and raw stability.

This guide covers the installation of essential mods and crucial OS-level configurations:
1. **[FFVIIHook](https://www.nexusmods.com/finalfantasy7remake/mods/74):** Unlocks the developer console and allows custom `Engine.ini` configurations.
2. **[SPF (Stuttering Prevention Fix)](https://www.nexusmods.com/finalfantasy7remake/mods/66):** Re-architects CPU thread allocation to prevent shader compilation stutters.
3. **[Luma - DLSS/FSR Upscaling Mod](https://www.nexusmods.com/finalfantasy7remake/mods/1974):** Replaces the default dynamic resolution with NVIDIA DLSS / AMD FSR and enables Frame Generation (Optional - Windows/DX12 focus).

- [FF7 Remake: The Ultimate Performance \& Stuttering Fix (Windows \& Linux)](#ff7-remake-the-ultimate-performance--stuttering-fix-windows--linux)
  - [⚙️ The Master `Engine.ini` Configuration](#️-the-master-engineini-configuration)
    - [🌟 Optional: Ultra Graphics Configuration (8GB+ VRAM)](#-optional-ultra-graphics-configuration-8gb-vram)
  - [🪟 Windows Installation](#-windows-installation)
    - [1. Install the Mods](#1-install-the-mods)
    - [2. Apply the Engine Config](#2-apply-the-engine-config)
    - [3. Steam Launch Options](#3-steam-launch-options)
  - [🐧 Linux (Ubuntu / Pop!\_OS / Steam Deck) Configuration](#-linux-ubuntu--pop_os--steam-deck-configuration)
    - [1. Install the Essential Mods](#1-install-the-essential-mods)
    - [2. Apply the Engine Config](#2-apply-the-engine-config-1)
    - [3. Proper NVIDIA Driver Installation (Modern RTX Series)](#3-proper-nvidia-driver-installation-modern-rtx-series)
    - [4. Steam Launch Options (The Crucial Step)](#4-steam-launch-options-the-crucial-step)
  - [📊 Linux: Monitoring Performance with MangoHud](#-linux-monitoring-performance-with-mangohud)
    - [1. Installation](#1-installation)
    - [2. In-Game Usage](#2-in-game-usage)
  - [🎮 Bonus: Native DualSense (PS5) Support](#-bonus-native-dualsense-ps5-support)
    - [🖥️ Tested Environment](#️-tested-environment)

---

## ⚙️ The Master `Engine.ini` Configuration

Both Windows and Linux installations will require this highly optimized configuration block. It combines the SPF multithreading tweaks with forced 100% native resolution, disabling the game's aggressive dynamic resolution scaling, motion blur, and depth of field.

Create or edit your `Engine.ini` file (paths provided in the OS sections below) and paste the following:

```ini
[SystemSettings]
niagara.CreateShadersOnLoad=1
D3D12.PSO.DiskCache=1
D3D12.PSO.DriverOptimizedDiskCache=1
D3D12.AsyncDeferredDeletion=1
D3D12.ResidencyManagement=1
D3D12.SyncThreshold=999
D3D12.Aftermath=0

[/Script/Engine.RendererSettings]
r.CreateShadersOnLoad=1
r.UseShaderCaching=1
r.AsyncCompute=1
r.AsyncPipelineCompile=1
r.GTSyncType=1 
r.DontLimitOnBattery=1
r.AOAsyncBuildQueue=1
r.RDG.AsyncCompute=1
r.Shaders.Optimize=1
r.ShaderPipelineCache.PreOptimizeEnabled=1
r.ShaderPipelineCache.ReportPSO=0
r.ShaderPipelineCache.LogPSO=0
r.ShaderComplexity.CacheShaders=1
r.ShaderPipelineCache.SaveUserCache=1
r.ShaderPipelineCache.Enabled=1
r.UseAsyncShaderPrecompilation=1
r.Streaming.UseAsyncRequestsForDDC=1
r.Streaming.AmortizeCPUToGPUCopy=1
r.Streaming.UseNewMetrics=1
r.Streaming.LimitPoolSizeToVRAM=1
r.OneFrameThreadLag=1
r.RHICmdCollectRHIThreadStatsFromHighLevel=0
r.RHICmdBufferWriteLocks=0 
r.VolumetricRenderTarget.PreferAsyncCompute=1
r.Distortion=0
r.DisableDistortion=1
r.GPUCrashDebugging=0
r.GPUCrashDump=0
r.GPUCrashDebugging.Aftermath.Markers=0
r.GPUCrashDebugging.Aftermath.Callstack=0
r.GPUCrashDebugging.Aftermath.TrackAll=0
r.GPUCrash.DataDepth=0
r.ShaderLibrary.PrintExtendedStats=0
r.GPUCrash.Collectionenable=0
r.D3D12.GPUCrashDebuggingMode=0
r.CompileShadersForDevelopment=0
s.MaxIncomingRequestsToStall=0
s.MaxReadyRequestsToStallMB=0
r.EnableDebugSpam_GetObjectPositionAndScale=0
memory.logGenericPlatformMemoryStats=0
fx.ParticlePerfStats.Enabled=0
p.Chaos.VisualDebuggerEnable=0
fx.EnableCircularAnimTrailDump=0
r.SceneColorFringe.Max=0
r.SceneColorFringeQuality=0
r.Shadow.CachePreshadow=1 
r.Shadow.CacheWholeSceneShadows=1
r.UniformBufferPooling=1
r.RHICmdAsyncRHIThreadDispatch=1
gc.CreateGCClusters=1
p.Chaos.PerParticleCollision.ISPC=1
p.Chaos.Spherical.ISPC=1
p.Chaos.Spring.ISPC=1
p.Chaos.TriangleMesh.ISPC=1
p.Chaos.VelocityField.ISPC=1
vm.OptimizeVMByteCode=1
net.TickAllOpenChannels=0
r.Streaming.DefragDynamicBounds=1
r.ParallelRendering=1
r.ParallelTranslucency=1
r.ParallelVelocity=1
r.ParallelSceneCapture=1
r.ParallelRenderUploads=1
r.ParallelParticleUpdate=1
r.ParallelMeshMerge=1
r.ParallelMeshDrawCommands=1
r.ParallelMeshProcessing=1
r.ParallelPhysicsScene=1
r.ParallelAsyncComputeTranslucency=1
r.ParallelAsyncComputeSkinCache=1
r.ParallelZPrepass=1
r.ParallelLandscapeLayerUpdate=1
r.ParallelLandscapeSplatAtlas=1
r.ParallelLandscapeSplineUpdate=1
r.ParallelLandscapeSplineSegmentCalc=1
r.ParallelDistributedScene=1
r.ParallelBatchDispatch=1
r.ParallelCulling=1
r.ParallelDistanceField=1
r.ParallelReflectionCaptures=1
r.ParallelReflectionEnvironment=1
r.ParallelReflectionShadowing=1
r.ParallelLightingComposition=1
r.ParallelLightingSetup=1
r.ParallelLightingBuild=1
r.ParallelLightingInject=1
r.ParallelLightingPropagation=1
r.ParallelTonemapping=1
r.ParallelPostProcessing=1
r.ParallelShadowFade=1
r.ParallelShadowLights=1
r.ParallelShadowDepth=1
r.ParallelShadowFrustums=1
r.ParallelOnePassPointLightShadowRendering=1
r.ParallelCascadeShadowMaps=1
r.ParallelShadowRendering=1
r.ParallelTranslucentShadowRendering=1
r.ParallelSceneColorGather=1
r.ParallelPhysicsStepAsync=1
r.ParallelDestruction=1
r.ParallelNavOctreeUpdate=1
r.ParallelNavBoundsCalc=1
r.ParallelNavBoundsInit=1
r.ParallelNavBoundsUpdate=1
r.ParallelGameThreadInitTasks=1
r.ParallelGameThreadTickTasks=1
r.ParallelSkeletalClothUpdate=1
r.ParallelSkeletalClothSkinning=1
r.ParallelSkeletalClothBoundsCalc=1
r.ParallelSkeletalClothGather=1
r.ParallelSkeletalClothPrepareSim=1
r.ParallelSkeletalClothSimulate=1
r.ParallelSkeletalClothUpdateVerts=1
r.ParallelSkeletalClothUpdateBounds=1
r.ParallelAnimationUpdate=1
r.ParallelAnimationEvaluation=1
r.ParallelAnimationCompression=1
r.ParallelAnimationRetargeting=1
r.ParallelAnimationStreaming=1
r.ParallelAnimationCompressionAsync=1
r.ParallelAnimationRetargetingAsync=1
r.ParallelAnimationStreamingAsync=1
r.ParallelAnimationCacheConversion=1
r.ParallelAnimationCacheConversionAsync=1
r.ParallelAnimationCacheStreaming=1
r.ParallelTaskShaderCompilation=1
r.ParallelMeshBuildUseJobCulling=1
r.ParallelMeshBuildUseJobMerging=1
r.ParallelBasePass=1
r.ParallelGatherShadowPrimitives=1
r.ParallelInitViews=1
r.ParallelPrePass=1
rhi.ResourceTableCaching=1
FX.AllowAsyncTick=1
RHI.SyncThreshold=999
r.RHICmdUseParallelAlgorithms=1
r.RHICmdDeferSkeletalLockAndFillToRHIThread=1
s.ProcessPrestreamingRequests=1
r.Streaming.StressTest.ExtraAsyncLatency=0
r.VT.ParallelFeedbackTasks=1
r.Shadow.Preshadows=1
r.Shadow.CachePreshadow=1
r.ExcludeHLODsFromCachedShadows=0

[/Script/WindowsTargetPlatform.WindowsTargetSettings]
EnableMathOptimisations=True

[DevOptions.Shaders]
bAllowCompilingThroughWorkers=True
bAllowAsynchronousShaderCompiling=True

[/Script/Engine.StreamingSettings]
s.AsyncLoadingThreadEnabled=True
s.MinBulkDataSizeForAsyncLoading=0

[/Script/Engine.GarbageCollectionSettings]
gc.CreateGCClusters=1
gc.AllowParallelGC=1
r.ShaderDrawDebug=0

[/Script/Engine.Engine]
bAllowMultiThreadedShaderCompile=True

[/Script/AkAudio.AkSettings]
bEnableMultiCoreRendering=True

[CrashReportClient]
bAgreeToCrashUpload=False
bImplicitSend=False

[Engine.ErrorHandling]
bPromptForRemoteDebugging=False
bPromptForRemoteDebugOnEnsure=False

[/Script/WInstrumentedProfilersSettings.WTelemetrySettings]
bEnableTelemetry=False

[FATHydraCrashHandler]
LogCrashReportHydra=off
LogCrashUploader=off

[Core.System]
+Suppress=ScriptWarning
+Suppress=Error
+Suppress=ScriptLog
+Suppress=Warning

[Core.Log]
LogPluginManager=all off
LogOnlineIdentity=all off
LogOnlineSession=all off
LogMemory=all off
LogPakFile=all off
LogTemp=all off
LogLinker=all off
LogOnline=all off
LogOnlineGame=all off
LogAnalytics=all off
LogConfig=all off
LogInteractiveProcess=all off
LogInput=all off
LogOnlineEntitlement=all off
LogOnlineEvents=all off
LogOnlineFriend=all off
LogOnlinePresence=all off
LogOnlineTitleFile=all off
LogOnlineUser=all off
Global=off

[ConsoleVariables]
; Forces 100% resolution scale (Disables Dynamic Resolution)
r.DynamicRes.OperationMode=0
r.DynamicRes.MinResolutionRatio=100
r.DynamicRes.MaxResolutionRatio=100
r.ScreenPercentage=100

; Disables Motion Blur
r.MotionBlurQuality=0

; Disables Film Grain
r.Tonemapper.GrainQuantization=0

; Disables Depth of Field (Background blur)
r.DepthOfFieldQuality=0
r.DepthOfField.FarBlur=0
```

###  🌟 Optional: Ultra Graphics Configuration (8GB+ VRAM)
If you have a high-end GPU with plenty of VRAM (like an RTX 5070 or better) and a solid frame rate (60+ FPS), you can push the Unreal Engine 4 well past the game's official "High" settings in the menu.

Replace only the [ConsoleVariables] section at the very bottom of your Engine.ini with this block. It forces 4K shadows, maximum draw distance (eliminating texture pop-in), and cinematic anti-aliasing:

```toml
[ConsoleVariables]
; --- 1. PURE NATIVE RESOLUTION & CLEAN IMAGE ---
r.DynamicRes.OperationMode=0
r.DynamicRes.MinResolutionRatio=100
r.DynamicRes.MaxResolutionRatio=100
r.ScreenPercentage=100
r.MotionBlurQuality=0
r.Tonemapper.GrainQuantization=0
r.DepthOfFieldQuality=0
r.DepthOfField.FarBlur=0

; --- 2. EXTREME SHADOW QUALITY (4K) ---
r.Shadow.MaxResolution=4096
r.Shadow.MaxCSMResolution=4096
r.Shadow.DistanceScale=2.0
r.Shadow.CSM.MaxCascades=4
r.Shadow.RadiusThreshold=0.01

; --- 3. ELIMINATE POP-IN (AGGRESSIVE LOD) ---
r.StaticMeshLODDistanceScale=0.1
r.SkeletalMeshLODBias=-2
r.ViewDistanceScale=3.0
foliage.LODDistanceScale=3.0

; --- 4. ENHANCED TEXTURES & REFLECTIONS ---
r.MaxAnisotropy=16
r.SSR.Quality=4
r.Color.Fringe=0

; --- 5. CINEMATIC ANTI-ALIASING (TAA) ---
r.PostProcessAAQuality=6
r.TemporalAA.Algorithm=1
r.TemporalAASamples=32
```

---

## 🪟 Windows Installation

### 1. Install the Mods
1. Navigate to your game installation folder: `[Steam Library]\steamapps\common\FINAL FANTASY VII REMAKE\End\Binaries\Win64`
2. Extract the `xinput1_3.dll` from the **FFVIIHook** zip file into this folder.
3. Extract the contents of the **Luma** mod (which includes `dxgi.dll` and its configuration files) into the same `Win64` folder.

### 2. Apply the Engine Config
1. Go to your Documents folder:
   `%USERPROFILE%\Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\`
2. Open `Engine.ini` (create it if it doesn't exist) and paste the master configuration provided above. Save and close.

### 3. Steam Launch Options
1. Right-click the game in your Steam Library > **Properties** > **General**.
2. Under **Launch Options**, type:
   `-dx12`
   *(Note: Luma requires DirectX 12 to run DLSS and Frame Generation).*

Once you launch the game, wait for the main menu to load. Press the **`Home`** or **`Insert`** key to open the Luma overlay, where you can select your preferred Upscaler (DLSS/FSR) and enable Frame Generation.

---

## 🐧 Linux (Ubuntu / Pop!_OS / Steam Deck) Configuration

Linux requires specific environment variables to bypass Proton's default libraries and load the injected `.dll` files properly. Furthermore, laptops with hybrid graphics (NVIDIA Optimus) need explicit commands to utilize the dedicated GPU.

> [!IMPORTANT] 
> ⚠️ LINUX PERFORMANCE WARNING (DX11 vs DX12) ⚠️
> 
> The *Luma* mod **requires** DirectX 12 (`-dx12`). However, UE4's DX12 implementation is notoriously poorly optimized and may still cause severe stutters on Linux via VKD3D translation, even with high-end hardware. 
> 
> **For the absolute smoothest experience on Linux:** We highly recommend prioritizing raw stability over AI Frame Generation. Do not install the Luma mod (`dxgi.dll`), and use `-dx11` instead. DXVK (DirectX 11 to Vulkan) handles this game's shader compilation significantly better. The instructions below reflect this optimized approach.

### 1. Install the Essential Mods
1. Navigate to your game installation folder. The default path for the `.deb` Steam installation is: `~/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64`
2. Extract **only** `xinput1_3.dll` (FFVIIHook) into this folder. 

### 2. Apply the Engine Config
1. Navigate to the game's compatdata (prefix) folder:
   `~/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/`
2. Open or create the `Engine.ini` file and paste the master configuration provided above.

### 3. Proper NVIDIA Driver Installation (Modern RTX Series)
Newer graphics cards (like the RTX 50-series) require the new Open GPU Kernel Modules. If your game is running at very low framerates (e.g., 15 FPS), your system might be failing to load the older proprietary drivers and defaulting to integrated graphics.

**Step-by-step to install the correct architecture on Ubuntu:**

1. Clean up any residual old drivers:
   ```bash
   sudo apt purge '^nvidia-.*' -y && sudo apt autoremove -y
   ```
2. Install the recommended open driver and essential Vulkan tools (using version 580 as an example):
   ```bash
   sudo apt update && sudo apt install nvidia-driver-580-open mesa-utils vulkan-tools -y
   ```
3. **Reboot your computer.** (Mandatory for the Kernel to load the new module into memory).
4. After rebooting, verify the installation by running `nvidia-smi` in the terminal. If it returns `No devices were found`, ensure that **Secure Boot** is disabled in your motherboard's BIOS, as it blocks third-party modules from loading.

### 4. Steam Launch Options (The Crucial Step)
To ensure the game uses the dedicated GPU, loads the CPU optimization mod (SPF), runs on the stable DX11 API, and enables telemetry, use the following command in the game's **Launch Options** on Steam:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia WINEDLLOVERRIDES="xinput1_3=n,b" gamemoderun mangohud %command% -dx11
```

**What this command does:**
* `__NV_PRIME...` & `__GLX_VENDOR...`: Forces the system to use the dedicated NVIDIA GPU.
* `WINEDLLOVERRIDES="xinput1_3=n,b"`: Ensures the proper injection of the SPF mod.
* `gamemoderun`: Enables Feral GameMode for maximum processing priority.
* `mangohud`: Displays the telemetry overlay.
* `-dx11`: Forces DirectX 11.

*(Note: If you insist on trying the Luma DLSS/FSR Mod on Linux, you must add `;dxgi=n,b` to the `WINEDLLOVERRIDES`, add `PROTON_ENABLE_NVAPI=1` to the beginning, and change `-dx11` to `-dx12`).*

---

## 📊 Linux: Monitoring Performance with MangoHud

To truly validate if the stuttering is gone, you can use **MangoHud**, the standard performance overlay for Linux.

### 1. Installation 
For Ubuntu, Pop!_OS, or Debian-based distributions, open your terminal and install the package:
```bash
sudo apt update && sudo apt install mangohud -y
```

### 2. In-Game Usage
Because `mangohud` is included in the Launch Options command above, the overlay will automatically appear in the top-left corner when the game starts. 
* Ensure the very top line displays your NVIDIA GPU (not integrated graphics or DXVK generic names).
* Pay close attention to the **Frametime graph**. A perfectly flat line means the engine optimizations are working flawlessly.
* *Tip: Press `Right Shift + F12` to toggle the overlay on and off.*

---

## 🎮 Bonus: Native DualSense (PS5) Support

If you use a PS5 controller and want to see the original PlayStation button prompts (Triangle, Circle, Cross, Square) in the game's UI instead of generic Xbox icons:

1. Go to the game's **Properties** in Steam.
2. In the **Controller** tab, change the override option to **Disable Steam Input**.

This forces Steam to stop translating the inputs, allowing the game to read the DualSense signals directly via Proton and natively activating the correct visual prompts without the need for visual mods.

### 🖥️ Tested Environment
The configurations, driver installations, and launch parameters in this guide were successfully tested and validated on the following setup:
* **OS:** Ubuntu 25.10
* **GPU:** NVIDIA GeForce RTX 5070 Max-Q / Mobile (Open Kernel Driver: 580.126.09)
* **Graphics API:** DirectX 11 (via DXVK translation)
* **Controller:** PS5 DualSense (Native input, Steam Input disabled)