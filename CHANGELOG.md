# Changelog

All notable changes to the **Luacias** compatibility research layer will be documented in this file.

The project adheres to Semantic Versioning and [Keep a Changelog](https://keepachangelog.com/).

---

## [v0.2.0-preview] - 2026-11-24

### 🚀 Major Highlights
- **64-bit Buffer Atomics:** Full implementation of 64-bit buffer atomic operations and sub-opcodes in shader lowering (`lower.rs`), unlocking advanced compute passes used for lighting and scene hierarchy.
- **Lane-Mask Phi Tracking:** Fixed the common translation error `lane mask holding lanes elsewhere read as data is not supported` by tracking all incoming phi edges in `structure.rs` and lowering them with boolean masks.
- **Console Root Argument Spill Tables:** Resolved `SGPR that is no root parameter` failures on world shaders (dropping failures from 34 to 4) by properly decoding spilled user SGPR tables in memory.
- **World Loading Memory Optimization:** Drastically reduced committed host RAM during world streaming via LRU staging eviction, clamped shadow snapshot pools (512 MB limit), and immediate release of redundant executable images.

### 🎮 Shaders & Translation Pipeline
- **Added:** Support for byte and halfword LDS (Local Data Share) reads and writes (`lds_tests.rs`).
- **Added:** Cube and MSAA dimension support in `descriptor_data`, lowering MSAA `image_load` and `image_get_resinfo`.
- **Added:** Partial-channel `image_store` and typed buffer store lowering with packed D16 buffer loads.
- **Fixed:** Correctly marked `SV_Position` usage in mesh shaders (`ms_counts_begin`).
- **Fixed:** Traced scalar addresses kept across phis and offset by root constants (`s_addk_i32`, `s_sub_u32`).
- **Fixed:** Zeroed unavailable mixed-precision FMA halves and added support for f16 omod and saturate modifiers in `v_cvt_{u16,i16}_f16`.
- **Fixed:** Spill-table loads now accurately preserve argument values as set on entry.

### ⚡ GPU & Memory Subsystems
- **Added:** GPU-driven indirect rectangle-list draw expansion (`rectangles.rs`) with optimal scratch layout calculation.
- **Changed:** Texture staging upload heaps now operate under a configurable budget (`VICTORY_STAGING_BUDGET_MB`, 1 GiB default) with automatic LRU release.
- **Changed:** Watched textures now stream into a single per-thread buffer instead of retaining full lifetime copies.
- **Changed:** DirectStorage decompression buffers (zlib intermediate & physical pages) now count toward the active staging budget.

---

## [v0.1.0-preview] - 2026-11-24

### 🌟 Initial Release
- Direct3D 12 Feature Level 12_1+ and Shader Model 6.6 initialization.
- Bink2 Scarlett 60 FPS video playback with synchronized multi-channel audio.
- Initial settings and user profile selection frontend.
- Asset streaming and world loading screen rendering (Jason & Lucia art).
- First mission title card *"Vice City, 2 years ago"* triggered with active dialogue and 30 FPS tickrate.
- GPU DEFAULT VRAM migration fixing `0x8007000E` (E_OUTOFMEMORY).
- Wave64 to Wave32 emulation for NVIDIA RTX graphics cards.
- Loop limit safety (`VICTORY_SHADER_LOOP_LIMIT=4096`) against driver TDR timeouts.
