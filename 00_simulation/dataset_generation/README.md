## RIR Cropping and Dataset Generation

After generating the RIRs, a post-processing stage is performed
to generate the microphone signals used in the experiments.

The RIRs are cropped to 17,000 samples (approximately 1.0625 seconds
at a sampling frequency of 16 kHz). This duration was selected based
on experimental observations to limit the effective RIR length,
avoid the distortion observed with excessively long impulse responses,
and reduce unnecessary computational overhead.

For each clean speech recording, the following processing steps
are applied:

1. DC offset removal.
2. Amplitude normalization.
3. Loading the corresponding RIR for each of the 32 microphones.
4. Cropping each RIR to 17,000 samples.
5. Convolution of clean speech with the cropped RIR.
6. Addition of Gaussian white noise at an SNR of 10 dB.
7. Saving the clean reverberant and noisy microphone signals.

The procedure is applied to both male and female speech recordings.

The MATLAB implementation is provided in:

- `prepare_dataset.m`: RIR cropping, convolution, and dataset generation.
- `addNoise_Rev.m`: Gaussian white noise generation and SNR adjustment.

The RIR sample rate and speech sample rate must both be 16 kHz.

### Sample Outputs

Representative RIRs and microphone signals are provided in
[`rir_samples`].

These samples illustrate the generated impulse responses and
the corresponding microphone signals for the two spherical
microphone array radii.