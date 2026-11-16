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
r = 0.042; % Radius of Spherical array
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
nMics = length(Theta);

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

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%%
%% Delay&Sum beamformer
% Here I just wanna choose one ring and plot beampattern for that ring. 

% Choose Ring Number: (just change this)
ringInd = 3;

% Ring center--------------------------------------------------------------
XsphLocation = centerPoint(ringInd,1);
YsphLocation = centerPoint(ringInd,2);
ZsphLocation = centerPoint(ringInd,3);

% Transfer the desired_Ring to the coordinate origin--------------------
Xnew_source = Xnew_source - XsphLocation;
Ynew_source = Ynew_source - YsphLocation;
Znew_source = Znew_source - ZsphLocation;

% Transfer virtual microphones posintion on ring base on center on the ring
% which is now on origin
micPose = zeros(nMicOnRing,3);
micPose(:,1) = VMicOnRingPose{ringInd,1}(:,1) - XsphLocation;
micPose(:,2) = VMicOnRingPose{ringInd,1}(:,2) - YsphLocation;
micPose(:,3) = VMicOnRingPose{ringInd,1}(:,3) - ZsphLocation;

Tn = zeros(8,1); % Time Difference of Arrival (TDOA)
dis = zeros(8,1); % The image distance of each of the microphones on 
%                         the connected line from the source of an array 
%                         center from the source
%%% For evaluating TDOA we use two method. Choose one:
% Method 1---------------------------------------------------------------
for g=1:8
    dis(g,1) = verDis([0 0 0] ,[micPose(g,1) micPose(g,2) micPose(g,3)] ,[Xnew_source Ynew_source Znew_source]);
    Tn(g,1) = (1/c) * dis(g,1);
end
Tn = Tn - min(Tn);
w = 2 * pi * freq_temp_Mic(1:(Nbin+1)/2); % Radial frequency (rad/s)
%% Define beamformer weights
W = (1/nMicOnRing) * ones(nMicOnRing,length(w));


%% 2D beampattern plotting --- New
Start_2D = 1; % If 1 it means plot and if 0 it means not plot
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
               % beamPattern{j,1}(t,:) = beamPattern{j,1}(t,:) - min(beamPattern{j,1}(t,:)); % Normalize --- if you want to plot BP in dB uncomment these lines
               polarplot(beamPattern{j,1}(t,:))
               title(['2D Polar Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
               pax = gca; % Get the current polar axes
               pax.RAxis.Label.String = 'Gain';
               pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
               hold on
           end
           drawnow
           hold off
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
               % beamPattern{j,1}(t,:) = beamPattern{j,1}(t,:) - min(beamPattern{j,1}(t,:)); % Normalize --- if you want to plot BP in dB uncomment these lines
               plot(phi/pi*180,beamPattern{j,1}(t,:))
               title(['2D Flat Beam Pattern for w = ', num2str(w(j)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
               xlabel('Azimuth (phi) angle');
               ylabel('Gain');
               hold on
           end
           drawnow
           hold off
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
            % beamPattern{freqBin,1}(t,:) = beamPattern{freqBin,1}(t,:) - min(beamPattern{freqBin,1}(t,:)); % Normalize --- if you want to plot BP in dB uncomment these lines
            subplot(1,2,1)
            polarplot(beamPattern{freqBin,1}(t,:))
            title(['2D Polar Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
            pax = gca; % Get the current polar axes
            pax.RAxis.Label.String = 'Gain';
            pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';
            hold on

            subplot(1,2,2)
            plot(phi/pi*180,beamPattern{freqBin,1}(t,:))
            title(['2D Flat Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
            xlabel('Azimuth (phi) angle');
            ylabel('Gain');
            hold on
       end
       hold off
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
            figure = surf(X, Y, Z);
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
            % grid
    end
end
%--------------------------------------------------------------------------


