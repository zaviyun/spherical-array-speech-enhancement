clear all
clc
tic

addpath('/path/to/SRMRToolbox')
addpath(genpath('/path/to/SRMRToolbox/libs'))
addpath('E:\Research Room\Lynx Recorder Labratory\Evaluation Methods\SRMRToolbox')
addpath(genpath('E:\Research Room\Lynx Recorder Labratory\Evaluation Methods\SRMRToolbox\libs')) 
B = 1;
for i = 1:20
    for j = 1:10
        
        name2 = sprintf('F%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        [ratio2, energy] = SRMR(name2); 
        A2(B) = ratio2;
        
        B = B + 1;
    end
end

for i = 1:20
    for j = 1:10
        name2 = sprintf('M%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        [ratio2, energy] = SRMR(name2); 
        A2(B) = ratio2;

        
        B = B + 1;
    end
end
SRMR_avg_Noise = sum(A2)/ (B-1);
SRMR_max_Noise = max(A2);
SRMR_min_Noise = min(A2);


toc

beep


% Elapsed time is 351.586880 seconds.