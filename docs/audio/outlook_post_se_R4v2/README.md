# Outlook — Proposed + single-channel SE (R = 4.2 cm)

Illustrative only — **not** part of the manuscript tables.

## Audio files

| File | Meaning |
|---|---|
| `01_clean_reference.wav` | Clean speech (no noise / reverberation) |
| `02_noisy_reverb_mic.wav` | One physical mic, noisy + reverberant |
| `03_proposed_output.wav` | Output of the proposed multi-channel method |
| `se_ESPnet_on_noisy.wav` | ESPnet SE on noisy mic |
| `se_ESPnet_on_proposed.wav` | ESPnet SE on proposed output |
| `se_MP-SENet_on_noisy.wav` | MP-SENet on noisy mic |
| `se_MP-SENet_on_proposed.wav` | MP-SENet on proposed output |
| `se_DB-AIAT_on_noisy.wav` | DB-AIAT on noisy mic |
| `se_DB-AIAT_on_proposed.wav` | DB-AIAT on proposed output |
| `se_DB-CPT_on_noisy.wav` | DB-CPT on noisy mic |
| `se_DB-CPT_on_proposed.wav` | DB-CPT on proposed output |

## ASR / WER (WeNet 2.0)

Fill / replace:

- `asr_wer_summary.md` — WER table + short notes
- `transcripts/*.txt` — one hypothesis text file per condition (optional but useful)

Reference transcript (ground truth): `transcripts/reference.txt`
