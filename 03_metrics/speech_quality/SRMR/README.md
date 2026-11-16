# SRMR (Speech-to-Reverberation Modulation Energy Ratio)

## Implementation

The SRMR metric is calculated using the MATLAB implementation provided by the MuSAE Lab SRMR Toolbox.

**Source repository:**  
https://github.com/MuSAELab/SRMRToolbox

## Requirements

- MATLAB
- SRMRToolbox
- Required toolbox libraries located in the `libs` directory

## Usage

1. Download or clone the [SRMRToolbox](https://github.com/MuSAELab/SRMRToolbox) repository.
2. Add the toolbox directory and its `libs` subdirectory to the MATLAB path.
3. Configure the input data directory in `run_srmr_evaluation.m`.
4. Run the evaluation script.

The script calculates the SRMR score for each speech recording and reports the average, maximum, and minimum scores across the evaluated samples.

## Evaluation Dataset

The evaluation is performed on 400 speech recordings:

- 200 female speech recordings (20 speakers × 10 utterances)
- 200 male speech recordings (20 speakers × 10 utterances)

## Output

The evaluation script reports:

- Average SRMR score
- Maximum SRMR score
- Minimum SRMR score

## Reference

- [MuSAELab/SRMRToolbox](https://github.com/MuSAELab/SRMRToolbox)
