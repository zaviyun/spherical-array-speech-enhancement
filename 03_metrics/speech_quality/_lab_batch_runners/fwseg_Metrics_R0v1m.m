clear all
clc
tic
path(path,'../data');
path(path,'../../../Evaluation Methods/FWSeg_SNR')
B = 1;
for i = 1:20
    for j = 1:10
        name1 = sprintf('F%d_%d.WAV',i,j);
        name2 = sprintf('F%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        fwseg_dist1= comp_fwseg(name1, name2);
        A1(B) = fwseg_dist1;
        
        B = B + 1;
    end
end

for i = 1:20
    for j = 1:10
        name1 = sprintf('M%d_%d.WAV',i,j);
        name2 = sprintf('M%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        fwseg_dist1= comp_fwseg(name1, name2);
        A1(B) = fwseg_dist1;
        
        B = B + 1;
    end
end

FWSeg_avg_clean = 35;

FWSeg_avg_Noise = sum(A1)/ (B-1);
FWSeg_max_Noise = max(A1);
FWSeg_min_Noise = min(A1);

toc
beep

% fwseg_avg1_clean =
% 
%      35
% 
% 
% fwseg_avg1_Noise =
% 
%     7.7914
% 
% 
% fwseg_avg2_Reverb =
% 
%     4.9388
% 
% 
% fwseg_avg3_Reverb_plus_noise =
% 
%     3.8441
% 
% Elapsed time is 219.069539 seconds.