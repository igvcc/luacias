# Troubleshooting Guide

Common error codes, causes, and workarounds when executing the Scarlett build on PC.

---

### 1. `0x8007000E` — Out of Memory (`no shared buffer error`)
- **Cause:** Exhaustion of host-visible `D3D12_MEMORY_POOL_L0` allocation space due to large textures/buffers placed in `WRITE_BACK` memory instead of dedicated VRAM.
- **Fix:** Allocate shadow buffers in the `D3D12_HEAP_TYPE_DEFAULT` pool and utilize pooled staging buffers for copy operations.

---

### 2. `0x887A0005` / `0x887A0006` — `DXGI_ERROR_DEVICE_HUNG` / Device Removed
- **Cause:** GPU driver detects a compute or graphics dispatch that takes too long to complete (TDR - Timeout Detection and Recovery), causing a screen flicker or crash.
- **Fix:**
  - Set shader loop limit:
    ```cmd
    set VICTORY_SHADER_LOOP_LIMIT=4096
    ```
  - Lower the indirect draw budget:
    ```cmd
    set VICTORY_INDIRECT_BUDGET=1048576
    ```
  - Ensure GPU driver is up-to-date and hardware acceleration is enabled in Windows Graphics Settings.

---

### 3. `0x887A0001` — `DXGI_ERROR_INVALID_CALL` on Render Target View
- **Cause:** Format mismatch between Xbox texture formats (`B5G5R5A1_UNORM`) and host DirectX 12 hardware capabilities.
- **Fix:** Enable format aliasing through `R16_TYPELESS` / `R16_UINT` casting in the resource descriptor translation pipeline.

---

### 4. Audio Plays but Screen is Black Post-Title Card
- **Cause:** Raytracing / Global Illumination compute shaders using 64-bit typed atomics or unmapped DXR 1.1 BVH builder calls.
- **Fix:** Active development in progress. Check [STATUS.md](STATUS.md) and join [Discord](https://discord.gg/6r4ngXfsab) for patches.
