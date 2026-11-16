# Custom SMIR Simulation

This directory contains the project-specific simulation script and the
supporting files required to generate room impulse responses (RIRs) for the
spherical microphone array experiments.

The simulation is based on the **SMIR Generator** developed by Ehab A.
Habets:

- Repository: https://github.com/ehabets/SMIR-Generator

The code in this directory configures the room, sound-source position,
spherical-array geometry, and simulation parameters used in this research.

## Directory contents

The expected contents of this directory are:

```text
custom/
├── README.md
├── run_simulation.m
├── smir_generator.m
├── smir_generator_loop.cpp
├── rir_generator.cpp
├── mycart2sph.m
└── mysph2cart.m
```

`run_simulation.m` is the main script to execute. The other files provide
supporting functions and MEX source code used by the SMIR Generator.


## Requirements

- MATLAB (we used R2024a)
- MinGW-w64 C/C++ compiler (2023 release)
- SMIR Generator source files listed above

The C++ compiler must be properly installed and configured in MATLAB
to compile and run the MEX files.

## C++ Compiler Setup (Windows)

The SMIR Generator requires a C++ compiler to build its MEX files.
If no compatible C++ compiler is installed, MinGW-w64 must be installed
and configured before running the simulation.

The following setup was used in the development environment:

1. Download and install MinGW-w64 (we used 2023 release).

2. Add the MinGW-w64 `bin` directory to the Windows system `Path`
   environment variable.

3. Create a new system environment variable:

   - **Variable name:** `MW_MINGW64_LOC`
   - **Variable value:** The MinGW-w64 installation directory.

4. Restart MATLAB to ensure that the updated environment variables
   are recognized.

5. Open MATLAB and run the following command to configure the C++
   compiler:

   ```matlab
   mex -setup C++

## How to run

1. Place all files listed above in the same directory, or ensure their
   directories are added to the MATLAB path.
2. Open MATLAB and set the current working directory to this directory.
3. Review the room, source, and microphone-array parameters in
   `run_simulation.m`.
4. Run:

   ```matlab
   run_simulation
   ```

5. The script compiles the required MEX source files and calls the SMIR
   Generator to calculate the RIRs.

The script returns:

- `h`: time-domain room impulse responses.
- `H`: the corresponding transformed/frequency-domain representation
  returned by the SMIR Generator.

The exact dimensions and interpretation of these outputs should be
confirmed against the implementation of the supplied SMIR Generator
functions.

## Simulation configuration

The main parameters are defined directly in `run_simulation.m`:

| Parameter | Meaning |
|---|---|
| `procFs` | Sampling frequency |
| `c` | Speed of sound |
| `nsample` | Requested RIR length in samples |
| `N_harm` | Maximum spherical-harmonic order |
| `K` | Oversampling factor |
| `L` | Room dimensions |
| `sphLocation` | Spherical-array center / receiver location |
| `s` | Sound-source position |
| `beta` | Reverberation or wall-reflection setting used by the simulator |
| `sphRadius` | Spherical-array radius |
| `sphType` | Open or rigid sphere |
| `mic` | Microphone positions as azimuth/elevation pairs |
| `order` | Reflection order |
| `refl_coeff_ang_dep` | Reflection-coefficient mode |
| `HP` | High-pass-filter option |
| `src_type` | Source directivity type |
| `src_ang` | Source direction relative to the array center |

Angles in `mic` are specified in radians.

## Microphone configuration

The spherical microphone array consists of 32 microphones.
All 32 microphone positions are defined simultaneously in the
`mic` matrix in `run_simulation.m` and are used together in a
single simulation configuration.

The microphone positions are specified using azimuth and elevation
angles in radians. The corresponding angular values in degrees
are provided as comments alongside each microphone position.

The earlier procedure of running the simulator with groups of four
microphones (v3) was used only during development and testing. The final
simulations use the complete 32-microphone array simultaneously.

## Optional speech convolution

The script includes an optional example that convolves a clean speech file
with the first microphone's RIR. It is disabled by default:

```matlab
performConvolution = false;
```

Set it to `true` and provide `F1_1.wav` in the current working directory
to run the example. This speech file is not required for RIR generation.

## Reproducibility and reporting
