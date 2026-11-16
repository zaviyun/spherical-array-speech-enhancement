
clearvars;
clc;
tic;

%% Configuration

% Project directories
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

% Input directories
referenceDir = fullfile(projectRoot, 'data', 'clean');
enhancedDir  = fullfile(projectRoot, 'data', 'enhanced');

% CD metric implementation directory
cdDir = fileparts(mfilename('fullpath'));
addpath(cdDir);

% Evaluation configuration
numSpeakers = 20;
numUtterances = 10;

speakerTypes = {'F', 'M'};

% Output filename pattern
% Example: F_1_1_DelaySum_48VM_UniformMics.wav
outputPattern = '%s_%d_%d_DelaySum_48VM_UniformMics.wav';

% Results directory
resultsDir = fullfile(projectRoot, 'results', ...
    'evaluation', 'speech_quality');

if ~isfolder(resultsDir)
    mkdir(resultsDir);
end

%% CD Evaluation

numSamples = numel(speakerTypes) * numSpeakers * numUtterances;

CD_scores = zeros(numSamples, 1);
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

            % Calculate Cepstral Distance
            CD_score = comp_cep(referencePath, enhancedPath);

            CD_scores(idx) = CD_score;

            referenceNames{idx} = referenceName;
            enhancedNames{idx} = enhancedName;

            idx = idx + 1;

        end
    end
end

%% Statistical Summary

CD_avg = mean(CD_scores);
CD_max = max(CD_scores);
CD_min = min(CD_scores);

fprintf('\n========== CD Results ==========\n');
fprintf('Number of samples: %d\n', numSamples);
fprintf('Average CD: %.4f\n', CD_avg);
fprintf('Maximum CD: %.4f\n', CD_max);
fprintf('Minimum CD: %.4f\n', CD_min);

%% Save Results

resultsTable = table(referenceNames, enhancedNames, CD_scores, ...
    'VariableNames', {'Reference', 'Enhanced', 'CD'});

writetable(resultsTable, ...
    fullfile(resultsDir, 'CD_results.csv'));

% Save summary statistics
summaryTable = table(CD_avg, CD_max, CD_min, numSamples, ...
    'VariableNames', {'Average_CD', 'Maximum_CD', ...
    'Minimum_CD', 'Number_of_Samples'});

writetable(summaryTable, ...
    fullfile(resultsDir, 'CD_summary.csv'));

toc;
