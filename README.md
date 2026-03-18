# FF7 Remake: The Ultimate Performance & Stuttering Fix (Windows & Linux)

This repository provides a comprehensive guide to fixing the notorious Unreal Engine 4 stuttering issues in *Final Fantasy VII Remake Intergrade* on PC, while offering options for modern upscaling technologies (DLSS/FSR) and raw stability.

This guide covers the installation of essential mods and crucial OS-level configurations:
1. **[FFVIIHook](https://www.nexusmods.com/finalfantasy7remake/mods/74):** Unlocks the developer console and allows custom `Engine.ini` configurations.
2. **[SPF (Stuttering Prevention Fix)](https://www.nexusmods.com/finalfantasy7remake/mods/1628):** Re-architects CPU thread allocation to prevent shader compilation stutters.
3. **[Luma - DLSS/FSR Upscaling Mod](https://www.nexusmods.com/finalfantasy7remake/mods/1974):** A DX11-only mod that replaces the game's TAA with NVIDIA DLSS / AMD FSR and can be used on both Windows and Linux.

- [FF7 Remake: The Ultimate Performance \& Stuttering Fix (Windows \& Linux)](#ff7-remake-the-ultimate-performance--stuttering-fix-windows--linux)
  - [⚙️ Engine.ini Configuration Files](#️-engineini-configuration-files)
  - [🪟 Windows Installation](#-windows-installation)
    - [Automated Installation (Recommended)](#automated-installation-recommended)
    - [Manual Installation (Alternative)](#manual-installation-alternative)
      - [1. Install the Mods](#1-install-the-mods)
      - [2. (Optional) Apply the Engine Config](#2-optional-apply-the-engine-config)
      - [3. Manual Steam Launch Options](#3-manual-steam-launch-options)
  - [🐧 Linux (Ubuntu / Pop!\_OS / Steam Deck) Configuration](#-linux-ubuntu--pop_os--steam-deck-configuration)
    - [Automated Install Examples](#automated-install-examples)
    - [1. Install the Essential Mods](#1-install-the-essential-mods)
    - [2. Install Luma's Proton Dependencies](#2-install-lumas-proton-dependencies)
    - [3. (Optional) Apply Performance Configuration](#3-optional-apply-performance-configuration)
    - [4. Proper NVIDIA Driver Installation (Modern RTX Series)](#4-proper-nvidia-driver-installation-modern-rtx-series)
    - [5. Steam Launch Options (The Crucial Step)](#5-steam-launch-options-the-crucial-step)
  - [📊 Linux: Monitoring Performance with MangoHud](#-linux-monitoring-performance-with-mangohud)
    - [1. Installation](#1-installation)
    - [2. In-Game Usage](#2-in-game-usage)
  - [🎮 Native DualSense (PS5) Support](#-native-dualsense-ps5-support)
    - [🖥️ Tested Environment](#️-tested-environment)

---

## ⚙️ Engine.ini Configuration Files

This repository includes three pre-optimized `Engine.ini` configurations:

- **[Engine.ini](Engine.ini)** — Standard balanced configuration with multithreading optimization, forced native resolution, and motion blur/DOF disabled. Combines SPF tweaks with Unreal Engine 4 performance optimizations.

- **[Engine-full-res.ini](Engine-full-res.ini)** — Ultra-graphics variant for high-end GPUs (8GB+ VRAM). Includes 4K shadow resolution, maximum draw distance to eliminate pop-in, and cinematic anti-aliasing.

- **[Engine-full-res-dlss.ini](Engine-full-res-dlss.ini)** — Ultra-graphics + DLSS/FSR optimized variant. Tunes dynamic resolution scaling (50-80%), temporal AA samples (16), and DLAA forcing for maximum Luma upscaler quality.

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

### Automated Installation (Recommended)

If you have this repository cloned, use the provided PowerShell script to automate mods, config deployment, and setup:

```powershell
.\setup-windows.ps1 --GamePath "C:\Program Files (x86)\Steam\steamapps\common\FINAL FANTASY VII REMAKE" --EngineLni .\Engine.ini
```

**Key Parameters:**

- `--GamePath` — Path to FF7 Remake installation (auto-detects if omitted)
- `--EngineLni` — Path to Engine.ini file (default: `.\Engine.ini`)
- `--LumaOnly` — Install only Luma, skip FFVIIHook and config
- `--SkipHook` — Skip FFVIIHook (xinput1_3.dll) installation
- `--SkipLuma` — Skip Luma mod installation
- `--SkipConfig` — Skip Engine.ini deployment
- `--DryRun` — Preview all planned installations without making changes
- `--Help` — Display full help documentation

**Common Examples:**

```powershell
# Auto-detect game path, use standard Engine.ini
.\setup-windows.ps1

# Ultra-graphics config (8GB+ VRAM)
.\setup-windows.ps1 --EngineLni .\Engine-full-res.ini

# Ultra-graphics + DLSS/FSR optimization
.\setup-windows.ps1 --EngineLni .\Engine-full-res-dlss.ini

# Custom game installation path
.\setup-windows.ps1 --GamePath "D:\Games\FINAL FANTASY VII REMAKE"

# Preview changes without installation
.\setup-windows.ps1 --DryRun

# Install only Luma mod
.\setup-windows.ps1 --LumaOnly
```

> [!IMPORTANT]
> The script must run with **user privileges** (not as Administrator). If you installed Steam in a restricted location that requires admin access, you will need to run the installation steps manually or provide appropriate permissions.

> [!NOTE]
> After the script completes, you **must manually set the Steam launch option** (see "Manual Steam Launch Options" below). The script will display instructions on how to do this.

---

### Manual Installation (Alternative)

If you prefer to install manually or the script doesn't work for your setup:

#### 1. Install the Mods
1. Navigate to your game installation folder: `[Steam Library]\steamapps\common\FINAL FANTASY VII REMAKE\End\Binaries\Win64`
2. Extract the `xinput1_3.dll` from the **FFVIIHook** folder into this folder.
3. Extract the contents of the **Luma** mod (from the `.zip` file) into the same `Win64` folder. The important files are `dxgi.dll` and the accompanying Luma configuration files.

#### 2. (Optional) Apply the Engine Config
1. Go to your Documents folder:
   `%USERPROFILE%\Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor\`
2. Open `Engine.ini` (create it if it doesn't exist) and copy the contents from one of the config files in this repo ([Engine.ini](Engine.ini), [Engine-full-res.ini](Engine-full-res.ini), or [Engine-full-res-dlss.ini](Engine-full-res-dlss.ini)). Save and close.
   *(This is optional; Luma works without it, but Engine.ini significantly improves stuttering and frame consistency.)*

#### 3. Manual Steam Launch Options
1. Right-click the game in your Steam Library > **Properties** > **General**.
2. Under **Launch Options**, type:
   ```
   -dx11
   ```
   *(Luma for FF7 Remake is currently a DX11-only mod. Do not use `-dx12` for this mod.)*

Once you launch the game, wait for the main menu to load. Press the **`Home`** or **`Insert`** key to open the Luma overlay, where you can select your preferred upscaler and image settings.

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

### Automated Install Examples

Use the script below if you want it to install the repo's bundled FFVIIHook + Luma files, copy your chosen config as `Engine.ini`, install Proton dependencies, and print the final Steam launch options for you.

**Default install using this repo's standard `Engine.ini`:**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine.ini --gpu nvidia
```

**Full install using the higher-quality config file instead:**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine-full-res.ini --gpu nvidia
```

**Full install with DLSS/FSR optimization (Luma-tuned settings):**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine-full-res-dlss.ini --gpu nvidia
```

**Full install for Flatpak Steam:**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install flatpak --engine-ini ./Engine.ini --gpu nvidia
```

**Full install for a custom Steam directory:**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install custom --custom-steam-root "/path/to/Steam" --engine-ini ./Engine.ini --gpu nvidia
```

**Preview everything first without changing files:**

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine.ini --gpu nvidia --dry-run
```

Parameter summary:

* `--engine-ini ./Engine.ini` or `--engine-ini ./Engine-full-res.ini` or `--engine-ini ./Engine-full-res-dlss.ini`: Selects the source config file. The destination is always written as `Engine.ini` inside the Proton prefix.
* `--steam-install deb`: Use this when Steam was installed from the `.deb` package.
* `--steam-install flatpak`: Use this when Steam was installed from the app center / Flatpak.
* `--steam-install custom --custom-steam-root "/path/to/Steam"`: Use this when your Steam installation lives in a non-standard directory. The path must contain `steamapps`.
* `--gpu nvidia`: Forces NVIDIA PRIME launch variables into the generated Steam launch options.
* `--dry-run`: Shows exactly what the script would do without modifying anything.

If you only want Luma without FFVIIHook/SPF, use:

```bash
chmod +x ./setup-linux.sh
./setup-linux.sh --steam-install deb --engine-ini ./Engine.ini --luma-only --gpu nvidia
```

### 1. Install the Essential Mods
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

### 3. (Optional) Apply Performance Configuration

The Engine.ini configurations included in this repo ([Engine.ini](Engine.ini), [Engine-full-res.ini](Engine-full-res.ini), and [Engine-full-res-dlss.ini](Engine-full-res-dlss.ini)) are **optional enhancements** for better CPU thread utilization and visual settings. Luma works without them, but they significantly improve stuttering and frame consistency.

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

3. Copy your chosen Engine.ini file from this repo to that folder:
   ```bash
   cp ./Engine.ini "$CONFIG_DIR/Engine.ini"
   # or for DLSS-optimized:
   cp ./Engine-full-res-dlss.ini "$CONFIG_DIR/Engine.ini"
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

### 5. Steam Launch Options (The Crucial Step)

The minimum required launch option for **Luma alone** is:

```bash
WINEDLLOVERRIDES="dxgi=n,b" %command% -dx11
```

If you also installed **FFVIIHook**, add its DLL override:

```bash
WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b" %command% -dx11
```

**Optional enhancements** (NVIDIA GPU + performance utilities):

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b" gamemoderun mangohud %command% -dx11
```

**Stable 60fps for my current laptop with GTX 5070**
```bash
MANGOHUD_CONFIG=fps_limit=0 vblank_mode=0 __GL_SYNC_TO_VBLANK=0 DXVK_FRAME_RATE=0 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b" mangohud %command% -dx11
```

**What each part does:**
* `WINEDLLOVERRIDES="dxgi=n,b"` — Loads Luma's dxgi.dll
* `WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b"` — Loads both FFVIIHook and Luma
* `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia` — Forces dedicated NVIDIA GPU (remove if using AMD/Intel)
* `gamemoderun` — Enables Feral GameMode for performance priority
* `mangohud` — Displays performance overlay (remove if you don't want it)
* `-dx11` — Forces DirectX 11 (required for Luma)

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