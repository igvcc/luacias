# Luacias 🌴

[![Discord Server](https://img.shields.io/badge/Discord-Join%20Community-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/6r4ngXfsab)
[![Latest Release](https://img.shields.io/badge/Release-v0.1.0--preview-brightgreen?style=for-the-badge&logo=github)](https://github.com/igvcc/luacias/releases)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11%20x64-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/igvcc/luacias)
[![DirectX](https://img.shields.io/badge/Graphics-DirectX%2012%20Ultimate%20(SM%206.6)-black?style=for-the-badge&logo=directx)](https://github.com/igvcc/luacias)
[![Status](https://img.shields.io/badge/Status-In%20Active%20Research-orange?style=for-the-badge)](https://discord.gg/6r4ngXfsab)

**Luacias** is an experimental compatibility research and translation project focused on executing and analyzing the Xbox Series X (*Scarlett*) build of **Grand Theft Auto VI** on PC hardware using modern DirectX 12 Ultimate, high-level kernel emulation, and advanced shader binary translation.

Join our community on Discord for live discussion, testing updates, and collaboration:  
👉 **[Join our Discord Community](https://discord.gg/6r4ngXfsab)**

---

## 🎮 Current Compatibility Status

The game engine initializes, streams assets, loads into memory, and executes game logic and cutscenes. Here is the verified progress status:

| Milestone / Subsystem | Status | Description & Technical Notes |
| :--- | :---: | :--- |
| **Boot & D3D12 Initialization** | 🟢 **Working** | Direct3D 12 device creation, root view bindings, command queue scheduling. |
| **Intro Video & Audio (Bink2)** | 🟢 **Working** | Leonida / Rockstar animated mural, 60 FPS Bink2 video and audio playback. |
| **Game Startup & Settings Menu** | 🟢 **Working** | User account selection, audio/visual settings, initial interface rendering. |
| **Asset Streaming & World Loading** | 🟢 **Working** | Data package streaming, Jason & Lucia artwork loading screens (~frame 2900). |
| **First Mission / Title Card** | 🟢 **Working** | *"Vice City, 2 years ago"* title card triggers cleanly. Mission scripts start. |
| **Sound & Streaming Dialogue** | 🟢 **Working** | Full environmental audio, cutscene dialogue, radio channels, and sound fx active. |
| **Game Logic & Simulation** | 🟢 **Working** | Game tick loop runs stably at targeted 30 FPS tickrate. |
| **3D World & Scene Rendering** | 🟡 **In Progress** | Engine executes; geometry/lighting passes undergoing shader translation (DXR 1.1 / SM 6.6 atomics). |

---

## 📋 System Requirements

To run and experiment with the translation layer, modern PC hardware is required:

### Minimum Requirements
- **OS:** Windows 10 (version 21H2+) or Windows 11 64-bit
- **CPU:** x86_64 processor with **AVX2** support (Intel 8th Gen+ / AMD Ryzen 2000+)
- **GPU:** DirectX 12 Ultimate compatible GPU with **Shader Model 6.6** and hardware Raytracing:
  - NVIDIA GeForce RTX 2060 (6GB) / RTX 3060 (12GB) or higher
  - AMD Radeon RX 6600 XT (8GB) or higher
- **RAM:** 16 GB DDR4/DDR5
- **Storage:** NVMe SSD recommended for streaming assets

### Recommended Requirements
- **CPU:** 8-core / 16-thread modern CPU (Intel Core i7-12700K+ / AMD Ryzen 7 7800X3D+)
- **GPU:** NVIDIA GeForce RTX 3070 / RTX 4070 (8GB–16GB VRAM) or AMD Radeon RX 7800 XT
- **RAM:** 32 GB RAM

---

## 🛠️ Architecture & Translation Pipeline

```
                                 [ Xbox Series X Scarlett Binary ]
                                                │
                                                ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                       LUACIAS PIPELINE                                      │
├───────────────────────────────┬─────────────────────────────┬───────────────────────────────┤
│         Host Kernel           │        Memory Pool          │       Shader Translator       │
│  - Threading & Fiber fibers   │  - D3D12_MEMORY_POOL_L0     │  - GFX10 RDNA2 to SM 6.6 DXIL │
│  - Scarlett OS syscalls       │  - Staging Pool in DEFAULT  │  - Wave64 -> Wave32 Emulation │
│  - XCurl / Net HLE stubs      │  - Shadow VRAM caching      │  - Dynamic Loop Protection    │
└───────────────────────────────┴─────────────────────────────┴───────────────────────────────┘
                                                │
                                                ▼
                                    [ DirectX 12 Host GPU ]
```

### Key Technical Achievements
- **GPU Memory Management:** Resolved `0x8007000E` (E_OUTOFMEMORY) errors by moving large shadow allocations into the fast GPU `DEFAULT` heap with pooled staging buffers rather than exhausting host-visible `L0 WRITE_BACK` memory.
- **Wave64 on Wave32 (NVIDIA):** Implemented emulation layer allowing GFX10 compute shaders compiled for 64-wide wavefronts to run natively on 32-wide hardware (e.g. GeForce RTX).
- **TDR & Loop Limiting:** Added dynamic shader loop limits and mesh shader clamping to prevent Windows GPU driver timeouts (`0x887A0006 DXGI_ERROR_DEVICE_HUNG`).
- **Structured Buffers & Lane Mask Spills:** Full support for unaligned descriptor addressing and structured buffers with variable runtime strides.

---

## 🚀 Running & Quick Start

### Option A: Pre-built Binary
1. Download the latest release package from the [Releases](https://github.com/igvcc/luacias/releases) page.
2. Extract the archive and copy `scripts/launch_gta6.cmd` alongside `victory.exe`.
3. Run `launch_gta6.cmd` and specify the path to `game_scarlett_master.exe`.

### Option B: Building from Source
Ensure you have the latest **Rust (1.80+)** and **Visual Studio 2022 C++ build tools**:
```cmd
git clone https://github.com/igvcc/luacias.git
cd luacias
cargo build --release
```
The compiled binary will be generated in `target\release\victory.exe`.

---

## ⚙️ Configuration & Environment

Recommended runtime flags for stability:
```cmd
:: Enable dynamic loop limits against driver TDR timeouts
set VICTORY_SHADER_LOOP_LIMIT=4096

:: Enable pipeline journal logging
set VICTORY_PIPELINE_JOURNAL=1

:: Direct execution without indirect draw drops (for tested hardware)
set VICTORY_NO_INDIRECT=0
```

---

## 🤝 Community & Support

Join the developers, testers, and researchers on our Discord server:

💬 **Discord:** [https://discord.gg/6r4ngXfsab](https://discord.gg/6r4ngXfsab)

Share your logs, report shader translation faults, and follow real-time development updates!

---

## ⚖️ Legal Disclaimer

This repository and research project is for educational, reverse-engineering, and compatibility research purposes only.  
No proprietary game binaries, copyrighted assets, encrypted archives, or keys are distributed in this repository. All trademarks and registered trademarks are the property of their respective owners.
