clear
close all
clc

path(path,'../math');

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
Nfft = 512;
Nbin = Nfft + 1;

frameTime = Nfft/fs; % Duration of frame (Its default by Nfft but it can be
%                                         changed)
frameSize = fs * frameTime; % Frame size for STFT
freq_temp_Mic(1,:) = (0:frameSize).*fs/Nbin; % Storage of frequence of each fft domain

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
nRing = length(Theta);

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
sequence = 0:nRing-1;
disp(' ')
disp('---------------The first layer of beamforming specifications---------------')
disp(['Array specification : Spherical || Open || ', 'Radius = ' ,num2str(r), ' || Number of physical microphones: ' , num2str(nRing)])
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
%--------------------------------------------------------------------------
%% SuperDirective
selectMics = [1 2 3 4 5 6 7 8 9 10]; % Choose microphones for applying superdirective on them
nRing = length(selectMics); % Number of linear microphones or rings
c = 343; % (m/s) Sound velocity
vmNumOnRing = 8; % We have 4,8,16,32,64,100
R = 0.1; % Radius of Spherical array
fs = 16000; % Sampling frequency (Hz or sample per seconds)
Nfft = 512; % Number of fft points
Nbin = Nfft + 1; % Because in every fft we have a zero frequency so first 
%                  value of every fft belongs to DC offset. So we add one
%                  point to fft till number of points become even untill
%                  these 512 remain points become symmetric conjugate :).
frameTime = Nfft/fs; % Duration of frame (Its default by Nfft but it can be
%                                         changed)
frameSize = fs * frameTime; % Frame size for STFT
%% The position of the elevation and azimuth angles of the microphones on the array:
micWeight = ringHeight/max(ringHeight);
micPose = zeros(nRing,3);
for k = 1:nRing
    micPose(k,:) = centerPoint(selectMics(k),:);
end
centerPoint = micPose;
disp('Cartesian coordinates of selected microphones (meter)')
disp(centerPoint)
%%
freq_temp_Mic(1,:) = (0:frameSize).*fs/Nbin; % Storage of frequence of each fft domain
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

Tn = 1/fs:1/fs:nRing/fs; % Time Difference of Arrival (TDOA)
Tn = Tn - min(Tn);
Tn = Tn';

%%% Lagrange multiplier / Diagloading value / Regulator multiplier---------
Regul = 1;
disp(['Regulator multiplier = ' num2str(Regul)])

w = 2 * pi * freq_temp_Mic(1:(Nbin+1)/2); % Radial frequency (rad/s)

% Get pseudo-coherence matrix for all frequencies--------------------------
psCoher(1:length(w) ,1) = {ones(nRing,nRing)}; % All the mics data cell storage
for bin = 1:length(w)
    for chi = 1:nRing-1
        for chj = chi+1:nRing
            % in matlab: sinc(x) = sin(pi*x) / (pi*x)
            % pseudo-coherence matrix for frequency q and mic number m
            psCoher{bin,1}(chi,chj) = sinc(((w(bin)/c) * norm(micPose(chi,:)-micPose(chj,:)))/pi); 
            psCoher{bin,1}(chj,chi) = psCoher{bin,1}(chi,chj);
        end
    end
end

for h = 1:length(w)
    dw = exp(-1i * w(h) * Tn);
    W(:,h) = (inv(psCoher{h,1} + Regul * eye(nRing)) * dw) / (dw' * inv(psCoher{h,1} + Regul * eye(nRing)) * dw);
end
%% Calculating Proposed method weights
nMics = length(selectMics) * nMicOnRing;
micPose = zeros(nMics,3);

for g = 1:nRing
    micPose(nMicOnRing * (g-1) + 1 : nMicOnRing * (g-1) + nMicOnRing,:) = VMicOnRingPose{selectMics(g),1};
end
Proposed_Weight = repelem(W, nMicOnRing, 1);
clear W;
W = (1/8) * Proposed_Weight;


%% Calculate strVec for WNG metric

clear Tn
for g=1:length(micPose)
    dis(g,1) = verDis([0 0 0] ,[micPose(g,1) micPose(g,2) micPose(g,3)] ,[Xnew_source Ynew_source Znew_source]);
    Tn(g,1) = (1/c) * dis(g,1);
end
Tn = Tn - min(Tn);
for h = 1:length(w)
    dw = exp(-1i * w(h) * Tn);
    strVec(:,h) = dw;
end


%% Calculating pseudo coherence matrix for the Proposed method

psCoher_CALA(1:length(w) ,1) = {ones(nMics,nMics)}; % All the mics data cell storage
for bin = 1:length(w)
    for chi = 1:nMics-1
        for chj = chi+1:nMics
            % in matlab: sinc(x) = sin(pi*x) / (pi*x)
            % pseudo-coherence matrix for frequency q and mic number m
            psCoher_CALA{bin,1}(chi,chj) = sinc(((w(bin)/c) * norm(micPose(chi,:)-micPose(chj,:)))/pi); 
            psCoher_CALA{bin,1}(chj,chi) = psCoher_CALA{bin,1}(chi,chj);
        end
    end
end

%--------------------------------------------------------------------------
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
%            % max_values = max_values - min(max_values); % Normalize --- if you want to plot BP in dB uncomment these lines
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
    figure;
    if strcmp(plotMod, 'All')
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
%--------------------------------------------------------------------------

%% WNG plotting
Start_WNG = 0; % If 1 it means plot and if 0 it means not plot

if Start_WNG == 1

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    for j = 1:length(w)

        WNG(j) = ((abs(W(:,j)' * strVec(:,j)))^2) / (W(:,j)' * W(:,j));

    end
    plot(freq_temp_Mic(5:257),WNG(5:257))
    WNG_Proposed_Up32_R_0_1 = WNG;
    save('WNG_Proposed_Up32_R_0_1.mat', 'WNG_Proposed_Up32_R_0_1');
end

%% DF plotting
Start_DF = 1; % If 1 it means plot and if 0 it means not plot

if Start_DF == 1

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    for j = 1:length(w)

        DF(j) = ((abs(W(:,j)' * strVec(:,j)))^2) / (W(:,j)' * psCoher_CALA{j,1} * W(:,j));

    end
    plot(freq_temp_Mic(1:257),DF(1:257))

    DF_Proposed_Up16_10Ring = DF;
    save('DF_Proposed_Up16_10Ring.mat', 'DF_Proposed_Up16_10Ring');
    % save('freq_temp_Mic_up32.mat', 'freq_temp_Mic');
end

% For mostion of beam pattern :
 % % Capture the frame
           % frame = getframe(gcf);
           % im = frame2im(frame);
           % [imind, cm] = rgb2ind(im, 256);
           % 
           % % Write to the GIF file
           % if j == 1
           %    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
           % else
           %  imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
           % end

  % Add this after line 453 (draw now)
  % And Pleasedefine filename
%-----------------------------------------------------------------------