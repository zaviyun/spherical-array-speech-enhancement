%% RUN_SIMULATION
% -------------------------------------------------------------------------
% Spherical Microphone Array Room Impulse Response (SMIR) Simulation
%
% Authors:
%   Amin Aslanzadeh
%   Maedeh Kanani
%
% Date:       January 2024
% Version:    4.0
%
% Description:
%   Configures the room, sound source, and spherical microphone array,
%   compiles the required MEX files, and generates the room impulse
%   responses (RIRs) using the SMIR Generator.
%
% Based on:
%   SMIR Generator by Ehab A. Habets
%   https://github.com/ehabets/SMIR-Generator
%
% Note:
%   The microphone-position matrix below defines the complete 32-microphone
%   spherical array used in the simulations. All 32 microphone positions
%   are included simultaneously in a single simulation configuration.
% -------------------------------------------------------------------------

clearvars;
close all;
clc;

simulationTimer = tic;

%% 1. Compile the required MEX files
% Run this section when the MEX binaries need to be built or rebuilt.
% A supported C++ compiler must be configured in MATLAB.

mex -setup C++;

mex rir_generator.cpp;
mex smir_generator_loop.cpp;

%% 2. Room and simulation parameters

% General simulation parameters
procFs  = 16000;          % Sampling frequency (Hz)
c       = 343;            % Speed of sound (m/s)
nsample = 20 * 1024;      % Desired RIR length (samples)
N_harm  = 30;             % Maximum spherical-harmonic order (used in SHD)
K       = 1;              % Oversampling factor

% Room geometry
L           = [6, 5, 4];  % Room dimensions [x, y, z] (m)
sphLocation = [3, 2.5, 1.5]; % Spherical array center / receiver location (m) - Center of the room

% Sound source position
s = [1, 1, 1];            % Source position [x, y, z] (m)

% Reflection and source parameters
HP = 1;                   % Enable high-pass filtering (1: yes, 0: no)
src_type = 'o';           % Source directivity type ('o','c','s','h','b')

% Source direction relative to the spherical array center. (Towards the receiver)
% mycart2sph returns azimuth and elevation.
[src_ang(1), src_ang(2)] = mycart2sph( ...
    sphLocation(1)-s(1), ...
    sphLocation(2)-s(2), ...
    sphLocation(3)-s(3));

order = -1;               % Reflection order (-1: maximum reflection order)
refl_coeff_ang_dep = 0;   % 0: real reflection coefficients; 1: angle-dependent reflection coefficients

% Reverberation / wall reflection setting.
% An alternative six-wall reflection-coefficient vector is shown below.
beta = 1; % Reverbration Time T_60 (s)
% beta = 0.2 * ones(1, 6); % [beta_x1 beta_x2 beta_y1 beta_y2 beta_z1 beta_z2]

%% 3. Spherical microphone array configuration

sphRadius = 0.042;        % Spherical array radius (m)
sphType   = 'open';       % Sphere type: 'open' or 'rigid'

% Microphone positions in spherical coordinates:
% Each row is [azimuth, elevation] in radians.
%
% Microphone positions for the complete 32-microphone spherical array.
% All microphone positions are defined simultaneously in the matrix below.
mic = [
    0,          23*pi/60;   % Mic 1:  (azimuth 0°,   elevation 69°)
    8*pi/45,    pi/2;       % Mic 2:  (azimuth 32°,  elevation 90°)
    0,          37*pi/60;   % Mic 3:  (azimuth 0°,   elevation 111°)
    82*pi/45,   pi/2;       % Mic 4:  (azimuth 328°, elevation 90°)
    0,          8*pi/45;    % Mic 5:  (azimuth 0°,   elevation 32°)
    pi/4,       11*pi/36;   % Mic 6:  (azimuth 45°,  elevation 55°)
    23*pi/60,   pi/2;       % Mic 7:  (azimuth 69°,  elevation 90°)
    pi/4,       25*pi/36;   % Mic 8:  (azimuth 45°,  elevation 125°)
    0,          37*pi/45;   % Mic 9:  (azimuth 0°,   elevation 148°)
    7*pi/4,     25*pi/36;   % Mic 10: (azimuth 315°, elevation 125°)
    97*pi/60,   pi/2;       % Mic 11: (azimuth 291°, elevation 90°)
    7*pi/4,     11*pi/36;   % Mic 12: (azimuth 315°, elevation 55°)
    91*pi/180,  7*pi/60;    % Mic 13: (azimuth 91°,  elevation 21°)
    pi/2,       29*pi/90;   % Mic 14: (azimuth 90°,  elevation 58°)
    pi/2,       121*pi/180; % Mic 15: (azimuth 90°,  elevation 121°)
    89*pi/180,  53*pi/60;   % Mic 16: (azimuth 89°,  elevation 159°)
    pi,         23*pi/60;   % Mic 17: (azimuth 180°, elevation 69°)
    53*pi/45,   pi/2;       % Mic 18: (azimuth 212°, elevation 90°)
    pi,         37*pi/60;   % Mic 19: (azimuth 180°, elevation 111°)
    37*pi/45,   pi/2;       % Mic 20: (azimuth 148°, elevation 90°)
    pi,         8*pi/45;    % Mic 21: (azimuth 180°, elevation 32°)
    5*pi/4,     11*pi/36;   % Mic 22: (azimuth 225°, elevation 55°)
    83*pi/60,   pi/2;       % Mic 23: (azimuth 249°, elevation 90°)
    5*pi/4,     25*pi/36;   % Mic 24: (azimuth 225°, elevation 125°)
    pi,         37*pi/45;   % Mic 25: (azimuth 180°, elevation 148°)
    3*pi/4,     25*pi/36;   % Mic 26: (azimuth 135°, elevation 125°)
    37*pi/60,   pi/2;       % Mic 27: (azimuth 111°, elevation 90°)
    3*pi/4,     11*pi/36;   % Mic 28: (azimuth 135°, elevation 55°)
    269*pi/180, 7*pi/60;    % Mic 29: (azimuth 269°, elevation 21°)
    3*pi/2,     29*pi/90;   % Mic 30: (azimuth 270°, elevation 58°)
    3*pi/2,     61*pi/90;   % Mic 31: (azimuth 270°, elevation 122°)
    271*pi/180, 53*pi/60   % Mic 32: (azimuth 271°, elevation 159°)
];

%% 4. Generate room impulse responses

% h: time-domain RIRs
% H: corresponding frequency-domain / transformed representation
[h, H] = smir_generator( ...
    c, ...
    procFs, ...
    sphLocation, ...
    s, ...
    L, ...
    beta, ...
    sphType, ...
    sphRadius, ...
    mic, ...
    N_harm, ...
    nsample, ...
    K, ...
    order, ...
    refl_coeff_ang_dep, ...
    HP, ...
    src_type, ...
    src_ang);

%% 5. Optional: convolve a clean speech signal with an RIR
% This section is optional. Set performConvolution to true when the clean
% speech file is available in the current working directory.
%
% The example below convolves the clean signal with the first microphone's
% RIR, preserving the operation in the original script.

performConvolution = false;
cleanSignalFile = 'F1_1.wav';

if performConvolution
    if isfile(cleanSignalFile)
        [cleanSignal, signalFs] = audioread(cleanSignalFile);

        if signalFs ~= procFs
            warning(['The speech sampling rate (%d Hz) differs from ' ...
                     'the simulation sampling rate (%d Hz).'], ...
                     signalFs, procFs);
        end

        mic_1 = conv(cleanSignal, h(1, :));
    else
        warning('Clean speech file "%s" was not found. Convolution skipped.', ...
            cleanSignalFile);
    end
end

%% 6. Display execution time

elapsedTime = toc(simulationTimer);
fprintf('SMIR simulation script completed in %.2f seconds.\\n', elapsedTime);
