%% About programm
% SPHERERINGCENTERMICSYNTH
% Author:      Amin Aslanzadeh
% Date:        May,2024
% Version:     1.1.2024
% Discription: This program takes: 1- Physical microphones positions of 
%                                     spherical array in spherical 
%                                     coordintaes
%                                  2- sphere radius in m
%                                  3- Source position in cartesian
%                                  4- Signals from physical microphones
%                                  5- Microphones on every ring
%              And return:         1- Center position of circular arrays or
%                                     center directional microphones
%                                  2- The position of the microphones 
%                                     formed on each ring
%                                  3- The height of each ring
%                                  4- Virtual signals from microphones 
%                                     formed on each ring
%                                  5- Virtual pseudo-directional microphone
%                                     signals created after applying delay 
%                                     and sum beamformer on every ring
% This program is not a function
% Contact:     Amin.Aslanzadeh.M@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
disp(['Running file: ', mfilename]);
disp('MIMO Spherical Delay and Sum Beamformer (Version 1.1.2024) by Amin Aslanzadeh')
disp('Copyright (C) 2024 A. Aslanzadeh, Iran')
disp(' ')

%% Call functions used in the program for calculations and plots
for speak = 1:20
    for senten = 1:10
        clc
% path(path,'../data');
path(path,'D:/ARTICLE/math');
path(path,'D:/ARTICLE/10CM/Microphone  Noisy Output_0v1');
path(path,'D:/ARTICLE/10CM/Microphone_ Output_0v1');

path(path,'D:/ARTICLE/WPE_FDNPL/fdnpwpe') %************************************************************************************************
path(path,'D:/ARTICLE/WPE_FDNPL/fdnpwpe/lib') %************************************************************************************************
path(path,'D:/ARTICLE/10CM-T400_RingSynth_withJustWPE_R_0v1_16rings_Upsampling_16Input_1Output_Final2micsDeleted') %************************************************************************************************

saveDir = 'D:\ARTICLE\10CM-T400_RingSynth_withJustWPE_R_0v1_16rings_Upsampling_16Input_1Output_Final2micsDeleted\'; %************************************************************************************************

        person = ['M',num2str(speak),'_',num2str(senten),'_'] %************************************************************************************************
%% The position of the elevation and azimuth angles of the physical microphones on the array:
Theta = [23*pi/60,...
         pi/2,...
         37*pi/60,...
         pi/2,...
         8*pi/45,...
         11*pi/36,...
         pi/2,...
         25*pi/36,...
         37*pi/45,...
         25*pi/36,...
         pi/2,...
         11*pi/36,...
         7*pi/60,...
         29*pi/90,...
         121*pi/180,...
         53*pi/60,...
         23*pi/60,...
         pi/2,...
         37*pi/60,...
         pi/2,...
         8*pi/45,...
         11*pi/36,...
         pi/2,...
         25*pi/36,...
         37*pi/45,...
         25*pi/36,...
         pi/2,...
         11*pi/36,...
         7*pi/60,...
         29*pi/90,...
         61*pi/90,...
         53*pi/60];
Phi = [0,...
       8*pi/45,...
       0,...
       82*pi/45,...
       0,...
       pi/4,...
       23*pi/60,...
       pi/4,...
       0,...
       7*pi/4,...
       97*pi/60,...
       7*pi/4,...
       91*pi/180,...
       pi/2,...
       pi/2,...
       89*pi/180,...
       pi,...
       53*pi/45,...
       pi,...
       37*pi/45,...
       pi,...
       5*pi/4,...
       83*pi/60,...
       5*pi/4,...
       pi,...
       3*pi/4,...
       37*pi/60,...
       3*pi/4,...
       269*pi/180,...
       3*pi/2,...
       3*pi/2,...
       271*pi/180];

%% Setup parameters
%%% Parameters are specific for every project

c = 343; % Speed of sound in m/s
r = 0.1; % Radius of Spherical array %************************************************************************************************
fsDesired = 32000; % Sampling frequency (Hz or sample per seconds)
reffs = 16000;
nMicOnRing = 8; % Number of microphones on every rings
%--------------------------------------------------------------------------
% Spherical array center in room-------------------------------------------
XsphLocation = 3;
YsphLocation = 2.5;
ZsphLocation = 1.5;

% Source position----------------------------------------------------------
xSource = 1;
ySource = 1;
zSource = 1;

% Transfer the spherical array to the coordinate origin--------------------
Xnew_source = xSource - XsphLocation;
Ynew_source = ySource - YsphLocation;
Znew_source = zSource - ZsphLocation;
Snew_source = [Xnew_source , Ynew_source , Znew_source];
O_sphere = [0,0,0]; % The center of the array
% Import physical microphones signal---------------------------------------
nMics = length(Theta);
for q = 1:1:nMics % It should be changed based on the name of the signals of each of the microphones
    wave = sprintf('M%d_%d_Microphone (%d) Noisy Output_10(dB).wav',speak,senten,q); %************************************************************************************************
    [Mics(q,:),~]=audioread(wave);
    Mics(q,:) = Mics(q,:) - mean(Mics(q,:));
end

% Resampling microphone signals based on the desired sampling frequency----
origAudioSample = length(Mics); % Nsample of original audio
upSampledMics = zeros(nMics,2*origAudioSample-1);
for q = 1:1:nMics
    upSampledMics(q,1:2:end) = Mics(q,:);
    for g = 1:2:(2*origAudioSample - 3)
        upSampledMics(q,g + 1) = (upSampledMics(q,g) + upSampledMics(q,g + 2))/2;
    end
end

%--------------------------------------------------------------------------
%        -Spherical Array-
%            ******* 
%        *             *               
%      *                 *             
%     *                   *           
%    *           O........A*............S.............
%     *           ___r___ *            
%      *                 *             
%        *             *               
%            *******
%
OS = norm(Snew_source - O_sphere); % The distance between the source and the center of the array
AS = OS - r; % The distance between the source and the surface of the array
Tn = (1/c) * AS; % TDOA from source to the surface of the array
sampDelay = Tn * fsDesired; % Convert Time Difference of Arrival (TDOA) of the sound 
%                      from the source to the surface of the array into the 
%                      number of samples that correspond to this time delay
%                      (synchronizing the signals received by the microphones 
%                      in the spherical array during the beamforming process)

% Calculate the number of rings allowed without system error---------------
nRing = floor(2 * r/c * fsDesired) + 1; % For R = 0.1 --> nRing = floor(2 * r/c * fs)
sequence = 0:nRing-1;
disp(' ')
disp('---------------The first layer of beamforming specifications---------------')
disp(['Array specification : Spherical || Open || ', 'Radius = ' ,num2str(r), ' || Number of physical microphones: ' , num2str(nMics)])
disp(['Number of rings allowed: ' num2str(nRing) ' || with delays respectively: ' num2str(sequence)])


%%
ringCenterDis = zeros(nRing,1); % Define matrix for distance of the center of rings from the source
ringCenterPose = zeros(nRing,3); % Define matrix for coordinates of the center of rings
for q=1:nRing
ringCenterDis(q,1) = (c/fsDesired) * (ceil(sampDelay) + q-1); % Find the distance of the center of each ring from the source
ringCenterPose(q,:) = coordPoint(Snew_source,O_sphere,ringCenterDis(q,1)); % Find the Cartesian coordinates of the center of each ring
end
%%
VMicOnRingPose(1:nRing,1)={zeros(nMicOnRing,3)}; % Define matrix for coordinates of virtual microphones of each ring
ringHeight = zeros(1,nRing);
for q=1:nRing
    [points] = ringOnSphere(O_sphere,ringCenterPose(q,:),nMicOnRing,r); % Find position of virtual microphones of each ring
    VMicOnRingPose(q,:) = {points};
    ringHeight(1,q) = norm(points(nMicOnRing,:)-ringCenterPose(q,:));
    clear points;
end
disp('Center of rings position(x,y,z) in meter: ')
disp(ringCenterPose)
disp(['The height of each ring respectively: ', num2str(ringHeight)])
centerPoint = ringCenterPose;
 % stop
save('centerPoint_0v1_Upsampling.mat', 'centerPoint'); %************************************************************************************************

% [points] = ringOnSphere(O_sphere,ringCenterPose(1,:),8,r);

% Without upsampling, the number of rings with a 10 cm radius was initially 10. However, the 10th ring was excluded due to computational errors, leaving us with rings 1 through 9 in practice. Since we always remove the first and last rings, we eliminated rings 1 and 9 here as well, ultimately retaining 7 rings.
% After upsampling to 32 kHz, the number of rings increased to 19. Since the final ring was slightly misaligned, it was also removed, leaving us with 18 rings. Again, because we discard the first and last rings, only rings 2 through 16 remained.
% An additional reason for this step was our use of a 4-point WPE (Weighted Prediction Error)—chosen because it yields the best results. If the 18th ring were included, the final WPE segment would consist of 5 points, which could negatively impact the outcome.
for n = 2:nRing - 2 %************************************************************************************************
    [Theta_new,Phi_new,r] = c2s(VMicOnRingPose{n,1}(:,1),VMicOnRingPose{n,1}(:,2),VMicOnRingPose{n,1}(:,3));

    vmSig = virtualMic(upSampledMics,Theta_new,Phi_new);

    Output(:,n-1) = (1/length(Theta_new)) * sum(vmSig); % Output of each rings after Delay & Sum
    
end
audiowrite([saveDir,person,num2str(n-1),'CenterMics_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_',num2str(nMicOnRing),'MicsOnRing_Upsampling.wav'],Output(:,1:16),fsDesired) %************************************************************************************************

clearvars -except saveDir  centerPoint ringHeight speak senten person reffs


output_dir = saveDir;
if ~exist(output_dir, 'dir')
   mkdir(output_dir); 
   disp(['mkdir ', output_dir])
end

%******************************************************
% Input and Output Configurations 
%******************************************************

filepath = 'D:\ARTICLE\10CM-T400_RingSynth_withJustWPE_R_0v1_16rings_Upsampling_16Input_1Output_Final2micsDeleted\'; %************************************************************************************************
sample_name = sprintf('M%d_%d_16CenterMics_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_8MicsOnRing_Upsampling.wav',speak,senten); %************************************************************************************************
file_name = [filepath, sample_name];
out_name = [output_dir, ['drv_', sample_name]];

%******************************************************
% Set Parameters
%******************************************************
% cfgs.num_mic = 3;
% cfgs.num_out = 2;
% cfgs.K = 512;                               % the number of subbands
% cfgs.F = 2;                                 % over-sampling rate
% cfgs.N = cfg.K / cfg.F;                     % decimation factor
% cfgs.D1 = 2;                                % subband preditction delay                     
% cfgs.Lc1 = 30;                              % subband prediction order 
% cfgs.eps = 1e-4;                            % lower bound of rho(Normalizaton factor)
% cfgs.iterations = 2;

cfgs = 'config1.m'; %************************************************************************************************


%******************************************************
% Read Audio Files and Processing
%******************************************************
sig_multi_mode = 1;
% sig_multi_mode = 0;
% sig_num_mic = 3;
disp('Reading Audio Files:')
if sig_multi_mode
    disp(file_name)
    [x, fs] = audioread(file_name);
else
    x = [];
    for m = 1 : sig_num_mic
        disp(file_name)
        filename1 = strrep(file_name, 'ch1', ['ch',num2str(m)]);
        [s, fs] = audioread(filename1);
        x = [x, s];
    end
end

y1 = fdndlp(x, cfgs); %************************************************************************************************

disp(['write to file:',32, out_name])
% audiowrite(out_name, y/max(max(abs(y))), fs);
downsampledSignal = downsample(y1, fs / reffs);
audiowrite(out_name, downsampledSignal, reffs);
% rmpath(genpath('lib'));
clearvars -except saveDir  centerPoint ringHeight speak senten person 

    end
end
beep