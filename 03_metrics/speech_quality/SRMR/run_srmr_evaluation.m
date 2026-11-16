clearvars;
clc;
tic;

%% Configuration

% Project directories
projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));

dataDir = fullfile(projectRoot, 'data');

% Path to the externally installed SRMRToolbox
toolboxDir = 'path/to/SRMRToolbox';

% Add toolbox paths
addpath(toolboxDir);
addpath(genpath(fullfile(toolboxDir, 'libs')));

% Dataset configuration
numSpeakers = 20;
numUtterances = 10;

speakerTypes = {'F', 'M'};

%% SRMR Evaluation

numSamples = 2 * numSpeakers * numUtterances;

SRMR_scores = zeros(numSamples, 1);
sampleNames = cell(numSamples, 1);

idx = 1;

for s = 1:numel(speakerTypes)

    speakerType = speakerTypes{s};

    for i = 1:numSpeakers
        for j = 1:numUtterances

            filename = sprintf( ...
                'drv_%s%d_%d_3CenterMics_8MicsOnRing.wav', ...
                speakerType, i, j);

            filePath = fullfile(dataDir, filename);

            if ~isfile(filePath)
                error('Input file not found: %s', filePath);
            end

            fprintf('Processing: %s\n', filename);

            [srmrScore, energy] = SRMR(filePath);

            SRMR_scores(idx) = srmrScore;
            sampleNames{idx} = filename;

            idx = idx + 1;

        end
    end
end

%% Statistical Summary

SRMR_avg = mean(SRMR_scores);
SRMR_max = max(SRMR_scores);
SRMR_min = min(SRMR_scores);

fprintf('\n========== SRMR Results ==========\n');
fprintf('Number of samples: %d\n', numSamples);
fprintf('Average SRMR: %.4f\n', SRMR_avg);
fprintf('Maximum SRMR: %.4f\n', SRMR_max);
fprintf('Minimum SRMR: %.4f\n', SRMR_min);

%% Save Results

resultsTable = table(sampleNames, SRMR_scores, ...
    'VariableNames', {'Filename', 'SRMR'});

writetable(resultsTable, ...
    fullfile(projectRoot, 'results', 'evaluation', ...
    'speech_quality', 'SRMR_results.csv'));

toc;