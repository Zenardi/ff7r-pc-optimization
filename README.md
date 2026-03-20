# FF7 Remake: The Ultimate Performance & Stuttering Fix (Windows & Linux)

This repository provides a comprehensive guide to fixing the notorious Unreal Engine 4 stuttering issues in *Final Fantasy VII Remake Intergrade* on PC, while offering options for modern upscaling technologies (DLSS/FSR) and raw stability.

This guide covers the installation of essential mods and crucial OS-level configurations:
1. **[FFVIIHook](https://www.nexusmods.com/finalfantasy7remake/mods/74):** Unlocks the developer console and allows custom `Engine.ini` configurations.
2. **[SPF (Stuttering Prevention Fix)](https://www.nexusmods.com/finalfantasy7remake/mods/1628):** Re-architects CPU thread allocation to prevent shader compilation stutters.
3. **[Luma - DLSS/FSR Upscaling Mod](https://www.nexusmods.com/finalfantasy7remake/mods/1974):** A DX11-only mod that replaces the game's TAA with NVIDIA DLSS / AMD FSR and can be used on both Windows and Linux.

- [FF7 Remake: The Ultimate Performance \& Stuttering Fix (Windows \& Linux)](#ff7-remake-the-ultimate-performance--stuttering-fix-windows--linux)
  - [⚙️ Engine.ini Configuration Files](#️-engineini-configuration-files)
  - [🪟 Windows Installation](#-windows-installation)
    - [Installation](#installation)
    - [1. The Windows Mod Stack](#1-the-windows-mod-stack)
    - [2. Force DirectX 11](#2-force-directx-11)
    - [3. The Windows-Optimized Engine.ini](#3-the-windows-optimized-engineini)
    - [4. Frame Pacing via NVIDIA Control Panel](#4-frame-pacing-via-nvidia-control-panel)
  - [🐧 Linux (Ubuntu / Pop!\_OS / Steam Deck) Configuration](#-linux-ubuntu--pop_os--steam-deck-configuration)
    - [1. Installation](#1-installation)
    - [2. Install Luma's Proton Dependencies](#2-install-lumas-proton-dependencies)
    - [2.1 Shader Compilation Stutter Fix - Setup Shader Cache For NVIDIA](#21-shader-compilation-stutter-fix---setup-shader-cache-for-nvidia)
    - [2.2 Configuring Vulkan Rendeting Queue](#22-configuring-vulkan-rendeting-queue)
    - [3. Apply Performance Configuration](#3-apply-performance-configuration)
    - [4. Proper NVIDIA Driver Installation (Modern RTX Series)](#4-proper-nvidia-driver-installation-modern-rtx-series)
    - [5. Steam Launch Options](#5-steam-launch-options)
  - [📊 Linux: Monitoring Performance with MangoHud](#-linux-monitoring-performance-with-mangohud)
    - [1. Installation](#1-installation-1)
    - [2. In-Game Usage](#2-in-game-usage)
  - [🎮 Native DualSense (PS5) Support](#-native-dualsense-ps5-support)
    - [🖥️ Tested Environment](#️-tested-environment)

---

## ⚙️ Engine.ini Configuration Files

This repository includes three pre-optimized `Engine.ini` configurations:

- **[Engine.ini](Engine.ini)** — Standard balanced configuration with multithreading optimization, forced native resolution, and motion blur/DOF disabled. Combines SPF tweaks with Unreal Engine 4 performance optimizations.


**Where Engine.ini Goes:**

| Platform | Location |
|----------|----------|
| **Windows (native)** | `%USERPROFILE%\Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\Engine.ini` |
| **Linux (via Proton, .deb)** | `~/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/Engine.ini` |
| **Linux (Flatpak)** | `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/Engine.ini` |

> [!IMPORTANT]
> **DLL files** (FFVIIHook's `xinput1_3.dll` and Luma's `dxgi.dll`) go in a **separate location**: `/End/Binaries/Win64/`

Use the appropriate file when running the installation scripts, or copy its contents to your local Engine.ini file if installing manually.

---

## 🪟 Windows Installation

### Installation

Here is the definitive, clean setup to get the absolute best performance out of *Final Fantasy VII Remake* on Windows.

### 1. The Windows Mod Stack
Drop these into your `End\Binaries\Win64` folder. 

* **FFVIIHook:** Absolutely mandatory. It unlocks the developer console and forces the game to read your custom `Engine.ini`.
* **Luma (DLSS/FSR):** Keep this. Since you are using an NVIDIA GPU, replacing the game's terrible default TAA with DLSS is essential for visual clarity.
* **SPF (Stuttering Prevention Fix):** **Keep this on Windows.** Unlike in Ubuntu where it conflicted with the Linux kernel scheduler, this mod was specifically reverse-engineered for the Windows CPU scheduler. It does a decent job of reallocating thread priority to prevent the game from choking its own main thread.

### 2. Force DirectX 11
By default, the Windows port tries to run on DirectX 12, which is the primary cause of the severe shader compilation stutter in this specific game. 
* Open Steam -> Right-click *Final Fantasy VII Remake* -> Properties.
* In the **Launch Options**, simply type: `-d3d11`

> [!NOTE]
> Because we are forcing DX11, we don't need to use DXVK on Windows. Native DX11 combined with NVIDIA's driver handles the shaders well enough.

### 3. The Windows-Optimized Engine.ini
Since we are forcing DX11, we need to strip out all the DX12 garbage from your previous file. Go to `Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\` and replace the contents of `Engine.ini` with this exact block:

```ini
[SystemSettings]
; --- LUMA - DLSS ---
r.DynamicRes.OperationMode=0
r.DynamicRes.MinScreenPercentage=100
r.TemporalAASamples=8

[/Script/Engine.RendererSettings]
; --- VRAM & Streaming Optimization ---
r.Streaming.PoolSize=0
r.Streaming.LimitPoolSizeToVRAM=1
r.UseShaderCaching=1
r.CreateShadersOnLoad=1
r.ShaderComplexity.CacheShaders=1

[Core.System]
+Suppress=ScriptWarning
+Suppress=Error
+Suppress=ScriptLog
+Suppress=Warning

[ConsoleVariables]
; --- Disable Dynamic Resolution ---
r.DynamicRes.OperationMode=0

; --- Shadow Quality (Balanced for CPU) ---
r.Shadow.MaxResolution=2048
r.Shadow.MaxCSMResolution=2048
r.Shadow.DistanceScale=1.0

; --- Clean Image (Disable Blur/Grain) ---
r.MotionBlurQuality=0
r.Tonemapper.GrainQuantization=0
r.DepthOfFieldQuality=0
r.DepthOfField.FarBlur=0
```

### 4. Frame Pacing via NVIDIA Control Panel
On Linux, we used DXVK to force a perfectly rigid frametime. On Windows, the in-game framerate limiter is notoriously broken and introduces erratic frame pacing (which makes 60 FPS feel like 40 FPS). You must cap the framerate at the driver level.

1.  Open the **NVIDIA Control Panel**.
2.  Go to **Manage 3D Settings** -> **Program Settings** tab.
3.  Select *FINAL FANTASY VII REMAKE* from the drop-down list (or add the `.exe` if it's not there).
4.  Find **Max Frame Rate** and turn it **On**. Set it to exactly **60 FPS** (or your preferred target, like 45 or 120, depending on what your hardware can sustain during traversal).
5.  Find **Power Management Mode** and set it to **Prefer maximum performance** (this stops the laptop's GPU from downclocking during those 1-second CPU bottlenecks).
6.  Hit **Apply**.

This setup is the absolute ceiling of what can be done on Windows. You will likely still notice a slight micro-stutter when transitioning between major zones, but the frametime graph should recover much faster than before.

---

## 🐧 Linux (Ubuntu / Pop!_OS / Steam Deck) Configuration

Linux requires a couple of extra Proton runtime steps so the Luma DLL can load correctly inside the game's prefix. If you are also using FFVIIHook/SPF, keep its DLL override alongside the Luma one.

> [!IMPORTANT]
> Luma for FF7 Remake is **DX11-only**. Use `-dx11`, not `-dx12`.

If you want to automate the Linux setup from this repo, run:

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine.ini --gpu nvidia
```

Use `./setup-linux.sh --help` to see optional flags such as `--steam-install`, `--custom-steam-root`, `--luma-only`, or `--dry-run`.

> [!NOTE]
> Run `./setup-linux.sh` as your normal user, not with `sudo`. The script will call `sudo` by itself only if it needs to install Ubuntu packages such as `protontricks`, `gamemode`, or `mangohud`.

> [!NOTE]
> If `protontricks` is not already installed on Ubuntu, the script will try to install it automatically unless you pass `--skip-packages`. If you use `--skip-packages`, or you are on a distro without `apt`, then `protontricks` must already be installed before the script can run the prefix setup step.


### 1. Installation 
1. Navigate to your game installation folder. Common Steam install roots on Linux are:
  - `~/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64` **(.deb package, downloaded from offical Steam site)**
  - `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64` **(Flatpak Steam)**
   
   *(This is where the DLL files go: `xinput1_3.dll` and `dxgi.dll`)*

2. Extract `xinput1_3.dll` from **FFVIIHook** into this `Win64` folder.
3. Extract the **Luma** mod into the same `Win64` folder so that `dxgi.dll` and the bundled Luma files sit next to the game executable.

### 2. Install Luma's Proton Dependencies
1. On Ubuntu, install `protontricks` first:
    ```bash
    sudo apt update && sudo apt install protontricks -y
    ```
2. If Ubuntu reports that the package cannot be found, enable the `universe` repository and retry:
    ```bash
    sudo add-apt-repository universe
    sudo apt update && sudo apt install protontricks -y
    ```
3. Install the required runtime components into FF7 Remake's Proton prefix:
    ```bash
    protontricks 1462040 msvcrt40 vcrun2022
    ```

### 2.1 Shader Compilation Stutter Fix - Setup Shader Cache For NVIDIA

This configuration prevents ***Shader Compilation Stutter*** (that quick freeze that occurs the first time a new spell is cast or an explosion happens, because the video card needs to "learn" how to draw that effect). The RTX 5070 already compiles this very quickly, and with the DXVK_ASYNC=1 parameter that we set in the Steam options, this problem practically no longer exists in your setup.

To set up NVIDIA shader cache on Ubuntu Linux by extending the cache size and preventing cleanup:

1. Create a dedicated cache directory (optional but recommended):
Open a terminal and run:

   ```sh
   mkdir -p ~/nvidia-shader-cache
   ```

2. Edit the environment file:
Open /etc/environment with root privileges:

   ```sh
   sudo nano /etc/environment
   ```

3. Add the environment variables:
Insert the following line to set the cache path and disable cleanup:

   ```sh
   # FIX: Shader Compilation Stutter
   __GL_SHADER_DISK_CACHE_PATH=/home/YOUR_USERNAME_HERE/nvidia-shader-cache
   __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
   __GL_SHADER_DISK_CACHE_SIZE=107374182400 # 100 GB
   ```

> [!NOTE]
> Replace `YOUR_USERNAME_HERE` with your actual username. 


1. Save and reboot:

   Save the file (Ctrl+O, then Enter in nano), exit (Ctrl+X), and reboot your system for changes to take effect. 

***This configuration prevents the driver from clearing the shader cache when it exceeds 128 MB, allowing it to grow indefinitely and reducing stuttering caused by repeated shader compilation.***

### 2.2 Configuring Vulkan Rendeting Queue

Since I've lightened the Unreal Engine with `Engine.ini` and fixed the startup options, the last step to mitigate this problem on Linux is to configure the Vulkan rendering queue behavior so that the CPU doesn't "overwhelm" the GPU during the loading of new areas.

1. Go to the game's root folder. The path is usually: `.../steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64/` (this is the exact folder where the executable `ff7remake_.exe` is located).

2. Create an empty text file called `dxvk.conf`.

3. Paste the following lines inside it:

   ```ini
   # Forces asynchronous compilation (ensures that the Steam command is respected)
   dxvk.enableAsync = true

   # Reduces the queue of pre-rendered frames to 1.
   # This decreases input latency and avoids absurd frametime spikes when the engine stutters on I/O.
   dxgi.maxFrameLatency = 1

   # Allows DXVK to relax certain D3D11 synchronization barriers,

   # which improves fluidity in games with fast asset transitions.
   d3d11.relaxedBarriers = true

   ```

Save the file. When you open the game through Steam, DXVK will silently read this file and apply the rules on top of the translation layer.

With `Engine.ini` file, the framerate locked by the DXVK we did earlier, and the render queue reduced to `1`, the game should achieve the maximum possible fluidity.


### 3. Apply Performance Configuration

For better CPU thread utilization and visual settings apply Engine.ini configuration. Luma works without them, but they significantly improve stuttering and frame consistency.

**Important:** Engine.ini goes in a **different location** than the DLL mods. While the DLLs go in `/End/Binaries/Win64/`, the Engine.ini config goes in the Proton prefix directory.

To apply a config file:

1. If the `compatdata/1462040` folder does not exist yet, launch the game once through Steam to create the Proton prefix.

2. Navigate to the game's Proton prefix config folder (separate from Win64). Use the appropriate path for your Steam installation:
   
   **For .deb package Steam:**
   ```bash
   CONFIG_DIR="$HOME/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor"
   mkdir -p "$CONFIG_DIR"
   ```
   
   **For Flatpak Steam:**
   ```bash
   CONFIG_DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor"
   mkdir -p "$CONFIG_DIR"
   ```

3. Copy Engine.ini file from this repo to that folder:
   ```bash
   cp ./Engine.ini "$CONFIG_DIR/Engine.ini"
   ```

> [!NOTE]
> `1462040` is Final Fantasy VII Remake's Steam app ID 

### 4. Proper NVIDIA Driver Installation (Modern RTX Series)
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

### 5. Steam Launch Options

Navigate to games's properties and set this command line in `General --> Launch Options`

```bash
DXVK_ASYNC=1 __GL_SYNC_TO_VBLANK=0 __GL_SYNC_DISPLAY_DEVICE=auto MANGOHUD_CONFIG=fps_limit=60,full,cpu_stats,gpu_stats,ram,vram mangohud %command% -d3d11
```

**Forcing Performance Profile (Feral GameMode)**

Ubuntu has a native tool from Feral Interactive that changes the CPU governor to maximum performance and temporarily prioritizes I/O for the game.

Change your Steam launcher line to include **gamemoderun** right before %command%:

```bash
# If GameMode is not installed, you can quickly install it in the terminal with sudo apt install gamemode

DXVK_ASYNC=1 DXVK_FRAME_RATE=60 __GL_SYNC_TO_VBLANK=0 __GL_SYNC_DISPLAY_DEVICE=auto MANGOHUD_CONFIG=full,cpu_stats,gpu_stats,ram,vram,frametime gamemoderun mangohud %command% -d3d11
```

> [!NOTE]
> It was noted that this command reduced stuttering issue, but issue still persist but with less and less agressive frame drops. To be very frank, I've already optimized the engine (internal I/O) and the graphics API (DXVK/Vulkan) to the limit and the frame drop persists, I've hit the ceiling of what the Square Enix port allows in terms of software. 


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

## 🎮 Native DualSense (PS5) Support

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