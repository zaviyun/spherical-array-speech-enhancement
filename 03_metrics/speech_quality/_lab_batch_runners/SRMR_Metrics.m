clear all
clc
tic

addpath('/path/to/SRMRToolbox')
addpath(genpath('/path/to/SRMRToolbox/libs'))
addpath('D:\Research Room\Lynx Recorder Labratory\Beamforming(Processing)\MATLAB\Metrics\SRMRToolbox')
addpath(genpath('D:\Research Room\Lynx Recorder Labratory\Beamforming(Processing)\MATLAB\Metrics\SRMRToolbox\libs')) 
path(path,'../data');
B = 1;
for i = 1:20
    for j = 1:10
        
        name2 = sprintf('F%d_%d_TD_Delay_and_Sum_32mics.wav',i,j);
        [ratio2, energy] = SRMR(name2); 
        A2(B) = ratio2;
        
        B = B + 1;
    end
end

for i = 1:20
    for j = 1:10
        name2 = sprintf('M%d_%d_TD_Delay_and_Sum_32mics.wav',i,j);
        [ratio2, energy] = SRMR(name2); 
        A2(B) = ratio2;

        
        B = B + 1;
    end
end
SRMR_avg_Noise = sum(A2)/ (B-1);
SRMR_max_Noise = max(A2);
SRMR_min_Noise = min(A2);


toc


% Elapsed time is 351.586880 seconds.