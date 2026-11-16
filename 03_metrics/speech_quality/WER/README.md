# WER Evaluation using WeNet

This directory contains a Jupyter Notebook for English automatic speech recognition (ASR) with WeNet and Word Error Rate (WER) evaluation using `jiwer`.

## Contents

- `WeNet_ASR_WER_Evaluation.ipynb`: Complete workflow, explanations, configuration, ASR inference, text normalization, WER calculation, and CSV export.

## Requirements

Python 3 and Jupyter Notebook/Lab. The notebook installs the required packages, including WeNet, NumPy, pandas, SoundFile, and jiwer.

## Usage

1. Place the notebook in the project repository.
2. Configure `AUDIO_DIR`, `REFERENCE_FILE`, and `SCENARIO_SUFFIX` in Section 2.
3. Ensure the 400 audio files and reference transcripts follow the same order: female speakers first, then male speakers.
4. Run the notebook from the project root, executing cells from top to bottom.

The primary reported metric is corpus-level WER. If the reference transcript file contains one non-empty line per audio file (400 lines), the notebook also calculates utterance-level WER.

Lower WER indicates better ASR performance.
