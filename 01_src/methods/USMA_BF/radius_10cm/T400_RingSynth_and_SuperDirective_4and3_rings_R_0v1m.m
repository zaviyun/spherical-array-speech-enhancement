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
path(path,'../data_R0.1m');
path(path,'../math');
saveDir = '..\Linear Ring_Synth_DlaySum_Superdirective_Without_WPE_R0.1m\';

        person = ['M_',num2str(speak),'_',num2str(senten),'_']
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
r = 0.1; % Radius of Spherical array
fs = 16000; % Sampling frequency (Hz or sample per seconds)
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
    wave = sprintf('M%d_%d_Microphone (%d) Noisy Output_10(dB)_0v1.wav',speak,senten,q); 
    [Mics(q,:),~]=audioread(wave);
    Mics(q,:) = Mics(q,:) - mean(Mics(q,:));
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
sampDelay = Tn * fs; % Convert Time Difference of Arrival (TDOA) of the sound 
%                      from the source to the surface of the array into the 
%                      number of samples that correspond to this time delay
%                      (synchronizing the signals received by the microphones 
%                      in the spherical array during the beamforming process)

% Calculate the number of rings allowed without system error---------------
nRing = floor(2 * r/c * fs) + 1;
nRing = nRing -1;
sequence = 0:nRing-1;
disp(' ')
disp('---------------The first layer of beamforming specifications---------------')
disp(['Array specification : Spherical || Open || ', 'Radius = ' ,num2str(r), ' || Number of physical microphones: ' , num2str(nMics)])
disp(['Number of rings allowed: ' num2str(nRing) ' || with delays respectively: ' num2str(sequence)])

%%
ringCenterDis = zeros(nRing,1); % Define matrix for distance of the center of rings from the source
ringCenterPose = zeros(nRing,3); % Define matrix for coordinates of the center of rings
for q=1:nRing
ringCenterDis(q,1) = (c/fs) * (ceil(sampDelay) + q-1); % Find the distance of the center of each ring from the source
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
% [points] = ringOnSphere(O_sphere,ringCenterPose(1,:),8,r);

for n = 1:nRing
    [Theta_new,Phi_new,r] = c2s(VMicOnRingPose{n,1}(:,1),VMicOnRingPose{n,1}(:,2),VMicOnRingPose{n,1}(:,3));

    vmSig = virtualMic(Mics,Theta_new,Phi_new);

    Output = (1/length(Theta_new)) * sum(vmSig); % Output of each rings after Delay & Sum
    audiowrite([saveDir,'CenterRing',num2str(n),'_',num2str(nMicOnRing),'Mics','_R0.1m.wav'],Output,fs)
end







clearvars -except saveDir  centerPoint ringHeight speak senten person

disp(['Running file: ', mfilename]);
disp('Linear Superdirective Beamformer (Version 1.1.2024) by Amin Aslanzadeh')
disp('Copyright (C) 2024 A. Aslanzadeh, Iran')
disp(' ')
%% Call functions used in the program for calculations and plots
path(path,'../math');
path(path,'../Linear Ring_Synth_DlaySum_Superdirective_Without_WPE_R0.1m/')
%% Setup parameters
selectMics = [2 3 4 5 6 7 8]; % Choose microphones for applying superdirective on them
nMics = length(selectMics); % Number of linear microphones or rings
c = 343; % (m/s) Sound velocity
vmNumOnRing = 8; % We have 4,8,16,32,64,100
R = 0.1; % Radius of Spherical array
fs = 16000; % Sampling frequency (Hz or sample per seconds)
Nfft = 512; % Number of fft points
overlap= 0.5; % Overlap between frames
%--------------------------------------------------------------------------
if Nfft ~= 4*floor(Nfft/4), error('Nfft must be a multiple of 4.'); end
Nbin = Nfft + 1; % Because in every fft we have a zero frequency so first 
%                  value of every fft belongs to DC offset. So we add one
%                  point to fft till number of points become even untill
%                  these 512 remain points become symmetric conjugate :).
frameTime = Nfft/fs; % Duration of frame (Its default by Nfft but it can be
%                                         changed)
frameSize = fs * frameTime; % Frame size for STFT

for q = 1:1:nMics % It should be changed based on the name of the signals of each of the microphones
    wave = sprintf('CenterRing%d_%dMics_R0.1m.wav',selectMics(q),vmNumOnRing); % wave is the name of h1 till h32 RIRs
    [Mics(q,:),~]=audioread(wave);
    Mics(q,:) = Mics(q,:) - mean(Mics(q,:));
end

AudioSize = length(Mics); % Every mics size
AudioTime = AudioSize/fs; % Every mics time

disp('---------------STFT Processing specifications---------------')
disp(['MicSignalsTime  = ' num2str(AudioTime) ' ' '(s)'])
disp(['MicSignalSize  = ' num2str(AudioSize) ' ' '(samples)'])
disp(['frameTime = ' num2str(frameTime) ' ' '(s)'])
disp(['frameSize = ' num2str(frameSize) ' ' '(samples)'])
disp(['Overlap = ' num2str(overlap * 100) ' ' '(%)'])
%--------------------------------------------------------------------------
%% The position of the elevation and azimuth angles of the microphones on the array:
micWeight = ringHeight/max(ringHeight);
micPose = zeros(nMics,3);
for k = 1:nMics
    micPose(k,:) = centerPoint(selectMics(k),:);
end
centerPoint = micPose;
disp('Cartesian coordinates of selected microphones (meter)')
disp(centerPoint)
%% STFT processing
%-------------------------------------------
% Because we want to process any frameSize with any AudioSize, numFrames
% must be intiger so when it is not intiger, we must add some zero or zero
% padding to signal, so the time of signal will increase a few seconds
if rem(AudioSize,frameSize) == 0 % It means that number of frames is intiger :)
    numFrames = AudioSize/frameSize; % Number of frames to process-----
    tempMic = zeros(2*numFrames-1,frameSize); % Srorages of frames
    temp_fft_Mic = zeros(2*numFrames-1,Nbin); % Srorages of fft domains
    freq_temp_Mic(1,:) = (0:frameSize).*fs/Nbin; % Storage of frequence of each fft domain
    MicsArray_data(1:nMics ,1) = {zeros(2*numFrames-1,frameSize)}; % All the mics data cell storage
    MicsArray_fft(1:nMics ,1) = {zeros(2*numFrames-1,Nbin)}; % All the mics fft data storage
    %-------------------------------------------
%---------Start Signal Processing (Initialize STFT)----------
for q = 1:1:nMics
    for i = 1:1:2*numFrames-1
        tempMic(i,:) = Mics(q,frameSize*(i-1)*overlap+1:frameSize*(i-1)*overlap+frameSize); % Embed Mic(q) frames into tempMic
        tempMic(i,:) = tempMic(i,:).* hamming(frameSize)'; % Putting a Hamming window on the Mic(q) signal
        temp_fft_Mic(i,:) = fft(tempMic(i,:),Nbin); % Taking the Fourier transform of the frames of Mic(i)
        t1 = frameTime*(i-1):1/fs:frameTime*i-1/fs; % Time of every frame (used just for plotting)
    end
    MicsArray_data(q,:) = {tempMic}; % All of the datas of all Mics with their frames are in this cell
    MicsArray_fft(q,:) = {temp_fft_Mic}; % All of the fft datas of all Mics with their frames are in this cell
    tempMic = zeros(2*numFrames-1,frameSize); % Clean temMic for next Mic process
    temp_fft_Mic = zeros(2*numFrames-1,Nbin); % Clean temp_fft_Mic for next Mic process
end

else % It means that number of frames is not intiger
    numFrames = AudioSize/frameSize; % Number of frames which are non intiger
    numFrames1 = ceil(numFrames); %To render an non intiger number of frames (for exmaple 42.2 -> 43 or 23.7 -> 24)
    % numFrames1 is number of frames which are intiger now
    Zero_Adding = ceil((numFrames1 - numFrames)* frameSize); % Calculate number of zeros that we must add to every mic signal
    Zero_Padding = zeros(nMics,Zero_Adding + 1); % Creat zeros matrix for adding to 32 mics signals
    Mics = cat(2,Mics,Zero_Padding); % Add zeros to Mics and now here samples of Mics changed because of concatenating zeros to Mics signals
    numFrames = numFrames1; % By adding zeros to Mics, number of frames will changed
    AudioSize = numFrames * frameSize; % By adding zeros to Mics, number of samples of every Mics will changed
    tempMic = zeros(2*numFrames-1,frameSize); % Srorages of frames
    temp_fft_Mic = zeros(2*numFrames-1,Nbin); % Srorages of fft domains
    freq_temp_Mic(1,:) = (0:frameSize).*fs/Nbin; % Storage of frequence of each fft domain
    MicsArray_data(1:nMics ,1) = {zeros(2*numFrames-1,frameSize)}; % All the mics data cell storage
    MicsArray_fft(1:nMics ,1) = {zeros(2*numFrames-1,frameSize)}; % All the mics fft data storage
     %-------------------------------------------
%---------Start Signal Processing (Initialize STFT)----------
for q = 1:1:nMics
    for i = 1:1:2*numFrames-1
        tempMic(i,:) = Mics(q,frameSize*(i-1)*overlap+1:frameSize*(i-1)*overlap+frameSize); % Embed Mic(q) frames into tempMic
        tempMic(i,:) = tempMic(i,:).* hamming(frameSize)'; % Putting a Hamming window on the Mic(q) signal
        temp_fft_Mic(i,:) = fft(tempMic(i,:),Nbin); % Taking the Fourier transform of the frames of Mic(i)
        t1 = frameTime*(i-1):1/fs:frameTime*i-1/fs; % Time of every frame (used just for plotting)
    end
    MicsArray_data(q,:) = {tempMic}; % All of the datas of all Mics with their frames are in this cell
    MicsArray_fft(q,:) = {temp_fft_Mic}; % All of the fft datas of all Mics with their frames are in this cell
    tempMic = zeros(2*numFrames-1,frameSize); % Clean temMic for next Mic process
    temp_fft_Mic = zeros(2*numFrames-1,Nbin); % Clean temp_fft_Mic for next Mic process
end
end
disp(['Number of frames with overlap = ' num2str(numFrames) ' ||' ' With 50% overlap = ' num2str(2*numFrames-1) ] )
%% Delete unnecessary datas
clear tempMic; clear temp_fft_Mic; clear t1; % Deleting data that we no longer use
%-------------------------------------------
%% Superdirective beamformer
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

Tn = 1/fs:1/fs:nMics/fs; % Time Difference of Arrival (TDOA)
Tn = Tn - min(Tn);
Tn = Tn';

%%% Lagrange multiplier / Diagloading value / Regulator multiplier---------
Regul = 1;
disp(['Regulator multiplier = ' num2str(Regul)])

w = 2 * pi * freq_temp_Mic(1:(Nbin+1)/2); % Radial frequency (rad/s)

% Get pseudo-coherence matrix for all frequencies--------------------------
psCoher(1:length(w) ,1) = {ones(nMics,nMics)}; % All the mics data cell storage
for bin = 1:length(w)
    for chi = 1:nMics-1
        for chj = chi+1:nMics
            % in matlab: sinc(x) = sin(pi*x) / (pi*x)
            % pseudo-coherence matrix for frequency q and mic number m
            psCoher{bin,1}(chi,chj) = sinc(((w(bin)/c) * norm(micPose(chi,:)-micPose(chj,:)))/pi); 
            psCoher{bin,1}(chj,chi) = psCoher{bin,1}(chi,chj);
        end
    end
end
%--------------------------------------------------------------------------
micsFrame_fft_q = zeros(nMics,Nbin); % Storage of fft values of each frames of all mics for example frame 1 for all 32 mics
BFoutPutFrames = zeros(2*numFrames-1,frameSize); % Storage of frames of beamformer output that must use Overlap Add (OLA) method on it

% Compute beamforming matrix
for q = 1:1:2*numFrames-1

    clear W;

    for m =1:1:nMics
        % micsFrame_fft_q(m,:) = micWeight(1,m) * MicsArray_fft{m,1}(q,:); % Put frame m of all q=4 mics in micsFrame_fft_q --- Use this for weighting
        micsFrame_fft_q(m,:) = MicsArray_fft{m,1}(q,:); % Put frame m of all q=4 mics in micsFrame_fft_q
    end

    for h = 1:length(w)
        dw = exp(-1i * w(h) * Tn);
        W(:,h) = (inv(psCoher{h,1} + Regul * eye(nMics)) * dw) / (dw' * inv(psCoher{h,1} + Regul * eye(nMics)) * dw);
    end
    
    bfSig_fft = conj(W) .* micsFrame_fft_q(:,1:length(w));
    A = [bfSig_fft,fliplr(conj(bfSig_fft(:,2:length(w))))];
    B = real(ifft(sum(A)));
    BFoutPutFrames(q,:) = B(1:frameSize);

end

% Initialize the output signal
signal = zeros(1, AudioSize);

% Overlap-add the frames (OLA method)
for i = 1:2*numFrames-1
    startIdx = (i-1)*frameSize/2 + 1;
    endIdx = startIdx + frameSize - 1;
    signal(startIdx:endIdx) = signal(startIdx:endIdx) + BFoutPutFrames(i, :);
end
% signal = signal - mean(signal);
% signal = signal/max(abs(signal)); % We normalize beamformer output for comparison
audiowrite([saveDir,person,'BF_LinearSuperDirective_',num2str(nMics),'mics_RT1(s)_SNR_10dB_regul',num2str(Regul),'_R0.1m.wav'],signal,fs)
clearvars -except saveDir  centerPoint ringHeight speak senten person
    end
end
beep