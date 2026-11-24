# Compatibility & Technical Status

> **Discord Server:** [https://discord.gg/6r4ngXfsab](https://discord.gg/6r4ngXfsab)

This document tracks the current execution state, verified engine milestones, and known roadblocks for running the Scarlett build of GTA VI on PC hardware.

---

## 🎯 Verified Milestones

### 1. Engine Boot & D3D12 Initialization — ✅ Passed
- **Details:** Direct3D 12 device initialized under Feature Level 12_1+.
- **Root Signature:** Shader Model 6.6 bindings mapped cleanly.
- **Fixes Applied:** RTV format unification (`B5G5R5A1_UNORM` translated via `R16_TYPELESS` / `R16_UINT` to prevent `0x887A0001` device removed errors).

### 2. Video Playback & Audio Pipeline — ✅ Passed
- **Details:** Bink2 Scarlett (`Bink2Scarlett.dll`) native video decoding.
- **Visuals:** Rockstar Games animated mural and intro sequence render at 60 FPS without tearing.
- **Audio:** Spatial audio channels active, XAudio/XCurl streaming cleanly.

### 3. Frontend & Account UI — ✅ Passed
- **Details:** User profile and initial settings screens present properly.
- **Input:** Controller / gamepad and keyboard inputs accepted.

### 4. World Loading & Package Streaming — ✅ Passed
- **Details:** High-throughput streaming from RPF/package structures into host buffers.
- **Visuals:** Lucia & Jason loading artwork transitions cleanly (reaching ~frame 2900).
- **Memory Fix:** Migrated shadow staging buffers from restricted `D3D12_MEMORY_POOL_L0` into GPU `DEFAULT` VRAM to fix `0x8007000E` Out Of Memory crash.

### 5. First Cutscene & Title Card — ✅ Passed
- **Details:** The introductory mission cutscene initializes.
- **Title Card:** The *"Vice City, 2 years ago"* title card renders on screen.
- **Audio & Scripts:** Full character dialogue, background ambiance, vehicle engines, and radio audio play live. Game tick loop runs at a steady 30 FPS.

---

## 🔬 In-Progress Areas & Roadblocks

### 1. In-Engine 3D Rendering (Dark Screen Post-Title Card)
- **Symptom:** After the title card, audio and game simulation continue at 30 FPS, but the 3D scene renders black/dark.
- **Root Cause:**
  - Modern RDNA2 shaders in the engine make heavy use of 64-bit typed image atomics (`imageAtomicAdd`, etc.) which require Shader Model 6.6 extension mapping on host DirectX 12.
  - Raytracing acceleration structures (BVH) built via Xbox-specific BVH routines (`XboxBvhBuilder.dll`) require translation to standard D3D12 DXR 1.1 Top-Level and Bottom-Level acceleration structures (TLAS/BLAS).
- **Solution in Development:** PR #705 (SM 6.6 64-bit atomics) & PR #702 (native DXR 1.1 translation).

### 2. Driver TDR / Device Removed (`0x887A0005` / `0x887A0006`)
- **Symptom:** GPU driver timeout during heavy compute dispatch loops.
- **Mitigation:**
  - `VICTORY_SHADER_LOOP_LIMIT=4096` prevents unbounded loop spin.
  - Indirect mesh draw bounds clamped to prevent dispatching unallocated primitive groups.

---

## 📊 Summary Matrix

| Feature | Status | Notes |
| :--- | :---: | :--- |
| Core Executable Launch | 🟢 Working | Native PE/Scarlett loader |
| D3D12 Device Creation | 🟢 Working | Feature Level 12_1+, SM 6.6 |
| Bink2 Intro Video | 🟢 Working | Full 60 FPS playback |
| Sound / Dialogue / Music | 🟢 Working | Full multi-channel streaming |
| Loading Screens & Art | 🟢 Working | Jason & Lucia artwork displayed |
| Game Simulation Loop | 🟢 Working | 30 FPS tickrate maintained |
| First Mission Title Card | 🟢 Working | "Vice City, 2 years ago" shown |
| 3D Scene Geometry | 🟡 In Progress | Shaders undergoing translation |
| Global Illumination / Raytracing | 🟡 In Progress | DXR 1.1 / SM 6.6 atomics mapping |

---

For technical discussion or to submit shader dumps and traces, visit:  
👉 **[Luacias Discord Community](https://discord.gg/6r4ngXfsab)**
