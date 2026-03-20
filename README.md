# FF7 Remake: Ultimate Performance and Stutter Reduction Guide (Windows and Linux)

This repository provides a practical setup guide for reducing traversal and shader-compilation stutter in *Final Fantasy VII Remake Intergrade* on PC.

It combines three key mods with OS-level and driver-level tuning:

1. **[FFVIIHook](https://www.nexusmods.com/finalfantasy7remake/mods/74)**
   Enables the UE4 developer console and allows custom `Engine.ini` values to load reliably.
2. **[SPF (Stuttering Prevention Fix)](https://www.nexusmods.com/finalfantasy7remake/mods/1628)**
   Reworks CPU-thread behavior to reduce common scheduling bottlenecks.
3. **[Luma (DLSS/FSR Upscaling Mod)](https://www.nexusmods.com/finalfantasy7remake/mods/1974)**
   DX11-only mod that replaces the game's default TAA with DLSS/FSR options.

### Why this stack works

- **FFVIIHook** ensures startup CVars are consistently read, which is required for deterministic behavior from custom `Engine.ini` optimizations.
- **SPF** targets CPU scheduling pressure points that commonly appear during traversal and shader-heavy transitions.
- **Luma on DX11** avoids this game's weaker DX12 behavior and replaces blurrier default anti-aliasing with upscalers that are both cleaner and usually more stable in motion.

## Contents

- [FF7 Remake: Ultimate Performance and Stutter Reduction Guide (Windows and Linux)](#ff7-remake-ultimate-performance-and-stutter-reduction-guide-windows-and-linux)
    - [Why this stack works](#why-this-stack-works)
  - [Contents](#contents)
  - [Engine.ini Config Files in This Repo](#engineini-config-files-in-this-repo)
    - [Why separate Engine.ini profiles](#why-separate-engineini-profiles)
  - [Important Paths (DLLs vs Engine.ini)](#important-paths-dlls-vs-engineini)
  - [Windows Setup](#windows-setup)
    - [1) Mod Stack](#1-mod-stack)
    - [2) Force DirectX 11](#2-force-directx-11)
    - [3) Apply Windows Engine.ini](#3-apply-windows-engineini)
    - [4) Improve Frame Pacing in NVIDIA Control Panel](#4-improve-frame-pacing-in-nvidia-control-panel)
  - [Linux Setup (Ubuntu / Pop!\_OS / Steam Deck)](#linux-setup-ubuntu--pop_os--steam-deck)
    - [1) Install Mods to Win64](#1-install-mods-to-win64)
    - [2) Install Proton Dependencies for Luma](#2-install-proton-dependencies-for-luma)
    - [3) Optional: NVIDIA Shader Cache Tuning](#3-optional-nvidia-shader-cache-tuning)
    - [4) Optional: DXVK Queue Tuning](#4-optional-dxvk-queue-tuning)
    - [5) Apply Engine.ini in Proton Prefix](#5-apply-engineini-in-proton-prefix)
    - [6) NVIDIA Driver Check (Modern RTX GPUs)](#6-nvidia-driver-check-modern-rtx-gpus)
    - [7) Steam Launch Options](#7-steam-launch-options)
  - [Linux Monitoring with MangoHud](#linux-monitoring-with-mangohud)
  - [Native DualSense (PS5) Prompts](#native-dualsense-ps5-prompts)
  - [Tested Environment](#tested-environment)

---

&nbsp;

## Engine.ini Config Files in This Repo

This repository includes multiple `Engine.ini` variants:

- **[Engine.ini](Engine.ini)**
  Linux/Proton-focused profile (includes async and shader pipeline tweaks).
- **[Engine_Windows.ini](Engine_Windows.ini)**
  Windows-focused profile designed for DX11 + Luma.
- **[FFVII - SLF/Engine.ini](FFVII%20-%20SLF/Engine.ini)**
  Alternative aggressive profile.
- **[FFVIIHook/Engine.ini](FFVIIHook/Engine.ini)**
  FFVIIHook sample template and notes.

Use the file that best matches your platform and stability target.

&nbsp;

### Why separate Engine.ini profiles

Windows and Linux/Proton do not behave identically at the driver and translation-layer level. A profile that is ideal on one platform can be neutral or even counterproductive on the other. Keeping separate variants reduces guesswork and makes troubleshooting easier.

&nbsp;

## Important Paths (DLLs vs Engine.ini)

**DLL files** and **Engine.ini** go to different locations.

| Item | Location |
|---|---|
| Mod DLLs (`xinput1_3.dll`, `dxgi.dll`) | `.../FINAL FANTASY VII REMAKE/End/Binaries/Win64/` |
| `Engine.ini` (Windows native) | `%USERPROFILE%\Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\Engine.ini` |
| `Engine.ini` (Linux Proton, .deb Steam) | `~/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/Engine.ini` |
| `Engine.ini` (Linux Proton, Flatpak Steam) | `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor/Engine.ini` |

---

&nbsp;

## Windows Setup

### 1) Mod Stack

Copy these into `End\Binaries\Win64`:

- **FFVIIHook**: Required for proper custom config loading and console access.
- **Luma (DLSS/FSR)**: Recommended for significantly better image quality than default TAA.
- **SPF**: Recommended on Windows for better CPU thread scheduling behavior.

### 2) Force DirectX 11

The Windows port often stutters more on DX12. Force DX11 in Steam:

- Steam -> Right-click *Final Fantasy VII Remake* -> **Properties**
- In **Launch Options**, add:

```bash
-d3d11
```

> [!NOTE]
> Luma for FF7 Remake is DX11-only.

> [!TIP]
> - In this specific port, DX12 frequently shows worse frametime consistency, especially during first-time effect use and area traversal.
> - DX11 has a more mature behavior profile here, and it is also the required path for Luma.

### 3) Apply Windows Engine.ini

In `Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\`, replace `Engine.ini` with the content from [Engine_Windows.ini](Engine_Windows.ini).


> [!NOTE]
> - The Windows profile prioritizes streaming stability, shader cache behavior, and image cleanup.
> - It deliberately disables quality settings that often create blur or latency overhead without meaningful visual benefit in motion.

### 4) Improve Frame Pacing in NVIDIA Control Panel

The in-game frame limiter can produce uneven frametimes. Driver-level limiting is usually smoother.

1. Open **NVIDIA Control Panel**.
2. Go to **Manage 3D Settings** -> **Program Settings**.
3. Select *FINAL FANTASY VII REMAKE* (or add the executable).
4. Set **Max Frame Rate** to your target (for example `60`).
5. Set **Power management mode** to **Prefer maximum performance**.
6. Click **Apply**.

Even with this setup, small transition stutters can still happen in some zones **due to engine/port limitations**.

> [!IMPORTANT]
> - FF7R's in-game limiter is known to produce unstable frametime spacing.
> - Driver-level caps usually produce more uniform frame delivery, which improves perceived smoothness even when average FPS is unchanged.

---

&nbsp;

## Linux Setup (Ubuntu / Pop!_OS / Steam Deck)

If you want the automated path first:

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine.ini --gpu nvidia
```

Show all options:

```bash
./setup-linux.sh --help
```

> [!NOTE]
> Run `./setup-linux.sh` as your normal user (not with `sudo`).

> [!IMPORTANT]
> Luma for FF7 Remake is **DX11-only**. Use `-d3d11`.


> [!NOTE]
> - On Linux, DX11 is translated by DXVK to Vulkan, which is generally better behaved for this title than forcing DX12 paths.
> - The goal is not maximum synthetic FPS, but stable frametime under shader and traversal pressure.

&nbsp;

### 1) Install Mods to Win64

Common Steam game roots on Linux:

- .deb Steam (Downloaded from official website): `~/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64`
- Flatpak Steam: `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64`

Then:

1. Extract FFVIIHook's `xinput1_3.dll` to `Win64`.
2. Extract Luma so `dxgi.dll` is also in `Win64`.

&nbsp;


### 2) Install Proton Dependencies for Luma

1. Install `protontricks` (Ubuntu/Debian-based):

```bash
sudo apt update && sudo apt install protontricks -y
```

2. If package lookup fails, enable `universe` and retry:

```bash
sudo add-apt-repository universe
sudo apt update && sudo apt install protontricks -y
```

3. Install required runtimes in FF7R prefix (`1462040`):

```bash
protontricks 1462040 msvcrt40 vcrun2022
```

> [!NOTE]
> - Luma depends on Windows runtime components that are not always available in a fresh prefix.
> - Installing them avoids silent load failures where `dxgi.dll` exists but does not initialize correctly.


&nbsp;


### 3) Optional: NVIDIA Shader Cache Tuning

This helps reduce repeated first-time shader hitches. This configuration prevents ***Shader Compilation Stutter*** (that quick freeze that occurs the first time a new spell is cast or an explosion happens, because the video card needs to "learn" how to draw that effect). The RTX 5070 already compiles this very quickly, and with the DXVK_ASYNC=1 parameter that we set in the Steam options, this problem practically no longer exists in your setup.

To set up NVIDIA shader cache on Ubuntu Linux by extending the cache size and preventing cleanup:

1. Create a cache directory:

```bash
mkdir -p ~/nvidia-shader-cache
```

2. Edit `/etc/environment`:

```bash
sudo nano /etc/environment
```

3. Add:

```bash
__GL_SHADER_DISK_CACHE_PATH=/home/YOUR_USERNAME_HERE/nvidia-shader-cache
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
__GL_SHADER_DISK_CACHE_SIZE=107374182400
```

> [!NOTE]
> Replace `YOUR_USERNAME_HERE` with your actual username.


4. Save and reboot.

&nbsp;

### 4) Optional: DXVK Queue Tuning

Configure the Vulkan rendering queue behavior so that the CPU doesn't "overwhelm" the GPU during the loading of new areas.

In the same folder as `ff7remake_.exe` (`.../steamapps/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64/`), create `dxvk.conf` with:

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

> [!NOTE] 
> When you open the game through Steam, DXVK will silently read this file and apply the rules on top of the translation layer. With this, the game should achieve the maximum possible fluidity.

&nbsp;

### 5) Apply Engine.ini in Proton Prefix

`Engine.ini` must be copied to the Proton prefix config directory (not `Win64`).

1. If `compatdata/1462040` does not exist, launch the game once from Steam.
2. Choose your Steam install type and create the config dir:

    ```bash
    # .deb Steam
    CONFIG_DIR="$HOME/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor"
    mkdir -p "$CONFIG_DIR"

    # Flatpak Steam
    CONFIG_DIR="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/1462040/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor"
    mkdir -p "$CONFIG_DIR"
    ```

3. Copy the repo config:

    ```bash
    cp ./Engine.ini "$CONFIG_DIR/Engine.ini"
    ```

> [!TIP]
> `1462040` is Final Fantasy VII Remake's Steam app ID

&nbsp;

### 6) NVIDIA Driver Check (Modern RTX GPUs)

Newer graphics cards (like the RTX 50-series) require the new Open GPU Kernel Modules. If your game is running at very low framerates (e.g., 15 FPS), your system might be failing to load the older proprietary drivers and defaulting to integrated graphics.

1. Clean old NVIDIA packages:

    ```bash
    sudo apt purge '^nvidia-.*' -y && sudo apt autoremove -y
    ```

2. Install an open-kernel NVIDIA driver example and Vulkan tools:

    ```bash
    sudo apt update && sudo apt install nvidia-driver-580-open mesa-utils vulkan-tools -y
    ```

3. Reboot - Mandatory for the Kernel to load the new module into memory.
4. Validate with:

    ```bash
    > nvidia-smi

    # Expected output:

    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 580.126.09             Driver Version: 580.126.09     CUDA Version: 13.0     |
    +-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  NVIDIA GeForce RTX 5070 ...    Off |   00000000:01:00.0 Off |                  N/A |
    | N/A   43C    P8              6W /   95W |     159MiB /   8151MiB |      0%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+

    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |    0   N/A  N/A            4132      G   /usr/bin/gnome-shell                      2MiB |
    |    0   N/A  N/A            5779      G   ...share/Steam/ubuntu12_32/steam          4MiB |
    |    0   N/A  N/A            5948      G   ./steamwebhelper                         90MiB |
    |    0   N/A  N/A            5985    C+G   ...am/ubuntu12_64/steamwebhelper          5MiB |
    +-----------------------------------------------------------------------------------------+
    ```

> [!TIP]
> If `No devices were found`, check Secure Boot in BIOS/UEFI.

&nbsp;

### 7) Steam Launch Options

Set in Steam: **`Game Properties -> General -> Launch Options`**

```bash
DXVK_ASYNC=1 __GL_SYNC_TO_VBLANK=0 __GL_SYNC_DISPLAY_DEVICE=auto MANGOHUD_CONFIG=fps_limit=60,full,cpu_stats,gpu_stats,ram,vram mangohud %command% -d3d11
```

**Forcing Performance Profile (Feral GameMode):**

Ubuntu has a native tool from Feral Interactive that changes the CPU governor to maximum performance and temporarily prioritizes I/O for the game.

Change your Steam launcher line to include gamemoderun right before %command%:

If GameMode is not installed, you can quickly install it in the terminal with:
```sh
sudo apt install gamemode
```

```bash
DXVK_ASYNC=1 DXVK_FRAME_RATE=60 __GL_SYNC_TO_VBLANK=0 __GL_SYNC_DISPLAY_DEVICE=auto MANGOHUD_CONFIG=full,cpu_stats,gpu_stats,ram,vram,frametime gamemoderun mangohud %command% -d3d11
```

If you choose you can disable MangoHUD by simply removing it from the command:
```bash
DXVK_ASYNC=1 DXVK_FRAME_RATE=60 __GL_SYNC_TO_VBLANK=0 __GL_SYNC_DISPLAY_DEVICE=auto gamemoderun mangohud %command% -d3d11
```

> [!NOTE]
> This usually reduces stutter intensity and improves recovery time, but some frame drops still happen because of game engine/port limits. It was noted that this command reduced stuttering issue, but issue still persist but with less agressive frame drops and it was able to recover faster. To be very frank, I've already optimized the engine (internal I/O) and the graphics API (DXVK/Vulkan) to the limit and the frame drop persists, **I've hit the ceiling of what the Square Enix port allows in terms of software.**

> [!TIP]
> - `DXVK_ASYNC=1` and frame limiting target shader/queue behavior and pacing consistency.
> - MangoHud provides immediate feedback so you can validate changes with frametime data instead of relying on subjective feel alone.

---

&nbsp;

## Linux Monitoring with MangoHud

Install:

```bash
sudo apt update && sudo apt install mangohud -y
```

Usage tips:

- Confirm the overlay reports your NVIDIA GPU (not integrated GPU).
- Watch the frametime graph for spikes during traversal.
- Toggle overlay with `Right Shift + F12`.

---

&nbsp;

## Native DualSense (PS5) Prompts

To show PlayStation button prompts instead of Xbox prompts:

1. Open game **Properties** in Steam.
2. In **Controller**, set override to **Disable Steam Input**.

---

&nbsp;


## Tested Environment

Validated on:

- **OS**: Ubuntu 25.10
- **GPU**: NVIDIA GeForce RTX 5070 Max-Q / Mobile (Open Kernel Driver: 580.126.09)
- **Graphics API**: DirectX 11 (through DXVK on Linux)
- **Controller**: PS5 DualSense (native input, Steam Input disabled)
