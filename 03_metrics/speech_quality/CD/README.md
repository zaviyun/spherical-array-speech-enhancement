# CD (Cepstral Distance)

## Overview

Cepstral Distance (CD) is used to evaluate the spectral distortion between a reference speech signal and its corresponding enhanced or processed signal.

The CD metric in this repository is implemented using the MATLAB code provided by Philipos C. Loizou.

## Implementation

**Implementation file:** `comp_cep.m`

The implementation is based on the cepstral distance measure described in:

Kitawaki, N., Nagabuchi, H., & Itoh, K. (1988). Objective quality evaluation for low-bit-rate speech coding systems. *IEEE Journal on Selected Areas in Communications*, 6(2), 262–273.

The original MATLAB implementation was provided by Philipos C. Loizou (2006), with LPC routines attributed to Bryan Pellom and John Hansen.

## Requirements

- MATLAB
- `comp_cep.m`
- Reference speech recordings
- Enhanced or processed speech recordings

## Usage

1. Place the `comp_cep.m` implementation in this directory.
2. Configure the reference and enhanced speech directories in `run_cd_evaluation.m`.
3. Set the output filename pattern according to the evaluated processing condition.
4. Run the evaluation script:

```matlab
run_cd_evaluation
```

The script calculates the CD score for each reference-enhanced speech pair and computes the following statistics:

- Average CD
- Maximum CD
- Minimum CD

## Evaluation Dataset

The evaluation is performed on 400 speech recordings:

- 200 female speech recordings (20 speakers × 10 utterances)
- 200 male speech recordings (20 speakers × 10 utterances)

Each enhanced recording is compared with its corresponding clean reference recording.

## Implementation Details

The `comp_cep.m` implementation performs the following operations:

1. Reads the reference and enhanced speech signals.
2. Removes the mean value from each signal.
3. Independently normalizes the amplitude of each signal.
4. Checks the sampling frequencies.
5. Truncates both signals to their common minimum length.
6. Computes frame-wise cepstral distortion.
7. Sorts the frame-wise distortion values and averages the lowest 95% of them.

The implementation uses 30 ms analysis frames, a quarter-frame shift, and LPC-based cepstral analysis.

## Output

The evaluation script generates two CSV files:

- `CD_results.csv`: Individual CD scores for all evaluated recordings.
- `CD_summary.csv`: Average, maximum, and minimum CD scores.

## Notes

- Lower CD values indicate less cepstral distortion between the reference and processed speech signals.
- The reference and enhanced signals must have matching sampling frequencies.
- The original implementation independently normalizes the reference and enhanced signals and truncates them to the shorter signal length.
- The original source code header and copyright notices should be preserved when redistributing `comp_cep.m`.

## References

1. Loizou, P. C. (2006). MATLAB implementation of cepstral distance and LPC routines.
2. Kitawaki, N., Nagabuchi, H., & Itoh, K. (1988). Objective quality evaluation for low-bit-rate speech coding systems. *IEEE Journal on Selected Areas in Communications*, 6(2), 262–273.
