#!/usr/bin/env bash

set -euo pipefail

APP_ID="1462040"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_ENGINE_INI_SOURCE="$REPO_DIR/Engine.ini"
ENGINE_INI_SOURCE="$DEFAULT_ENGINE_INI_SOURCE"
HOOK_DLL_SOURCE="$REPO_DIR/FFVIIHook/xinput1_3.dll"
LUMA_ZIP_SOURCE="$REPO_DIR/Luma-Final_Fantasy_VII_Remake-1974-2-6-1770058756.zip"

STEAM_INSTALL="auto"
STEAM_ROOT=""
CUSTOM_STEAM_ROOT=""
INSTALL_PACKAGES=1
INSTALL_PROTON_DEPS=1
INSTALL_HOOK=1
INSTALL_LUMA=1
USE_MANGOHUD=1
GPU_MODE="auto"
DRY_RUN=0

log() {
    printf '[setup-linux] %s\n' "$*"
}

fail() {
    printf '[setup-linux] Error: %s\n' "$*" >&2
    exit 1
}

ensure_not_root() {
    if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
        fail "Do not run this script with sudo. Run it as your normal user; the script will call sudo itself only when installing Ubuntu packages."
    fi
}

usage() {
    cat <<'EOF'
Usage: ./setup-linux.sh [options]

Automates the Linux steps from this repo's README:
- selects the Steam layout or auto-detects it
- installs protontricks, gamemode, and mangohud on Ubuntu when missing
- installs Proton runtime dependencies for FF7 Remake
- copies the selected .ini file into the game's Proton prefix as Engine.ini
- installs FFVIIHook's xinput1_3.dll
- extracts the bundled Luma archive into the game's Win64 folder
- prints the Steam launch options to paste into Steam

Options:
  --engine-ini PATH      Use a custom source .ini file. Destination stays Engine.ini.
    --steam-install TYPE   Choose Steam layout: auto, deb, flatpak, or custom.
    --custom-steam-root    Steam root for --steam-install custom. Must contain steamapps.
  --luma-only            Skip FFVIIHook installation and use Luma-only launch options.
  --skip-packages        Do not install Ubuntu packages.
  --skip-protontricks    Do not run protontricks.
  --skip-luma            Do not extract the bundled Luma archive.
  --skip-mangohud        Do not include mangohud in the suggested launch options.
  --gpu MODE             Launch option GPU mode: auto, nvidia, or generic.
  --dry-run              Print actions without making changes.
  --help                 Show this help text.
EOF
}

run_cmd() {
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "DRY RUN: $*"
        return 0
    fi

    log "Running: $*"
    "$@"
}

detect_steam_root() {
    local candidates=(
        "$HOME/.local/share/Steam"
        "$HOME/.steam/debian-installation"
        "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
    )
    local candidate

    for candidate in "${candidates[@]}"; do
        if [[ -d "$candidate/steamapps" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

resolve_steam_root() {
    case "$STEAM_INSTALL" in
        auto)
            detect_steam_root || return 1
            ;;
        deb)
            if [[ -d "$HOME/.local/share/Steam/steamapps" ]]; then
                printf '%s\n' "$HOME/.local/share/Steam"
                return 0
            fi

            if [[ -d "$HOME/.steam/debian-installation/steamapps" ]]; then
                printf '%s\n' "$HOME/.steam/debian-installation"
                return 0
            fi

            return 1
            ;;
        flatpak)
            if [[ -d "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps" ]]; then
                printf '%s\n' "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
                return 0
            fi

            return 1
            ;;
        custom)
            [[ -n "$CUSTOM_STEAM_ROOT" ]] || fail "--custom-steam-root is required when --steam-install custom is used"
            printf '%s\n' "$CUSTOM_STEAM_ROOT"
            ;;
        *)
            return 1
            ;;
    esac
}

ensure_command() {
    local command_name="$1"
    command -v "$command_name" >/dev/null 2>&1 || fail "Required command not found: $command_name"
}

install_ubuntu_packages() {
    local packages=()

    command -v apt >/dev/null 2>&1 || {
        log "Skipping package installation because apt is not available."
        return 0
    }

    command -v protontricks >/dev/null 2>&1 || packages+=(protontricks)
    command -v gamemoderun >/dev/null 2>&1 || packages+=(gamemode)
    if [[ "$USE_MANGOHUD" -eq 1 ]]; then
        command -v mangohud >/dev/null 2>&1 || packages+=(mangohud)
    fi

    if [[ "${#packages[@]}" -eq 0 ]]; then
        log "All requested Ubuntu packages are already installed."
        return 0
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "DRY RUN: sudo apt update"
        log "DRY RUN: sudo add-apt-repository -y universe"
        log "DRY RUN: sudo apt install -y ${packages[*]}"
        return 0
    fi

    log "Installing Ubuntu packages: ${packages[*]}"
    sudo apt update

    if printf '%s\n' "${packages[@]}" | grep -qx 'protontricks'; then
        if ! apt-cache show protontricks >/dev/null 2>&1; then
            log "Enabling the universe repository because protontricks is not currently available."
            sudo add-apt-repository -y universe
            sudo apt update
        fi
    fi

    sudo apt install -y "${packages[@]}"
}

build_launch_options() {
    local dll_override
    local launch_options
    local resolved_gpu_mode="$GPU_MODE"

    if [[ "$INSTALL_HOOK" -eq 1 ]]; then
        dll_override='WINEDLLOVERRIDES="xinput1_3=n,b;dxgi=n,b"'
    else
        dll_override='WINEDLLOVERRIDES="dxgi=n,b"'
    fi

    if [[ "$resolved_gpu_mode" == "auto" ]]; then
        if command -v nvidia-smi >/dev/null 2>&1; then
            resolved_gpu_mode="nvidia"
        else
            resolved_gpu_mode="generic"
        fi
    fi

    launch_options="$dll_override"

    if [[ "$resolved_gpu_mode" == "nvidia" ]]; then
        launch_options="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia $launch_options"
    fi

    if command -v gamemoderun >/dev/null 2>&1; then
        launch_options="$launch_options gamemoderun"
    fi

    if [[ "$USE_MANGOHUD" -eq 1 ]] && command -v mangohud >/dev/null 2>&1; then
        launch_options="$launch_options mangohud"
    fi

    launch_options="$launch_options %command% -dx11"
    printf '%s\n' "$launch_options"
}

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --engine-ini)
            [[ "$#" -ge 2 ]] || fail "--engine-ini requires a path"
            ENGINE_INI_SOURCE="$2"
            shift 2
            ;;
        --steam-install)
            [[ "$#" -ge 2 ]] || fail "--steam-install requires a value"
            STEAM_INSTALL="$2"
            shift 2
            ;;
        --custom-steam-root)
            [[ "$#" -ge 2 ]] || fail "--custom-steam-root requires a path"
            CUSTOM_STEAM_ROOT="$2"
            shift 2
            ;;
        --luma-only)
            INSTALL_HOOK=0
            shift
            ;;
        --skip-packages)
            INSTALL_PACKAGES=0
            shift
            ;;
        --skip-protontricks)
            INSTALL_PROTON_DEPS=0
            shift
            ;;
        --skip-luma)
            INSTALL_LUMA=0
            shift
            ;;
        --skip-mangohud)
            USE_MANGOHUD=0
            shift
            ;;
        --gpu)
            [[ "$#" -ge 2 ]] || fail "--gpu requires a value"
            GPU_MODE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            fail "Unknown argument: $1"
            ;;
    esac
done

case "$GPU_MODE" in
    auto|nvidia|generic)
        ;;
    *)
        fail "--gpu must be one of: auto, nvidia, generic"
        ;;
esac

case "$STEAM_INSTALL" in
    auto|deb|flatpak|custom)
        ;;
    *)
        fail "--steam-install must be one of: auto, deb, flatpak, custom"
        ;;
esac

    ensure_not_root

[[ -f "$ENGINE_INI_SOURCE" ]] || fail "Engine.ini not found at $ENGINE_INI_SOURCE"

if [[ "$INSTALL_HOOK" -eq 1 ]]; then
    [[ -f "$HOOK_DLL_SOURCE" ]] || fail "FFVIIHook DLL not found at $HOOK_DLL_SOURCE"
fi

if [[ "$INSTALL_LUMA" -eq 1 ]]; then
    [[ -f "$LUMA_ZIP_SOURCE" ]] || fail "Luma zip not found at $LUMA_ZIP_SOURCE"
    ensure_command unzip
fi

STEAM_ROOT="$(resolve_steam_root || true)"

[[ -n "$STEAM_ROOT" ]] || fail "Could not resolve a Steam root for --steam-install $STEAM_INSTALL"

LIBRARY_ROOT="$STEAM_ROOT/steamapps"

[[ -d "$LIBRARY_ROOT" ]] || fail "Steam library root not found: $LIBRARY_ROOT"

GAME_WIN64_DIR="$LIBRARY_ROOT/common/FINAL FANTASY VII REMAKE/End/Binaries/Win64"
COMPATDATA_ROOT="$LIBRARY_ROOT/compatdata/$APP_ID"
CONFIG_DIR="$COMPATDATA_ROOT/pfx/drive_c/users/steamuser/Documents/My Games/FINAL FANTASY VII REMAKE/Saved/Config/WindowsNoEditor"

[[ -d "$GAME_WIN64_DIR" ]] || fail "Game Win64 directory not found: $GAME_WIN64_DIR"

if [[ ! -d "$COMPATDATA_ROOT" ]]; then
    fail "Compatdata directory not found: $COMPATDATA_ROOT. Launch the game once through Steam first."
fi

if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
    install_ubuntu_packages
fi

run_cmd mkdir -p "$CONFIG_DIR"
run_cmd cp "$ENGINE_INI_SOURCE" "$CONFIG_DIR/Engine.ini"

if [[ "$INSTALL_HOOK" -eq 1 ]]; then
    run_cmd cp "$HOOK_DLL_SOURCE" "$GAME_WIN64_DIR/xinput1_3.dll"
fi

if [[ "$INSTALL_LUMA" -eq 1 ]]; then
    run_cmd unzip -oq "$LUMA_ZIP_SOURCE" -d "$GAME_WIN64_DIR"
fi

if [[ "$INSTALL_PROTON_DEPS" -eq 1 ]]; then
    ensure_command protontricks

    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "DRY RUN: STEAM_DIR=$STEAM_ROOT protontricks $APP_ID msvcrt40 vcrun2022"
    else
        log "Installing Proton runtime components into app $APP_ID"
        STEAM_DIR="$STEAM_ROOT" protontricks "$APP_ID" msvcrt40 vcrun2022
    fi
fi

LAUNCH_OPTIONS="$(build_launch_options)"

log "Setup complete."
log "Game directory: $GAME_WIN64_DIR"
log "Config directory: $CONFIG_DIR"
printf '\nSteam launch options:\n%s\n' "$LAUNCH_OPTIONS"
