# Visual Demo Gallery

Interactive overview of the geometry, beam patterns, listening examples, and outlook visuals for this project.

> Media files live under [`figures/`](figures/).  
> Exact copy instructions: [`COPY_GUIDE.md`](COPY_GUIDE.md).  
> Paper ↔ script mapping: [`../PAPER_CODE_MAP.md`](../PAPER_CODE_MAP.md).

---

## Contents

1. [Experimental scenario](#1-experimental-scenario)
2. [Array geometry](#2-array-geometry)
3. [Single-microphone beam patterns](#3-single-microphone-beam-patterns)
4. [Ring responses after Delay-and-Sum](#4-ring-responses-after-delay-and-sum)
5. [Method comparison](#5-method-comparison)
6. [Listening examples](#6-listening-examples)
7. [Outlook](#7-outlook-potential-future-applications)

---

## 1. Experimental scenario

Room / source / spherical-array placement used in the simulated evaluation.

<p align="center">
  <img src="figures/01_scenario/scenario_room_array_source.png" alt="Experimental scenario" width="720">
</p>

<p align="center"><sub>Figure: noisy reverberant room with talker and 32-microphone open spherical array.</sub></p>

---

## 2. Array geometry

### 2.1 Physical array (R = 4.2 cm)

<p align="center">
  <img src="figures/02_array_geometry/physical_32mics_R4v2.gif" alt="32 physical microphones on the sphere" width="520">
</p>

<p align="center"><sub>32 physical microphones on an open sphere (R = 4.2 cm).</sub></p>

### 2.2 Virtual parallel rings

Upsampling increases the number of admissible parallel rings for a given sphere radius.

| Radius | Without upsampling | With upsampling |
|---|---|---|
| **4.2 cm** | <img src="figures/02_array_geometry/virtual_rings_R4v2_no_upsample.png" width="320"> | <img src="figures/02_array_geometry/virtual_rings_R4v2_upsample.png" width="320"> |
| **10 cm** | <img src="figures/02_array_geometry/virtual_rings_R10_no_upsample.png" width="320"> | <img src="figures/02_array_geometry/virtual_rings_R10_upsample.png" width="320"> |

---

## 3. Single-microphone beam patterns

Frequency sweep **0 → 4000 Hz**, array radius **R = 4.2 cm**.

### Physical microphone

| 2D | 3D |
|---|---|
| <img src="figures/03_beampattern_single/physical_mic_2d_R4v2.gif" width="360"> | <img src="figures/03_beampattern_single/physical_mic_3d_R4v2.gif" width="360"> |

### Virtual microphone on a ring

| 2D | 3D |
|---|---|
| <img src="figures/03_beampattern_single/virtual_mic_on_ring_2d_R4v2.gif" width="360"> | <img src="figures/03_beampattern_single/virtual_mic_on_ring_3d_R4v2.gif" width="360"> |

---

## 4. Ring responses after Delay-and-Sum

Directional virtual-microphone outputs after per-ring Delay-and-Sum (**R = 4.2 cm**, **0 → 4000 Hz**).

### Ring 2

| 2D | 3D |
|---|---|
| <img src="figures/04_beampattern_ring_ds/ring2_ds_2d_R4v2.gif" width="360"> | <img src="figures/04_beampattern_ring_ds/ring2_ds_3d_R4v2.gif" width="360"> |

### Ring 3

| 2D | 3D |
|---|---|
| <img src="figures/04_beampattern_ring_ds/ring3_ds_2d_R4v2.gif" width="360"> | <img src="figures/04_beampattern_ring_ds/ring3_ds_3d_R4v2.gif" width="360"> |

---

## 5. Method comparison

Beam patterns for selected paper conditions (**R = 4.2 cm**, **0 → 4000 Hz**).

### USMA-DS

| 2D | 3D |
|---|---|
| <img src="figures/05_beampattern_methods/USMA_DS_2d_R4v2.gif" width="360"> | <img src="figures/05_beampattern_methods/USMA_DS_3d_R4v2.gif" width="360"> |

### USMA-SD

| 2D | 3D |
|---|---|
| <img src="figures/05_beampattern_methods/USMA_SD_2d_R4v2.gif" width="360"> | <img src="figures/05_beampattern_methods/USMA_SD_3d_R4v2.gif" width="360"> |

### USMA-WPE-BF

| 2D | 3D |
|---|---|
| <img src="figures/05_beampattern_methods/USMA_WPE_BF_2d_R4v2.gif" width="360"> | <img src="figures/05_beampattern_methods/USMA_WPE_BF_3d_R4v2.gif" width="360"> |

### Proposed

| 2D | 3D |
|---|---|
| <img src="figures/05_beampattern_methods/Proposed_2d_R4v2.gif" width="360"> | <img src="figures/05_beampattern_methods/Proposed_3d_R4v2.gif" width="360"> |

---

## 6. Listening examples

GitHub Markdown strips `<audio>` tags, so players are on a real HTML page:

**[▶️ Open audio players](https://zaviyun.github.io/spherical-array-speech-enhancement/docs/listen.html)** · [`listen.html`](listen.html)

Qualitative `before` / `after` download links (not a substitute for the paper tables):

| Method | R = 4.2 cm | R = 10 cm |
|---|---|---|
| Proposed | [before](../05_results/Proposed/radius_4_2cm/before.wav) · [after](../05_results/Proposed/radius_4_2cm/after.wav) | [before](../05_results/Proposed/radius_10cm/before.wav) · [after](../05_results/Proposed/radius_10cm/after.wav) |
| USMA-WPE-BF | [before](../05_results/USMA_WPE_BF/radius_4_2cm/before.wav) · [after](../05_results/USMA_WPE_BF/radius_4_2cm/after.wav) | [before](../05_results/USMA_WPE_BF/radius_10cm/before.wav) · [after](../05_results/USMA_WPE_BF/radius_10cm/after.wav) |
| USMA-SD | [before](../05_results/USMA_SD/radius_4_2cm/before.wav) · [after](../05_results/USMA_SD/radius_4_2cm/after.wav) | [before](../05_results/USMA_SD/radius_10cm/before.wav) · [after](../05_results/USMA_SD/radius_10cm/after.wav) |
| USMA-DS | [before](../05_results/USMA_DS/radius_4_2cm/before.wav) · [after](../05_results/USMA_DS/radius_4_2cm/after.wav) | [before](../05_results/USMA_DS/radius_10cm/before.wav) · [after](../05_results/USMA_DS/radius_10cm/after.wav) |

More conditions: [`../05_results/`](../05_results/).

> Enable GitHub Pages (**Settings → Pages → Deploy from `main` / root**) so the online player URL works.

---

## 7. Outlook (potential future applications)

The items below are **illustrative extensions**, not evaluated claims of the current manuscript. Source location was known in the paper experiments; localization / multi-source tracking are future directions enabled by the same parallel-ring idea.

### Multi-source enhancement / separation

Parallel rings steered toward different sources can, in principle, enhance one talker while attenuating others simultaneously.

<p align="center">
  <img src="figures/06_outlook/source_separation_parallel_rings.gif" alt="Source separation outlook" width="640">
</p>

### Drone tracking without mechanical radar rotation

The same spatially flexible virtual-ring construction suggests a path toward electronic spatial scanning for tracking applications.

<p align="center">
  <img src="figures/06_outlook/drone_tracking_outlook.gif" alt="Drone tracking outlook" width="640">
</p>

---

<p align="center">
  <b>Back to</b> <a href="../README.md">README</a> · <a href="../PAPER_CODE_MAP.md">Paper ↔ Code Map</a>
</p>
