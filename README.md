# FF7 Remake: The Ultimate Performance & Stuttering Fix (Windows & Linux)

This repository provides a comprehensive guide to fixing the notorious Unreal Engine 4 stuttering issues in *Final Fantasy VII Remake Intergrade* on PC, while injecting modern upscaling technologies (DLSS/FSR and Frame Generation).

This guide compiles the installation of three essential mods:
1. **[FFVIIHook](https://www.nexusmods.com/finalfantasy7remake/mods/74):** Unlocks the developer console and allows custom `Engine.ini` configurations.
2. **[SPF (Stuttering Prevention Fix)](https://www.nexusmods.com/finalfantasy7remake/mods/66):** Re-architects CPU thread allocation to prevent shader compilation stutters.
3. **[Luma - DLSS/FSR Upscaling Mod](https://www.nexusmods.com/finalfantasy7remake/mods/1974):** Replaces the default dynamic resolution with NVIDIA DLSS / AMD FSR and enables Frame Generation.

- [FF7 Remake: The Ultimate Performance \& Stuttering Fix (Windows \& Linux)](#ff7-remake-the-ultimate-performance--stuttering-fix-windows--linux)
  - [⚙️ The Master `Engine.ini` Configuration](#️-the-master-engineini-configuration)
  - [🪟 Windows Installation](#-windows-installation)
    - [1. Install the Mods](#1-install-the-mods)
    - [2. Apply the Engine Config](#2-apply-the-engine-config)
    - [3. Steam Launch Options](#3-steam-launch-options)
  - [🐧 Linux / Steam Deck Installation (Proton)](#-linux--steam-deck-installation-proton)
    - [1. Install the Mods](#1-install-the-mods-1)
    - [2. Apply the Engine Config](#2-apply-the-engine-config-1)
    - [3. Steam Launch Options (The Crucial Step)](#3-steam-launch-options-the-crucial-step)
    - [🎮 In-Game Activation](#-in-game-activation)
  - [📊 Linux Bonus: Monitoring Performance with MangoHud](#-linux-bonus-monitoring-performance-with-mangohud)
    - [1. Installation](#1-installation)
    - [2. Steam Launch Options Integration](#2-steam-launch-options-integration)
    - [3. In-Game Usage](#3-in-game-usage)


---

## ⚙️ The Master `Engine.ini` Configuration

Both Windows and Linux installations will require this highly optimized configuration block. It combines the SPF multithreading tweaks with forced 100% native resolution, disabling the game's aggressive dynamic resolution scaling and blur effects.

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

---

## 🐧 Linux / Steam Deck Installation (Proton)

Linux requires specific environment variables to bypass Proton's default libraries and load the injected `.dll` files properly. 

### 1. Install the Mods
1. Navigate to your game installation folder: `~/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64`
2. Extract both `xinput1_3.dll` (FFVIIHook) and `dxgi.dll` (Luma) into this folder.

### 2. Apply the Engine Config
1. Navigate to the game's compatdata (prefix) folder. The default path is:
   `~/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/`
2. Open or create the `Engine.ini` file and paste the master configuration provided above.

### 3. Steam Launch Options (The Crucial Step)
To ensure Proton loads the mods natively and exposes your GPU's DLSS/FSR capabilities, you must set specific overrides.

1. Right-click the game in your Steam Library > **Properties** > **General**.
2. Under **Launch Options**, paste the following:

   ```bash
   PROTON_ENABLE_NVAPI=1 WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b" gamemoderun %command% -dx12
   ```

> [!IMPORTANT] 
> ⚠️ LINUX PERFORMANCE WARNING (DX11 vs DX12) ⚠️
> 
> The *Luma* mod **requires** DirectX 12 (`-dx12`). However, UE4's DX12 implementation is notoriously poorly optimized and may still cause minor stutters on Linux via VKD3D translation, even with high-end hardware. 
> 
> **For the absolute smoothest experience on Linux:** If you have a powerful GPU and prefer raw stability over AI Frame Generation, delete the Luma mod (`dxgi.dll`), remove `dxgi=n,b` and `NVAPI` from your launch options, and use `-dx11` instead. DXVK (DirectX 11 to Vulkan) handles this game's shader compilation significantly better.

---

### 🎮 In-Game Activation
Once you launch the game, wait for the main menu to load. Press the **`Home`** or **`Insert`** key to open the Luma overlay, where you can select your preferred Upscaler (DLSS/FSR) and enable Frame Generation. 

---

## 📊 Linux Bonus: Monitoring Performance with MangoHud

To truly validate if the stuttering is gone and if Frame Generation is delivering stable frametimes, you can use **MangoHud**, the standard performance overlay for Linux (the equivalent of MSI Afterburner/RivaTuner).

### 1. Installation 
For Ubuntu, Pop!_OS, or Debian-based distributions, open your terminal and install the package:
```bash
sudo apt update && sudo apt install mangohud -y
```
*(Note: If you are using the Flatpak version of Steam, install it via: `flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud`)*

### 2. Steam Launch Options Integration
To inject the telemetry overlay into the game, simply add `mangohud` right before the `%command%` variable in your Steam Launch Options.

Your final, complete Linux launch command will look like this:

**For the Luma DLSS/FSR Setup (DX12):**
```bash
PROTON_ENABLE_NVAPI=1 WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b" gamemoderun mangohud %command% -dx12
```

**For the Pure Stability Setup (DX11, no Luma):**
```bash
WINEDLLOVERRIDES="xinput1_3=n,b" gamemoderun mangohud %command% -dx11
```

### 3. In-Game Usage
Once the game launches, the MangoHud overlay will appear in the top-left corner. Pay close attention to the **Frametime graph** (the horizontal line plot). A perfectly flat line means the engine optimizations from the `Engine.ini` are working flawlessly, delivering a smooth, stutter-free experience. 

*Tip: You can press `Right Shift + F12` on your keyboard to toggle the overlay on and off during gameplay.*