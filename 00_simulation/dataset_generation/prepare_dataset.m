%% Dataset Preparation: RIR Cropping, Convolution, and Noise Addition
% -------------------------------------------------------------------------
% Author:       Amin Aslanzadeh
% Description:  Generate clean reverberant and noisy microphone signals
%               using the generated RIRs of a 32-microphone spherical array.
%
% Processing steps:
%   1. Load clean speech recordings.
%   2. Remove DC offset and normalize speech signals.
%   3. Load and crop the RIRs of all 32 microphones.
%   4. Convolve clean speech with each microphone RIR.
%   5. Add Gaussian white noise at the specified SNR.
%   6. Save the resulting microphone signals.
% -------------------------------------------------------------------------

clearvars;
clc;
close all;

%% Configuration
numMicrophones = 32;

numSpeakers = 20;
numUtterances = 10;

rirSampleRate = 16000;
rirCropLength = 17000;

snrValue = 10;

speakerTypes = {'F', 'M'};

%% Load and Crop RIRs
% All 32 RIRs are loaded once and reused for all speech recordings.

rirSignals = cell(numMicrophones, 1);

for q = 1:numMicrophones

    rirFile = sprintf('rirMic_%d.mat', q);
    rirVariable = sprintf('rirMic_%d', q);

    if ~isfile(rirFile)
        error('RIR file not found: %s', rirFile);
    end

    rirData = load(rirFile, rirVariable);

    if ~isfield(rirData, rirVariable)
        error('Variable %s not found in %s.', rirVariable, rirFile);
    end

    rir = rirData.(rirVariable);

    if ~isnumeric(rir) || isempty(rir) || ~isvector(rir)
        error('Invalid RIR data in %s.', rirFile);
    end

    if size(rir, 2) < rirCropLength
        error(['RIR %s contains fewer than %d samples. ' ...
               'Check the cropping length.'], ...
               rirFile, rirCropLength);
    end

    % Crop the RIR to the specified number of samples.
    rirSignals{q} = rir(1, 1:rirCropLength);

end

fprintf('All %d RIRs loaded and cropped successfully.\n', ...
        numMicrophones);

%% Speech Processing and Microphone Signal Generation

for sIdx = 1:numel(speakerTypes)

    speakerType = speakerTypes{sIdx};

    fprintf('\nProcessing %s speaker recordings...\n', speakerType);

    for i = 1:numSpeakers

        for j = 1:numUtterances

            %% Load Clean Speech

            inputFile = sprintf('%s%d_%d.WAV', speakerType, i, j);

            if ~isfile(inputFile)
                error('Speech file not found: %s', inputFile);
            end

            [cleanSig, Fs] = audioread(inputFile);

            % Check the sampling frequency.
            if Fs ~= rirSampleRate
                error(['Sampling frequency mismatch in %s. ' ...
                       'Expected %d Hz, but received %d Hz.'], ...
                       inputFile, rirSampleRate, Fs);
            end

            % This implementation expects mono speech recordings.
            if size(cleanSig, 2) ~= 1
                error('Input speech must be mono: %s', inputFile);
            end

            %% Speech Preprocessing

            % Remove DC offset.
            cleanSig = cleanSig - mean(cleanSig);

            % Normalize the clean speech signal.
            peakValue = max(abs(cleanSig));

            if peakValue == 0
                error('The input speech signal is silent: %s', inputFile);
            end

            cleanSig = cleanSig / peakValue;

            %% Generate Microphone Signals

            for q = 1:numMicrophones

                % Convolve clean speech with the corresponding RIR.
                micSignal = conv(cleanSig, rirSignals{q});

                % Save clean reverberant microphone output.
                micFile = sprintf( ...
                    '%s%d_%d_Microphone (%d) Output_0v1.wav', ...
                    speakerType, i, j, q);

                audiowrite(micFile, micSignal, Fs);

                %% Add Gaussian White Noise

                [noisyWav, fsNoise] = addNoise_Rev( ...
                    inputFile, micFile, snrValue);

                % Verify the output sampling frequency.
                if fsNoise ~= Fs
                    error('Sampling frequency mismatch in noisy output.');
                end

                % Save noisy microphone output.
                noisyFile = sprintf( ...
                    '%s%d_%d_Microphone (%d) Noisy Output_%d(dB)_0v1.wav', ...
                    speakerType, i, j, q, snrValue);

                audiowrite(noisyFile, noisyWav, Fs);

            end

            fprintf('Processed: %s\n', inputFile);

        end
    end
end

%% Completion

fprintf('\nDataset generation completed successfully.\n');
fprintf('Number of microphones: %d\n', numMicrophones);
fprintf('RIR crop length: %d samples\n', rirCropLength);
fprintf('RIR duration: %.4f seconds\n', ...
        rirCropLength / rirSampleRate);
fprintf('Target SNR: %d dB\n', snrValue);