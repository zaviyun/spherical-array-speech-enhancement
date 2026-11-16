%% About programm
% BF_SPHERICALSUPERDIRECTIVE
% Author:      Amin Aslanzadeh
% Date:        May,2024
% Version:     1.1.2024
% Discription: This program takes: 1- microphones position in spherical
%                                     coordintaes
%                                  2- sphere radius in m
%                                  3- Source position in cartesian
%                                     coordinates
%                                  4- microphones signal
%              And return:         1- weights for each microphones for
%                                     every frequency bins
%                                  2- Apply weights on signals and write
%                                     beamforming output with or without 
%                                     any normalization
%                                  3- Plot 2D and 3D beampattern
% This program works for Nfft's which are multiple of 4 and for 50% overlap
% Contact:     Amin.Aslanzadeh.M@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
clc
disp(['Running file: ', mfilename]);
disp('Spherical Superdirective Beamformer (Version 1.1.2024) by Amin Aslanzadeh')
disp('Copyright (C) 2024 A. Aslanzadeh, Iran')
disp(' ')
%% Call functions used in the program for calculations and plots
path(path,'../data');
path(path,'../math');
path(path,'../plot');
%% Setup parameters
%%% Parameters are specific for every project

nMics = 32; % Number of microphones
c = 343; % (m/s) Sound velocity
R = 0.042; % Radius of Spherical array
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
    wave = sprintf('F1_1_Microphone (%d) Noisy Output_10(dB).wav',q); % wave is the name of h1 till h32 RIRs
    [Mics(q,:),~]=audioread(wave);
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

% Converting spherical coordinates of microphones to Cartesian coordinates-
[mx,my,mz] = s2c(Theta,Phi,R);
micPose = [mx;my;mz];
micPose = micPose';

Tn = zeros(nMics,1); % Time Difference of Arrival (TDOA)
dis = zeros(nMics,1); % The image distance of each of the microphones on 
%                         the connected line from the source of an array 
%                         center from the source
%%% For evaluating TDOA we use two method. Choose one:
% Method 1---------------------------------------------------------------
for g=1:nMics
    dis(g,1) = verDis([0 0 0] ,[micPose(g,1) micPose(g,2) micPose(g,3)] ,[Xnew_source Ynew_source Znew_source]);
    Tn(g,1) = (1/c) * dis(g,1);
end
Tn = Tn - min(Tn);
% Method 2-----------------------------------------------------------------
% [sourcePose_theta,sourcePose_phi,sourcePose_r] = c2s(Xnew_source,Ynew_source,Znew_source);
% el = sourcePose_theta;
% az = sourcePose_phi;
% dist = norm([Xnew_source Ynew_source Znew_source]);
% sourcePose = dist * [sin(el)*cos(az) sin(el)*sin(az) cos(el)];
% TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
% Tn = TDOA - min(TDOA);
%%%------------------------------------------------------------------------
% Find the closest and farthest microphone to the source-------------------
minValue = min(Tn); % Find the minimum value in the vector
minIndices = find(Tn == minValue); % Find all indices where the value equals the minimum
minIndices = reshape(minIndices, 1, []);
maxValue = max(Tn); % Find the minimum value in the vector
maxIndices = find(Tn == maxValue); % Find all indices where the value equals the minimum
maxIndices = reshape(maxIndices, 1, []);
disp(' ')
disp('---------------Beamforming Processing specifications---------------')
disp(['Closest microphone(s) : ''Mic(s) number ' num2str(minIndices)])
disp(['Farthest microphone(s) : ''Mic(s) number ' num2str(maxIndices)])

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
        micsFrame_fft_q(m,:) = MicsArray_fft{m,1}(q,:); % Put frame m of all q=4 mics in micsFrame_fft_q
    end

    for h = 1:length(w)
        dw = exp(-1i * w(h) * Tn);
        W(:,h) = (inv(psCoher{h,1} + Regul * eye(nMics)) * dw) / (dw' * inv(psCoher{h,1} + Regul * eye(nMics)) * dw);
        strVec(:,h) = dw;
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
% audiowrite('BF_SphericalSuperDirective_RT1(s)_SNR_10dB_regul0.01.wav',signal,fs)
% audiowrite('BF_SphericalSuperDirective_RT1(s)_regul0.000001.wav',signal,fs)
cep_mean= comp_cep('Clean_Signal.wav', 'BF_SphericalSuperDirective_RT1(s)_SNR_10dB_regul0.01.wav') 
fwseg_dist= comp_fwseg('Clean_Signal.wav', 'BF_SphericalSuperDirective_RT1(s)_SNR_10dB_regul0.01.wav')
%% 2D beampattern plotting_ OLD
% %%% By assuming fixed elevation (theta) angle
% Start_2D = 0; % If 1 it means plot and if 0 it means not plot
% plotType = 'polarPlot'; % plotType {'polarPlot' , 'flatPlot' , 'Off'}
% 
% if Start_2D == 1
%     % Define the azimuth (phi) angle-------------------------------------------
%     phi = linspace(0, 2*pi, 400); % for a full sphere, adjust as needed. 
%     %                               I think 400 point is enough for a clear
%     %                               figure
% 
%     % Initialize the beamPattern matrix----------------------------------------
%     beamPattern = zeros(length(w), length(phi));
% 
%     % Convert the new Cartesian coordinates of the source to spherical coordinates
%     [sourcePose_theta,~,~] = c2s(Xnew_source,Ynew_source,Znew_source);
%     theta = sourcePose_theta; % We just want to fixed elevation angle
%     arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
%     dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
% 
%     figure;
% 
%     for j = 1:length(w)
%         for p = 1:length(phi)
%             sourcePose = dist * [sin(theta)*cos(phi(p)) sin(theta)*sin(phi(p)) cos(theta)] ; % Different source positions to evaluate different TDOA for evaluation beampattern
%             % sourcePose = dist * [cos(theta)*cos(phi(p)) cos(theta)*sin(phi(p)) sin(theta)]; %+ micCenter;
%             % for g=1:nMics
%             % dis(g,1) = verDis([0 0 0] ,[micPose(g,1) micPose(g,2) micPose(g,3)] ,[sourcePose(1,1) sourcePose(1,2) sourcePose(1,3)]);
%             % TDOA(g,1) = (1/c) * dis(g,1);
%             % end
%             % TDOA = TDOA - min(TDOA);
%             TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
%             TDOA = TDOA - min(TDOA);
%             dw = exp(-1i * w(j) * TDOA);
%             beamPattern(j,p) = (abs(dw' * W(:,j)))^2;
%             % beamPattern(j,p) = max(20*log10(beamPattern(j,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
% 
%         end
%         % beamPattern(j,:) = beamPattern(j,:) / max(max(beamPattern(j,:)));
%         % beamPattern(j,:) = beamPattern(j,:) - min(beamPattern(j,:)); % Normalize --- if you want to plot BP in dB uncomment these lines
%         if strcmp(plotType, 'polarPlot')
%            % polarPlot of 2D beampattern
%            % polarplot(phi,beamPattern(j,:)+30)
%            polarplot(beamPattern(j,:))
%            title(['2D Polar Beam Pattern for w = ', num2str(w(j)), ' For theta (degree) = ', num2str(sourcePose_theta/pi*180)]);
%            pax = gca; % Get the current polar axes
%            pax.RAxis.Label.String = 'Gain';
%            pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
%         end
%         if strcmp(plotType, 'flatPlot')
%            % flatPlot of 2D beampattern
%            plot(phi/pi*180,beamPattern(j,:))
%            title(['2D Flat Beam Pattern for w = ', num2str(w(j)), ' For theta (degree) = ', num2str(sourcePose_theta/pi*180)]);
%            xlabel('Azimuth (phi) angle');
%            ylabel('Gain');
%         end
%         drawnow;
%     end
%     if strcmp(plotType, 'Off')
%        freqBin = input(['Please enter number of frequency bin from 1 to ', num2str(length(w)), ' :']);
%        subplot(1,2,1)
%        polarplot(beamPattern(freqBin,:))
%        title(['2D Polar Beam Pattern for w = ', num2str(w(freqBin)), ' For theta (degree) = ', num2str(sourcePose_theta/pi*180)]);
%        pax = gca; % Get the current polar axes
%        pax.RAxis.Label.String = 'Gain';
%        pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
% 
%        subplot(1,2,2)
%        plot(phi/pi*180,beamPattern(freqBin,:))
%        title(['2D Flat Beam Pattern for w = ', num2str(w(freqBin)), ' For theta (degree) = ', num2str(sourcePose_theta/pi*180)]);
%        xlabel('Azimuth (phi) angle');
%        ylabel('Gain');
%     end
% 
% end

% %% 2D beampattern plotting --- New
% Start_2D = 1; % If 1 it means plot and if 0 it means not plot
% plotType = 'Off'; % plotType {'polarPlot' , 'flatPlot' , 'Off'}
% 
% if Start_2D == 1
%     % Define the phi and theta angles------------------------------------------
%     phi = linspace(0, 2*pi, 200); % for a full sphere, adjust as needed. 
%     %                               I think 360 point is enough for a clear
%     %                               figure
%     theta = linspace(0, pi, 200); % for a full sphere, adjust as needed. 
%     %                               I think 360 point is enough for a clear
%     %                               figure
%     [sourcePose_theta,sourcePose_phi,~] = c2s(Xnew_source,Ynew_source,Znew_source);
%     % Initialize the beamPattern matrix------------------------------------
%     beamPattern(1:length(w) ,1) = {zeros(length(theta),length(phi))};
% 
%     arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
%     dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
%     figure;
%     if strcmp(plotType, 'polarPlot')
%        for j = 1:length(w)
%            for t = 1:length(theta)
%                for p = 1:length(phi)
%                sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
%                TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
%                TDOA = TDOA - min(TDOA);
%                dw = exp(-1i * w(j) * TDOA); % Steer vector
%                beamPattern{j,1}(t,p) = (abs(dw' * W(:,j)))^2;
%                % beamPattern{j,1}(t,p) = max(20*log10(beamPattern{j,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
%                end
%            end
%        end
% 
%        for j = 1:length(w)
%            max_values = max(beamPattern{j,1}); % By calculating the steering 
%            % vector for different theta and phi, we will have a beam for 
%            % each theta at a specific frequency, and we want to have beam
%            % for all theta to be shown in the one plot, if we plot each
%            % beampattern for each theta in one plot with hold on It will 
%            % not be interesting so the envelope of all these thetas will 
%            % drawn in the same plot for a specific frequency
% 
%            % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
% 
%            polarplot(max_values)
%            title(['2D Polar Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
%            pax = gca; % Get the current polar axes
%            pax.RAxis.Label.String = 'Gain';
%            pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
%            drawnow
%        end
%     end
% 
%     if strcmp(plotType, 'flatPlot')
%        for j = 1:length(w)
%            for t = 1:length(theta)
%                for p = 1:length(phi)
%                sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
%                TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
%                TDOA = TDOA - min(TDOA);
%                dw = exp(-1i * w(j) * TDOA); % Steer vector
%                beamPattern{j,1}(t,p) = (abs(dw' * W(:,j)));
%                % beamPattern{j,1}(t,p) = max(20*log10(beamPattern{j,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
%                end
%            end
%        end
% 
%        for j = 1:length(w)
%            max_values = max(beamPattern{j,1}); % By calculating the steering 
%            % vector for different theta and phi, we will have a beam for 
%            % each theta at a specific frequency, and we want to have beam
%            % for all theta to be shown in the one plot, if we plot each
%            % beampattern for each theta in one plot with hold on It will 
%            % not be interesting so the envelope of all these thetas will 
%            % drawn in the same plot for a specific frequency
% 
%            % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
% 
%            plot(phi/pi*180,max_values)
%            title(['2D Flat Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
%            xlabel('Azimuth (phi) angle');
%            ylabel('Gain');
%            drawnow
%        end
%     end
% 
%     if strcmp(plotType, 'Off')
%        freqBin = input(['Please enter number of frequence bin from 1 to ', num2str(length(w)), ' :']);
%        for t = 1:length(theta)
%             for p = 1:length(phi)
%                 sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
%                 TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
%                 TDOA = TDOA - min(TDOA);
%                 dw = exp(-1i * w(freqBin) * TDOA); % Steer vector
%                 beamPattern{freqBin,1}(t,p) = (abs(dw' * W(:,freqBin)))^2;
%                 % beamPattern{freqBin,1}(t,p) = max(20*log10(beamPattern{freqBin,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
%             end
%        end
%        max_values = max(beamPattern{freqBin,1}); % By calculating the steering 
%            % vector for different theta and phi, we will have a beam for 
%            % each theta at a specific frequency, and we want to have beam
%            % for all theta to be shown in the one plot, if we plot each
%            % beampattern for each theta in one plot with hold on It will 
%            % not be interesting so the envelope of all these thetas will 
%            % drawn in the same plot for a specific frequency
% 
%        % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
%        subplot(1,2,1)
%        polarplot(max_values)
%        title(['2D Polar Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
%        pax = gca; % Get the current polar axes
%        pax.RAxis.Label.String = 'Gain';
%        pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
% 
%        subplot(1,2,2)
%        plot(phi/pi*180,max_values)
%        title(['2D Flat Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
%        xlabel('Azimuth (phi) angle');
%        ylabel('Gain');
%     end
% 
% end

%% 2D beampattern plotting --- New +
Start_2D = 0; % If 1 it means plot and if 0 it means not plot
plotType = 'Off'; % plotType {'polarPlot' , 'flatPlot' , 'Off'}

if Start_2D == 1
    % Define the phi and theta angles------------------------------------------
    phi = linspace(0, 2*pi, 200); % for a full sphere, adjust as needed. 
    %                               I think 360 point is enough for a clear
    %                               figure
    theta = linspace(0, pi, 200); % for a full sphere, adjust as needed. 
    %                               I think 360 point is enough for a clear
    %                               figure
    [sourcePose_theta,sourcePose_phi,~] = c2s(Xnew_source,Ynew_source,Znew_source);

    % Create a meshgrid of phi and theta for plotting in 3D form---------------
    [Phi, Theta] = meshgrid(phi, theta);
    % Initialize the beamPattern matrix------------------------------------
    beamPattern(1:length(w) ,1) = {zeros(length(theta),length(phi))};

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    if strcmp(plotType, 'polarPlot')
       for j = 1:length(w)
           for t = 1:length(theta)
               for p = 1:length(phi)
               sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
               TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
               TDOA = TDOA - min(TDOA);
               dw = exp(-1i * w(j) * TDOA); % Steer vector
               beamPattern{j,1}(t,p) = (abs(dw' * W(:,j)))^2;
               % beamPattern{j,1}(t,p) = max(20*log10(beamPattern{j,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
               end
           end
       end
        
       for j = 1:length(w)

           X = beamPattern{j,1} .* sin(Theta) .* cos(Phi);
           Y = beamPattern{j,1} .* sin(Theta) .* sin(Phi);

           beamPat2D = sqrt(X.^2 + Y.^2); % In order to plot a 2D polar diagram, 
           % we need to look from the direction of the z axis, 
           % so we map the values ​​of the z axis on the x y plane.

           max_values = max(beamPat2D); % By calculating the steering 
           % vector for different theta and phi, we will have a beam for 
           % each theta at a specific frequency, and we want to have beam
           % for all theta to be shown in the one plot, if we plot each
           % beampattern for each theta in one plot with hold on It will 
           % not be interesting so the envelope of all these thetas will 
           % drawn in the same plot for a specific frequency
    
           % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
            
           polarplot(max_values)
           title(['2D Polar Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
           pax = gca; % Get the current polar axes
           pax.RAxis.Label.String = 'Gain';
           pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
           drawnow
       end
    end

    if strcmp(plotType, 'flatPlot')
       for j = 1:length(w)
           for t = 1:length(theta)
               for p = 1:length(phi)
               sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
               TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
               TDOA = TDOA - min(TDOA);
               dw = exp(-1i * w(j) * TDOA); % Steer vector
               beamPattern{j,1}(t,p) = (abs(dw' * W(:,j)));
               % beamPattern{j,1}(t,p) = max(20*log10(beamPattern{j,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
               end
           end
       end
        
       for j = 1:length(w)

           X = beamPattern{j,1} .* sin(Theta) .* cos(Phi);
           Y = beamPattern{j,1} .* sin(Theta) .* sin(Phi);
           
           beamPat2D = sqrt(X.^2 + Y.^2); % In order to plot a 2D polar diagram, 
           % we need to look from the direction of the z axis, 
           % so we map the values ​​of the z axis on the x y plane.
           max_values = max(beamPat2D); % By calculating the steering 
           % vector for different theta and phi, we will have a beam for 
           % each theta at a specific frequency, and we want to have beam
           % for all theta to be shown in the one plot, if we plot each
           % beampattern for each theta in one plot with hold on It will 
           % not be interesting so the envelope of all these thetas will 
           % drawn in the same plot for a specific frequency
    
           % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
            
           plot(phi/pi*180,max_values)
           title(['2D Flat Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
           xlabel('Azimuth (phi) angle');
           ylabel('Gain');
           drawnow
       end
    end

    if strcmp(plotType, 'Off')
       freqBin = input(['Please enter number of frequence bin from 1 to ', num2str(length(w)), ' :']);
       for t = 1:length(theta)
            for p = 1:length(phi)
                sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
                TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
                TDOA = TDOA - min(TDOA);
                dw = exp(-1i * w(freqBin) * TDOA); % Steer vector
                beamPattern{freqBin,1}(t,p) = (abs(dw' * W(:,freqBin)))^2;
                % beamPattern{freqBin,1}(t,p) = max(20*log10(beamPattern{freqBin,1}(t,p)),-100); % in dB --- if you want to plot BP in dB uncomment these lines
            end
       end
        % disp(beamPattern{freqBin,1})
       X = beamPattern{freqBin,1} .* sin(Theta) .* cos(Phi);
       Y = beamPattern{freqBin,1} .* sin(Theta) .* sin(Phi);

       beamPat2D = sqrt(X.^2 + Y.^2); % In order to plot a 2D polar diagram, 
           % we need to look from the direction of the z axis, 
           % so we map the values ​​of the z axis on the x y plane.
       max_values = max(beamPat2D); % By calculating the steering 
           % vector for different theta and phi, we will have a beam for 
           % each theta at a specific frequency, and we want to have beam
           % for all theta to be shown in the one plot, if we plot each
           % beampattern for each theta in one plot with hold on It will 
           % not be interesting so the envelope of all these thetas will 
           % drawn in the same plot for a specific frequency

           % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
       % subplot(1,2,1)
       polarplot(max_values)
       title(['2D Polar Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
       pax = gca; % Get the current polar axes
       pax.RAxis.Label.String = 'Gain';
       pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';

       % subplot(1,2,2)
       % plot(phi/pi*180,max_values)
       % title(['2D Flat Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
       % xlabel('Azimuth (phi) angle');
       % ylabel('Gain');
    end

end


%% 3D beampattern plotting
Start_3D = 0; % If 1 it means plot and if 0 it means not plot
plotMod = 'One'; % plotMod {'All' , 'One'}
%                  All: Animated 3D beampattern plot for all frequency. It
%                       is not recommended because needs more time. If you 
%                       choose, you have to wait for about 3-4 minutes
%                  One: Just 3D beampattern plot for One frequency bin. You
%                       must choose number of bin

if Start_3D == 1
    % Define the phi and theta angles------------------------------------------
    phi = linspace(0, 2*pi, 200); % for a full sphere, adjust as needed. 
    %                               I think 360 point is enough for a clear
    %                               figure
    theta = linspace(0, pi, 200); % for a full sphere, adjust as needed. 
    %                               I think 360 point is enough for a clear
    %                               figure
    
    % Create a meshgrid of phi and theta for plotting in 3D form---------------
    [Phi, Theta] = meshgrid(phi, theta);
    
    % Initialize the beamPattern matrix----------------------------------------
    beamPattern(1:length(w) ,1) = {zeros(length(theta),length(phi))};
    
    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    if strcmp(plotMod, 'All')
       figure;
        for j = 1:length(w)
            for t = 1:length(theta)
                for p = 1:length(phi)
                sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
                TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
                TDOA = TDOA - min(TDOA);
                dw = exp(-1i * w(j) * TDOA); % Steer vector
                beamPattern{j,1}(t,p) = (abs(dw' * W(:,j)))^2;
                end
            end
           
        end
        % beamPattern{j,1} = beamPattern{j,1} / max(max(beamPattern{j,1}));
        for j = 1:length(w)
        
            % Convert to Cartesian coordinates for plotting
            X = beamPattern{j,:} .* sin(Theta) .* cos(Phi);
            Y = beamPattern{j,:} .* sin(Theta) .* sin(Phi);
            Z = beamPattern{j,:} .* cos(Theta);
        
            % Plot the 3D beam pattern
            figure = surf(X, Y, Z);
            set(figure, 'FaceColor', 'b')
            set(figure, 'EdgeAlpha', 0.2)
            title(['3D Beam Pattern for w = ', num2str(w(j))]);
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            light('Position',[0 0 1],'Style','infinite');
            light('Position',[-1 -1 -1],'Style','infinite');
            light('Position',[0 0 -1],'Style','infinite');
            material shiny
            axis equal
            % grid
        
            drawnow; % Update the plot at a limited rate for smoother animation
        end
    end
    if strcmp(plotMod, 'One')
        figure;
        freqBin = input(['Please enter number of frequence bin from 1 to ', num2str(length(w)), ' :']);
        for t = 1:length(theta)
            for p = 1:length(phi)
                sourcePose = dist * [sin(theta(t))*cos(phi(p)) sin(theta(t))*sin(phi(p)) cos(theta(t))] ; % Different source positions to evaluate different TDOA for evaluation beampattern
                TDOA = sqrt(sum((bsxfun(@minus, sourcePose, micPose)).^2, 2))/c;
                TDOA = TDOA - min(TDOA);
                dw = exp(-1i * w(freqBin) * TDOA); % Steer vector
                beamPattern{freqBin,1}(t,p) = (abs(dw' * W(:,freqBin)))^2;

            end
        end
        % beamPattern{freqBin,1} = beamPattern{freqBin,1} / max(max(beamPattern{freqBin,1}));
            % Convert to Cartesian coordinates for plotting
            X = beamPattern{freqBin,:} .* sin(Theta) .* cos(Phi);
            Y = beamPattern{freqBin,:} .* sin(Theta) .* sin(Phi);
            Z = beamPattern{freqBin,:} .* cos(Theta);
        
            % Plot the 3D beam pattern
            figure = surf(X, Y, Z, 'EdgeColor', 'none');
            set(figure, 'FaceColor', 'b')
            set(figure, 'EdgeAlpha', 0.2)
            title(['3D Beam Pattern for w = ', num2str(w(freqBin))]);
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            light('Position',[0 0 1],'Style','infinite');
            light('Position',[-1 -1 -1],'Style','infinite');
            light('Position',[0 0 -1],'Style','infinite');
            material shiny
            axis equal
            view(-10,10)
            % grid
    end
end

%% WNG plotting
Start_WNG = 0; % If 1 it means plot and if 0 it means not plot

if Start_WNG == 1

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    for j = 1:length(w)

        WNG(j) = ((abs(W(:,j)' * strVec(:,j)))^2) / (W(:,j)' * W(:,j));

    end
    plot(freq_temp_Mic(1:129),WNG(1:129))

    WNG_USMA_SD_23 = WNG;
    save('WNG_USMA_SD_23.mat', 'WNG_USMA_SD_23');
    save('freq_temp_Mic.mat', 'freq_temp_Mic');
end

%% DF plotting
Start_DF = 0; % If 1 it means plot and if 0 it means not plot

if Start_DF == 1

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    for j = 1:length(w)

        DF(j) = ((abs(W(:,j)' * strVec(:,j)))^2) / (W(:,j)' * psCoher{j,1} * W(:,j));

    end
    plot(freq_temp_Mic(1:257),DF(1:257))

    DF_USMA_SD_32 = DF;
    save('DF_USMA_SD_32.mat', 'DF_USMA_SD_32');
    % save('freq_temp_Mic.mat', 'freq_temp_Mic');
end
