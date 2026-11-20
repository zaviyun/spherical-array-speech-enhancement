# Visual Demo Gallery

Interactive overview of the geometry, beam patterns, listening examples, and outlook visuals for this project.

> Media files live under [`figures/`](figures/).  
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

Qualitative `before` / `after` examples (not a substitute for the paper tables):

| Method | R = 4.2 cm | R = 10 cm |
|---|---|---|
| Proposed | [before](../05_results/Proposed/radius_4_2cm/before.wav) · [after](../05_results/Proposed/radius_4_2cm/after.wav) | [before](../05_results/Proposed/radius_10cm/before.wav) · [after](../05_results/Proposed/radius_10cm/after.wav) |
| USMA-WPE-BF | [before](../05_results/USMA_WPE_BF/radius_4_2cm/before.wav) · [after](../05_results/USMA_WPE_BF/radius_4_2cm/after.wav) | [before](../05_results/USMA_WPE_BF/radius_10cm/before.wav) · [after](../05_results/USMA_WPE_BF/radius_10cm/after.wav) |
| USMA-SD | [before](../05_results/USMA_SD/radius_4_2cm/before.wav) · [after](../05_results/USMA_SD/radius_4_2cm/after.wav) | [before](../05_results/USMA_SD/radius_10cm/before.wav) · [after](../05_results/USMA_SD/radius_10cm/after.wav) |
| USMA-DS | [before](../05_results/USMA_DS/radius_4_2cm/before.wav) · [after](../05_results/USMA_DS/radius_4_2cm/after.wav) | [before](../05_results/USMA_DS/radius_10cm/before.wav) · [after](../05_results/USMA_DS/radius_10cm/after.wav) |

More conditions: [`../05_results/`](../05_results/).

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

### Post Proposed → single-channel SE cascade (R = 4.2 cm)

Illustrative experiment (not a manuscript table): noisy reverberant **single-mic** input and the **proposed** output were each passed to four single-channel SE models — **ESPnet**, **MP-SENet**, **DB-AIAT**, **DB-CPT** — with WER from **WeNet 2.0**. Phase-robust models (**DB-AIAT**, **DB-CPT**) were especially strong on top of the proposed front-end, though WER was not driven to zero.

<p align="center">
  <img src="figures/06_outlook/post_se_cascade_concept.png" alt="Post-SE cascade concept" width="720">
</p>

Folder: [`audio/outlook_post_se_R4v2/`](audio/outlook_post_se_R4v2/) · ASR summary: [`asr_wer_summary.md`](audio/outlook_post_se_R4v2/asr_wer_summary.md)

| Stage / condition | Audio | ASR text |
|---|---|---|
| Clean reference | [wav](audio/outlook_post_se_R4v2/01_clean_reference.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/reference.txt) |
| Noisy reverberant mic | [wav](audio/outlook_post_se_R4v2/02_noisy_reverb_mic.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/noisy_reverb_mic.txt) |
| Proposed output | [wav](audio/outlook_post_se_R4v2/03_proposed_output.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/proposed_output.txt) |
| ESPnet on noisy | [wav](audio/outlook_post_se_R4v2/se_ESPnet_on_noisy.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_ESPnet_on_noisy.txt) |
| ESPnet on proposed | [wav](audio/outlook_post_se_R4v2/se_ESPnet_on_proposed.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_ESPnet_on_proposed.txt) |
| MP-SENet on noisy | [wav](audio/outlook_post_se_R4v2/se_MP-SENet_on_noisy.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_MP-SENet_on_noisy.txt) |
| MP-SENet on proposed | [wav](audio/outlook_post_se_R4v2/se_MP-SENet_on_proposed.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_MP-SENet_on_proposed.txt) |
| DB-AIAT on noisy | [wav](audio/outlook_post_se_R4v2/se_DB-AIAT_on_noisy.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_DB-AIAT_on_noisy.txt) |
| DB-AIAT on proposed | [wav](audio/outlook_post_se_R4v2/se_DB-AIAT_on_proposed.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_DB-AIAT_on_proposed.txt) |
| DB-CPT on noisy | [wav](audio/outlook_post_se_R4v2/se_DB-CPT_on_noisy.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_DB-CPT_on_noisy.txt) |
| DB-CPT on proposed | [wav](audio/outlook_post_se_R4v2/se_DB-CPT_on_proposed.wav) | [txt](audio/outlook_post_se_R4v2/transcripts/se_DB-CPT_on_proposed.txt) |

### Proposed → zero-shot TTS / voice cloning (conceptual)

Future direction only: use the enhanced utterance as a reference for zero-shot TTS / voice cloning (text + reference speech) to reconstruct a clean target. Not evaluated in the current paper.

<p align="center">
  <img src="figures/06_outlook/post_tts_voice_cloning_concept.gif" alt="Zero-shot TTS outlook" width="640">
</p>

---

<p align="center">
  <b>Back to</b> <a href="../README.md">README</a> · <a href="../PAPER_CODE_MAP.md">Paper ↔ Code Map</a>
</p>
