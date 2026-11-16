%% About programm
% SPHERERINGCENTERMICSYNTH
% Author:      Amin Aslanzadeh
% Date:        May,2024
% Version:     2.1.2024
% Discription: This program takes: 1- Physical microphones positions of 
%                                     spherical array in spherical 
%                                     coordintaes
%                                  2- sphere radius in m
%                                  3- Source position in cartesian
%                                  4- Signals from physical microphones
%                                  5- desired sampling frequency
%                                  6- Microphones on every ring
%              And return:         1- Center position of circular arrays or
%                                     center directional microphones
%                                  2- Resample physical microphones for
%                                     more number of rings
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
disp('MIMO Spherical Delay and Sum Beamformer (Version 2.1.2024) by Amin Aslanzadeh')
disp('Copyright (C) 2024 A. Aslanzadeh, Iran')
disp(' ')
%% Call functions used in the program for calculations and plots
path(path,'../../data');
path(path,'../../math');
path(path,'../../plot');
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
r = 0.042; % Radius of Spherical array
fsDesired = 32000; % Sampling frequency (Hz or sample per seconds)
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
    wave = sprintf('F1_1_Microphone (%d) Noisy Output_10(dB).wav',q); 
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

% origAudioSample = length(Mics); % Nsample of original audio
% upSampledMics = zeros(nMics,2*origAudioSample);
% for q = 1:1:nMics
%     upSampledMics(q,:) = resample(Mics(q,:), fsDesired, 16000);
% end
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
nRing = floor(2 * r/c * fsDesired) + 1;
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
ringRadius= zeros(1,nRing);
for q=1:nRing
    [points] = ringOnSphere(O_sphere,ringCenterPose(q,:),nMicOnRing,r); % Find position of virtual microphones of each ring
    VMicOnRingPose(q,:) = {points};
    ringRadius(1,q) = norm(points(nMicOnRing,:)-ringCenterPose(q,:));
    clear points;
end
disp('Center of rings position(x,y,z) in meter: ')
disp(ringCenterPose)
disp(['The height of each ring respectively: ', num2str(ringRadius)])
% [points] = ringOnSphere(O_sphere,ringCenterPose(1,:),8,r);

for n = 1:nRing
    [Theta_new,Phi_new,r] = c2s(VMicOnRingPose{n,1}(:,1),VMicOnRingPose{n,1}(:,2),VMicOnRingPose{n,1}(:,3));

    vmSig = virtualMic(upSampledMics,Theta_new,Phi_new);
    for m = 1:nMicOnRing
        audiowrite(['Ring',num2str(n),'_VM',num2str(m),'.wav'],vmSig(m,:),fsDesired)
    end


Output = (1/length(Theta_new)) * sum(vmSig);
audiowrite(['CenterRing',num2str(n),'_',num2str(nMicOnRing),'Mics.wav'],Output,fsDesired)
end