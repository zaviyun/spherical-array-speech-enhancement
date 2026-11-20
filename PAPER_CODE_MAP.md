# Paper ↔ Code Map

Manuscript: *Speech Enhancement in Human–Machine Interaction in Noisy Reverberant Environments Using a Spherical Array with a Variable Number of Microphones*

This document is the **authoritative index** for reviewers and users who need to know which script corresponds to which paper condition. Prefer the **Primary script** column when reproducing Tables 2–3.

Paths are relative to the repository root.

---

## 1. Experimental configuration (Sec. 4)

| Parameter | Value | Where configured |
|---|---|---|
| Room `L` | `[6, 5, 4]` m | `00_simulation/smir_generator/custom_zaviyun/run_simulation.m` |
| RT60 / `beta` | `1` s | same |
| Array center | `[3, 2.5, 1.5]` m | same |
| Source | `[1, 1, 1]` m | same |
| `c` | 343 m/s | simulation + method scripts |
| Radii | 0.042 m and 0.100 m | `sphRadius` / `R` |
| Physical mics | 32, open sphere | `run_simulation.m` (`mic` matrix) |
| Base `fs` | 16 kHz | dataset + dataset |
| Proposed internal `fs` | 32 kHz (then back to 16 kHz) | Proposed / NEW-* scripts |
| SNR | ≈ 10 dB AWGN | `00_simulation/dataset_generation/` |
| Evaluation set | 400 utterances (20F + 20M × 10) | method batch loops |
| Primary metric | WER (WeNet 2.0) | `03_metrics/speech_quality/WER/` |

---

## 2. Proposed pipeline stages (Fig. 5)

| Stage | Operation | Typical code location |
|---|---|---|
| 1 | Virtual mics on parallel rings (SHD) | ring-synthesis scripts inside each method folder; helper `01_src/methods/virtual_microphone/virtualMic.m` |
| 2 | Per-ring Delay-and-Sum → directional VMs | same synthesis scripts (`SphereRingCenterMicSynth*.m`) |
| 3 | Upsampling 16 → 32 kHz | **Proposed** / **NEW-*** only |
| 4 | Segmented WPE on ring outputs | WPE stages; package under `04_third_party/WPE_FDNPL/` |
| 5 | Linear Superdirective MISO | `T400_SuperDirective_*` / `BF_LinearSuperDirective*.m` |
| 6 | Downsample to 16 kHz | end of Proposed scripts |

---

## 3. Tables 2–3 — method ↔ script mapping

### Legend

| Tag | Meaning |
|---|---|
| **Primary** | Best match in this repo for the named paper condition |
| Alternate | Extra candidate kept for transparency; not required for table reproduction |
| Shared | One script used for both radii, or radius set inside the file |

> Before a full rerun, update absolute `path(...)` / `saveDir` strings (often under `D:/ARTICLE/...`) to your local folders.

---

### Table 2 — Array radius **R = 4.2 cm**

| Paper name | Meaning | Primary script | Key settings observed in script | Notes |
|---|---|---|---|---|
| **No Proc** | Closest-mic noisy-reverberant reference | `00_simulation/dataset_generation/prepare_dataset.m` | 16 kHz; AWGN 10 dB | Reference condition |
| **USMA-DS** | Spherical Delay-and-Sum | `01_src/methods/USMA_DS/TD_Delay_and_Sum.m` + batch `Totall_400_BF_apply.m` | R = 0.042 | Official TD path used for the reported tables |
| **USMA-SD** | Spherical Superdirective (32 mics) | `01_src/methods/USMA_SD/BF_SphericalSuperDirective_Demo.m` | R = 0.042, fs = 16 kHz | Demo/driver for 4.2 cm |
| **USMA-BF** | Baseline rings + SD; no WPE; no upsample | `01_src/methods/USMA_BF/radius_4_2cm/T400_RingSynth_and_SuperDirective_4and3_rings.m` | R = 0.042, fs = 16 kHz, `selectMics = [1..4]` | Layer-2 helper: `USMA_BF/BF_LinearSuperDirective.m` |
| **NEW-USMA-BF** | Proposed without WPE (with upsample) | `01_src/methods/NEW_USMA_BF/radius_4_2cm/T400_RingSynth_and_SuperDirective_7and8_rings.m` | R = 0.042, fs = 32 kHz | Layer-2 helper: `BF_LinearSuperDirective_For_Upsampled.m` |
| **USMA-WPE** | Rings + WPE only | `01_src/methods/USMA_WPE/radius_4_2cm/T400_RingSynth_4and3_rings_withWPE.m` | fs = 16 kHz | WPE-only ablation |
| **NEW-USMA-WPE** | Upsampled rings + WPE only | `01_src/methods/NEW_USMA_WPE/radius_4_2cm/T400_RingSynth_withWPE_R_4v2_Upsampling.m` | `r = 0.042`, upsample + segmented WPE | Filename/paths already match 4.2 cm; a leftover comment mentions 10 cm historically |
| **USMA-WPE-BF** | Full baseline | `01_src/methods/USMA_WPE_BF/radius_4_2cm/T400_SuperDirective_4and3_rings_withWPE.m` | R = 0.042, fs = 16 kHz, `selectMics = [2..8]` | Filename still uses the USMA-BF “4and3” label; runtime selection is 7 rings |
| **Proposed** | Full method | `01_src/methods/Proposed/radius_4_2cm/T400_SuperDirective_On_rings_withWPE_R_4v2_Upsampling.m` | R = 0.042, fs = 32 kHz, `selectMics = [2..8]` | Canonical Proposed @ 4.2 cm; SD uses lab regularization `regul = 0.03` (internal BF parameter, not a table column) |

**Alternates @ 4.2 cm (do not use unless you know why):**

| File | Why it exists |
|---|---|
| `NEW_USMA_BF/radius_4_2cm/T400_RingSynth_and_SuperDirective_15and16_rings.m` | Denser 4.2 cm experiment (`R = 0.042`, `fs = 64 kHz`, 15 rings); not used for the main table row |
| `NEW_USMA_BF/radius_4_2cm/T400_RingSynth_and_SuperDirective_7and8_rings_filtered.m` | Filtered variant; `selectMics = [2..8]` |
| `NEW_USMA_BF/radius_4_2cm/SphereRingCenterMicSynth_v2_1_2024.m` | Ring-synthesis helper / earlier driver |

---

### Table 3 — Array radius **R = 10 cm**

| Paper name | Meaning | Primary script | Key settings observed in script | Notes |
|---|---|---|---|---|
| **No Proc** | Closest-mic reference | `00_simulation/dataset_generation/prepare_dataset.m` | 10 cm RIRs + AWGN 10 dB | Same procedure as 4.2 cm with 10 cm array RIRs |
| **USMA-DS** | Spherical Delay-and-Sum | `01_src/methods/USMA_DS/TD_Delay_and_Sum.m` + `Totall_400_BF_apply.m` | Shared drivers | Same scripts as 4.2 cm; set radius and feed the 10 cm microphone inputs |
| **USMA-SD** | Spherical Superdirective | `01_src/methods/USMA_SD/T400_Spherical_SuperDirective_BF_32Mics.m` | R = 0.1, fs = 16 kHz | T400 batch for 10 cm |
| **USMA-BF** | Baseline rings + SD | `01_src/methods/USMA_BF/radius_10cm/T400_RingSynth_and_SuperDirective_4and3_rings_R_0v1m.m` | R = 0.1, fs = 16 kHz, `selectMics = [2..8]` | |
| **NEW-USMA-BF** | Proposed without WPE | `01_src/methods/NEW_USMA_BF/radius_10cm/T400_RingSynth_and_SuperDirective_17rings_R_0v1m.m` | R = 0.1, fs = 32 kHz, `selectMics = [2..18]` (17 rings) | Primary 10 cm ablation without WPE |
| **USMA-WPE** | Rings + WPE only | `01_src/methods/USMA_WPE/radius_10cm/T400_RingSynth_withJustWPE_R_0v1_7rings_7Input_1Output.m` | R = 0.1, fs = 16 kHz | |
| **NEW-USMA-WPE** | Upsampled rings + WPE only | `01_src/methods/NEW_USMA_WPE/radius_10cm/T400_RingSynth_withWPE_R_0v1_Upsampling.m` | R = 0.1 | Alternate I/O grouping: `..._16Input_1Output.m` |
| **USMA-WPE-BF** | Full baseline | `01_src/methods/USMA_WPE_BF/radius_10cm/T400_SuperDirective_7rings_withWPE_R_0v1m.m` | R = 0.1, fs = 16 kHz, `selectMics = [2..8]` | 7-ring SD after WPE @ 10 cm |
| **Proposed** | Full method | `01_src/methods/Proposed/radius_10cm/T400_SuperDirective_On_rings_withWPE_R_0v1_Upsampling.m` | R = 0.1, fs = 32 kHz, `selectMics = [2..17]` | Canonical Proposed @ 10 cm; SD uses lab regularization `regul = 0.01` (internal BF parameter, not a table column) |

**Alternates @ 10 cm:**

| File | Why it exists |
|---|---|
| `NEW_USMA_WPE/radius_10cm/T400_RingSynth_withJustWPE_R_0v1_Upsampling_16Input_1Output.m` | WPE I/O grouping variant |

---

## 4. Example qualitative audio (`05_results/`)

For each method folder:

```text
05_results/<METHOD>/radius_4_2cm/before.wav
05_results/<METHOD>/radius_4_2cm/after.wav
05_results/<METHOD>/radius_10cm/before.wav
05_results/<METHOD>/radius_10cm/after.wav
```

These samples support listening tests / demos. **Reported table numbers come from the full 400-utterance metric pipelines**, not from these single files.

---

## 5. Metrics

| Metric | Role in paper | Entry point |
|---|---|---|
| **WER** | Primary | `03_metrics/speech_quality/WER/WeNet_ASR_WER_Evaluation.ipynb` |
| PESQ | Secondary | `03_metrics/speech_quality/PESQ/run_pesq_evaluation.py` |
| FWSegSNR | Secondary | `03_metrics/speech_quality/FWSegSNR/run_fwseg_evaluation.m` |
| CD | Secondary | `03_metrics/speech_quality/CD/run_cd_evaluation.m` |
| SRMR | Secondary | `03_metrics/speech_quality/SRMR/run_srmr_evaluation.m` |
| Beam pattern / DF / WNG | Array analysis (Figs. related to Sec. 2.2.3) | `03_metrics/array_performance/Proposed_BeamPattern.m` and `01_src/methods/Proposed/Proposed_BeamPattern.m` |

Lab-era batch runners (optional): `03_metrics/speech_quality/_lab_batch_runners/`.

---

## 6. Third-party dependencies used by the mapped scripts

| Component | Location | Used by |
|---|---|---|
| SMIR Generator (Habets) | `00_simulation/smir_generator/` | RIR generation |
| WPE / FDNPL | `04_third_party/WPE_FDNPL/` | USMA-WPE*, NEW-USMA-WPE, USMA-WPE-BF, Proposed |
| WeNet + jiwer | external (see WER README) | Table WER |
| pypesq | external | PESQ |
| SRMRToolbox | external | SRMR |
| Loizou CD / FWSegSNR helpers | vendored under metric folders | CD, FWSegSNR |

---

## 7. Roadmap

Planned public improvements for this companion repository:

- [x] Organize methods by paper name and array radius
- [x] Provide qualitative `before` / `after` audio samples under `05_results/`
- [x] Document the paper ↔ script mapping for Tables 2–3
- [x] Visual demo gallery under `docs/`
- [ ] Make Primary experiment scripts path-portable (replace absolute lab `path` / `saveDir` entries)
- [ ] Archive non-table alternate scripts so only Primary drivers remain prominent
- [ ] Add a minimal config / relative-path convention for dataset and output folders
- [ ] Rebuild SMIR MEX binaries from the included `.cpp` sources and document the tested MATLAB version
- [ ] Add a short end-to-end demo recipe (one utterance, one radius, Proposed method)

---

## 8. Data Availability

Companion scripts and example audio for this work:

https://github.com/zaviyun/spherical-array-speech-enhancement

The mapping between experimental conditions in Tables 2–3 and the corresponding scripts is provided in `PAPER_CODE_MAP.md`. Full TIMIT-based evaluation corpora are not redistributed due to licensing and size constraints; generation scripts are included under `00_simulation/`.