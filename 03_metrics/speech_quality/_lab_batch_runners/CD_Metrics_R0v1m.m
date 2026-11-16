clear all
clc
tic
path(path,'../data');
path(path,'../../../Evaluation Methods/CD')
B = 1;
for i = 1:20
    for j = 1:10
        name1 = sprintf('F%d_%d.WAV',i,j);
        name2 = sprintf('F%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        cep_mean1= comp_cep(name1, name2);
        A1(B) = cep_mean1;
        
        B = B + 1;
    end
end

for i = 1:20
    for j = 1:10
        name1 = sprintf('M%d_%d.WAV',i,j);
        name2 = sprintf('M%d_%d_TD_Delay_and_Sum_32mics_R0v1m.wav',i,j);
        disp(name2)
        cep_mean1= comp_cep(name1, name2);
        A1(B) = cep_mean1;

        B = B + 1;
    end
end

CD_avg_Noise = sum(A1)/ (B-1);
CD_max_Noise = max(A1);
CD_min_Noise = min(A1);



toc

beep


% D_avg1_clean =
% 
%      0
% 
% 
% CD_avg1_Noise =
% 
%     avg(7.4361) - max(9.0359) - min(5.2915)
% 
% 
% CD_avg2_Reverb =
% 
%     avg(6.5644) - max(8.1932) - min(4.7099)
% 
% 
% CD_avg3_Reverb_plus_noise =
% 
%     ang(7.6230) - max(8.9599) - min(5.6332)
% 
% Elapsed time is 112.352315 seconds.