function [noisyWav, fs] = addNoise_Rev(cleanWav, revWav, snrValue)
%% Add Gaussian White Noise to Reverberant Speech
% -------------------------------------------------------------------------
% Author:       Amin Aslanzadeh
% Date:         June 2023
% Description:  Add Gaussian white noise to a reverberant speech signal
%               according to a specified SNR.
%
% Inputs:
%   cleanWav  - Path to the original clean speech file
%   revWav    - Path to the reverberant speech file
%   snrValue  - Desired SNR in dB
%
% Outputs:
%   noisyWav  - Reverberant speech with added Gaussian white noise
%   fs        - Sampling frequency
% -------------------------------------------------------------------------

%% Read Audio Signals

[y, fsClean] = audioread(cleanWav);
[Rev, fsRev] = audioread(revWav);

% Check sampling frequencies.
if fsClean ~= fsRev
    error(['Sampling frequency mismatch: clean speech = %d Hz, ' ...
           'reverberant speech = %d Hz.'], fsClean, fsRev);
end

fs = fsClean;

% Check mono signals.
if size(y, 2) ~= 1 || size(Rev, 2) ~= 1
    error('Both input signals must be mono.');
end

%% Preprocess Clean Speech

% Remove DC offset.
y = y - mean(y);

% Normalize clean speech.
peakValue = max(abs(y));

if peakValue == 0
    error('The clean speech signal is silent.');
end

y = y / peakValue;

%% Generate Gaussian White Noise

gaussWn = randn(size(Rev));

% Remove DC offset.
gaussWn = gaussWn - mean(gaussWn);

% Normalize noise.
noisePeak = max(abs(gaussWn));

if noisePeak == 0
    error('Generated noise signal is zero.');
end

gaussWn = gaussWn / noisePeak;

%% Calculate Noise Scaling Factor

% SNR = 10*log10(Psignal/Pnoise)

signalPower = mean(y.^2);
noisePower = mean(gaussWn.^2);

alpha = sqrt(signalPower / ...
             (10^(snrValue/10) * noisePower));

%% Generate Noisy Reverberant Signal

noisyWav = Rev + alpha * gaussWn;

end