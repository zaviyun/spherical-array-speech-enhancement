
clearvars;
clc;
tic;

%% Configuration

% Project directories
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

% Input directories
referenceDir = fullfile(projectRoot, 'data', 'clean');
enhancedDir  = fullfile(projectRoot, 'data', 'enhanced');

% Add FWSegSNR implementation directory
metricDir = fileparts(mfilename('fullpath'));
addpath(metricDir);

% Evaluation configuration
numSpeakers = 20;
numUtterances = 10;

speakerTypes = {'F', 'M'};

% Enhanced speech filename pattern
% Example: F_1_1_DelaySum_48VM_UniformMics.wav
outputPattern = '%s_%d_%d_DelaySum_48VM_UniformMics.wav';

% Results directory
resultsDir = fullfile(projectRoot, 'results', ...
    'evaluation', 'speech_quality', 'FWSegSNR');

if ~isfolder(resultsDir)
    mkdir(resultsDir);
end

%% FWSegSNR Evaluation

numSamples = numel(speakerTypes) * numSpeakers * numUtterances;

FWSeg_scores = zeros(numSamples, 1);
referenceNames = cell(numSamples, 1);
enhancedNames = cell(numSamples, 1);

idx = 1;

for s = 1:numel(speakerTypes)

    speakerType = speakerTypes{s};

    for i = 1:numSpeakers
        for j = 1:numUtterances

            % Reference speech filename
            referenceName = sprintf('%s%d_%d.WAV', ...
                speakerType, i, j);

            % Enhanced speech filename
            enhancedName = sprintf(outputPattern, ...
                speakerType, i, j);

            referencePath = fullfile(referenceDir, referenceName);
            enhancedPath = fullfile(enhancedDir, enhancedName);

            % Check input files
            if ~isfile(referencePath)
                error('Reference file not found: %s', referencePath);
            end

            if ~isfile(enhancedPath)
                error('Enhanced file not found: %s', enhancedPath);
            end

            fprintf('Processing: %s\n', enhancedName);

            % Calculate Frequency-Weighted SNRseg
            FWSeg_score = comp_fwseg(referencePath, enhancedPath);

            FWSeg_scores(idx) = FWSeg_score;

            referenceNames{idx} = referenceName;
            enhancedNames{idx} = enhancedName;

            idx = idx + 1;

        end
    end
end

%% Statistical Summary

FWSeg_avg = mean(FWSeg_scores);
FWSeg_max = max(FWSeg_scores);
FWSeg_min = min(FWSeg_scores);

fprintf('\n========== FWSegSNR Results ==========\n');
fprintf('Number of samples: %d\n', numSamples);
fprintf('Average FWSegSNR: %.4f dB\n', FWSeg_avg);
fprintf('Maximum FWSegSNR: %.4f dB\n', FWSeg_max);
fprintf('Minimum FWSegSNR: %.4f dB\n', FWSeg_min);

%% Save Individual Results

resultsTable = table(referenceNames, enhancedNames, FWSeg_scores, ...
    'VariableNames', {'Reference', 'Enhanced', 'FWSegSNR_dB'});

writetable(resultsTable, ...
    fullfile(resultsDir, 'FWSegSNR_results.csv'));

%% Save Summary Statistics

summaryTable = table(FWSeg_avg, FWSeg_max, FWSeg_min, numSamples, ...
    'VariableNames', {'Average_FWSegSNR_dB', ...
    'Maximum_FWSegSNR_dB', 'Minimum_FWSegSNR_dB', ...
    'Number_of_Samples'});

writetable(summaryTable, ...
    fullfile(resultsDir, 'FWSegSNR_summary.csv'));

toc;
