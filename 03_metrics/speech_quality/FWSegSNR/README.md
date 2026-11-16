# FWSegSNR (Frequency-Weighted Segmental SNR)

## Overview

Frequency-Weighted Segmental Signal-to-Noise Ratio (FWSegSNR) is an objective speech quality measure that evaluates the spectral distortion between a clean reference speech signal and its corresponding enhanced or processed signal.

The metric assigns different weights to frequency bands based on the clean speech spectrum.

**Higher FWSegSNR values indicate better speech quality.**

## Implementation

**Implementation file:** `comp_fwseg.m`

The MATLAB implementation is based on the Frequency-Weighted SNRseg measure described in:

Tribolet, J., Noll, P., McDermott, B., & Crochiere, R. E. (1978). A study of complexity and quality of speech waveform coders. *Proceedings of the IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP)*, 586–590.

The original MATLAB implementation was provided by Philipos C. Loizou (2006). Critical-band filtering routines were written by Bryan Pellom and John Hansen.

## Requirements

- MATLAB
- `comp_fwseg.m`
- Reference speech recordings
- Enhanced or processed speech recordings

## Usage

1. Place `comp_fwseg.m` in this directory.
2. Configure the reference and enhanced speech directories in `run_fwseg_evaluation.m`.
3. Set the output filename pattern according to the evaluated processing condition.
4. Run the evaluation script:

```matlab
run_fwseg_evaluation
```

The script calculates the FWSegSNR score for each reference-enhanced speech pair and reports the following statistics:

- Average FWSegSNR
- Maximum FWSegSNR
- Minimum FWSegSNR

## Evaluation Dataset

The evaluation is performed on 400 speech recordings:

- 200 female speech recordings (20 speakers × 10 utterances)
- 200 male speech recordings (20 speakers × 10 utterances)

Each enhanced recording is compared with its corresponding clean reference recording.

## Implementation Details

The `comp_fwseg.m` implementation performs the following operations:

1. Reads the reference and enhanced speech signals.
2. Checks that both signals have the same sampling frequency.
3. Truncates both signals to their common minimum length.
4. Divides the signals into overlapping 30 ms analysis frames with a quarter-frame shift.
5. Computes the magnitude spectra of the reference and processed signals.
6. Applies a 25-band critical-band filterbank.
7. Calculates frequency-weighted segmental SNR using the clean speech spectrum as the weighting function.
8. Averages the frame-wise scores.

The frequency weighting uses a power exponent of 0.2. Frame-wise scores are limited to the range of -10 dB to 35 dB before averaging.

## Output

The evaluation script generates two CSV files:

- `FWSegSNR_results.csv`: Individual FWSegSNR scores for all evaluated recordings.
- `FWSegSNR_summary.csv`: Average, maximum, and minimum FWSegSNR scores.

## Notes

- Higher FWSegSNR values indicate better speech quality.
- Both input signals must have matching sampling frequencies.
- The implementation truncates signals to the shorter signal length.
- The theoretical upper limit of the frame-wise score in this implementation is 35 dB. Accordingly, the clean reference condition is reported as 35 dB in the original evaluation procedure.

## References

1. Tribolet, J., Noll, P., McDermott, B., & Crochiere, R. E. (1978). A study of complexity and quality of speech waveform coders. *Proceedings of ICASSP*, 586–590.
2. Loizou, P. C. (2006). MATLAB implementation of Frequency-Weighted SNRseg.

