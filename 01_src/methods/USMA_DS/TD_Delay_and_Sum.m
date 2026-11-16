function [outPut] = TD_Delay_and_Sum(Speaker,selected_mics)
%% About program
% Author:      Amin Aslanzadeh
% Date:        April,2024
% Discription: This function take data thats called speaker in F1_1 or M1_1
%              form with every mics of eigenmike_em32 (spherical array) and
%              apply delay & sum beamformer on them then write output
%              automaticaly
% Contact:     Amin.Aslanzadeh.M@gmail.com
%/////////////////////////////////Manuals\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% speaker------------------------A string that includes the name of the
%                                speaker. For example:
%                                'F1_1','F1_2','M1_10','M10_6',...
% selected mics------------------A matrix of number of mics that we wanna
%                                apply BF on them. For example: [2,7,18]
% outPut-------------------------Beamformer output after deleted DC offset
%                                and normalizing
%/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%% Call functions used in the program for calculations and plots
path(path,'../data');
path(path,'../math');
path(path,'../plot');
%% Knowing the Sampling frequency and total size of Audio
Name1 = [Speaker,'_Microphone (1) Noisy Output_10(dB).wav'];
[y,~] = audioread(Name1);
%% The position of the height and azimuth angles of the microphones on the array:

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
%% Choosing mics which selected
   THETA = zeros(1,length(selected_mics));
   PHI = zeros(1,length(selected_mics));
   for k = 1 : length(selected_mics)
       THETA(1,k) = Theta(1,selected_mics(1,k));
       PHI(1,k) = Phi(1,selected_mics(1,k));
   end
   Theta = THETA;
   Phi = PHI;
%% Set up parameters : 
numMics = length(selected_mics); % Number of microphones
R = 0.042; % Radius of Spherical array
AudioSize = length (y); % Audios total size
% AudioTime = AudioSize/fs; % Duration of total audio
% t = 0:1/fs:AudioTime-1/fs; % Time vector (used just for plotting)
%-------------------------------------------
%% Delete unnecessary datas
clear y; clear fs; 
% clear Theta; clear Phi;
clear t; % Deleting data that we no longer use
%-------------------------------------------
%% Calling the output signals of the array after applying reverb and noise in the simulator
Mics = zeros(numMics,AudioSize); % Mics is matrix of Mics output
Name2 = [Speaker,'_Microphone (%d) Noisy Output_10(dB).wav'];
for q = 1:1:numMics
    wave = sprintf(Name2,selected_mics(1,q)); % wave is the name of h1 till h32 RIRs
    [Mics(q,:),Fs]=audioread(wave);
    Mics(q,:) = Mics(q,:) - mean(Mics(q,:));
    % Fs = 16000; % Sampling frequency-------
end
%% Delete unnecessary datas
clear wave; % Deleting data that we no longer use
%-------------------------------------------
%% Processing and Initialize Beamforming 

c = 343; % Speed of sound in m/s

XsphLocation = 3;
YsphLocation = 2.5;
ZsphLocation = 1.5;

xSource = 1;
ySource = 1;
zSource = 1;

Xnew_source = xSource - XsphLocation;
Ynew_source = ySource - YsphLocation;
Znew_source = zSource - ZsphLocation;

[mx,my,mz] = s2c(Theta,Phi,R);
m = [mx;my;mz];
m = m';
micPose = m;

Tn = zeros(numMics,1);
dis = zeros(numMics,1);
for g=1:numMics
    dis(g,1) = verDis([0 0 0] ,[m(g,1) m(g,2) m(g,3)] ,[Xnew_source Ynew_source Znew_source]);
    Tn(g,1) = (1/c) * dis(g,1);
end
sampDelay = Tn * Fs;

sampDelay = round(sampDelay);
sampDelay = sampDelay - min(sampDelay);
micsDelay = zeros(numMics,AudioSize); % Mics is matrix of Mics output

for q = 1:1:numMics
    micsDelay(q,:) = delayseq(Mics(q,:)',-1 * sampDelay(q,1));
end

outPut = sum(micsDelay);
outPut = outPut - mean(outPut);
outPut = outPut/max(abs(outPut));

Finshed_message = [Speaker,'_TD_Delay_and_Sum_%dmics.wav'];
Finshed_message = sprintf(Finshed_message,numMics);
disp(Finshed_message)
% audiowrite(Finshed_message,outPut,Fs)


%--------------------------------------------------------------------------
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%% Define beamformer weights

Nfft = 512;
Nbin = Nfft + 1;

frameTime = Nfft/Fs; % Duration of frame (Its default by Nfft but it can be
%                                         changed)
frameSize = Fs * frameTime; % Frame size for STFT
freq_temp_Mic(1,:) = (0:frameSize).*Fs/Nbin; % Storage of frequence of each fft domain
w = 2 * pi * freq_temp_Mic(1:(Nbin+1)/2); % Radial frequency (rad/s)

W = zeros (numMics,length(w));
for j = 1:length(w)
    for nM = 1:numMics
        W(nM,j) = (1/numMics) * exp(-1i * w(j) * Tn(nM)); % Steer vector
        strVec(nM,j) = exp(-1i * w(j) * Tn(nM));
    end
end

% Get pseudo-coherence matrix for all frequencies--------------------------
psCoher(1:length(w) ,1) = {ones(numMics,numMics)}; % All the mics data cell storage
for bin = 1:length(w)
    for chi = 1:numMics-1
        for chj = chi+1:numMics
            % in matlab: sinc(x) = sin(pi*x) / (pi*x)
            % pseudo-coherence matrix for frequency q and mic number m
            psCoher{bin,1}(chi,chj) = sinc(((w(bin)/c) * norm(micPose(chi,:)-micPose(chj,:)))/pi); 
            psCoher{bin,1}(chj,chi) = psCoher{bin,1}(chi,chj);
        end
    end
end
%--------------------------------------------------------------------------
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
       subplot(1,2,1)
       polarplot(max_values)
       title(['2D Polar Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
       pax = gca; % Get the current polar axes
       pax.RAxis.Label.String = 'Gain';
       pax.ThetaAxis.Label.String = 'Azimuth (phi) angle';

       subplot(1,2,2)
       plot(phi/pi*180,max_values)
       title(['2D Flat Beam Pattern for w = ', num2str(w(freqBin)), ' || Source SphCoordinates  : (Theta = ', num2str(sourcePose_theta/pi*180), ' , Phi = ', num2str(sourcePose_phi/pi*180 + 360) ]);
       xlabel('Azimuth (phi) angle');
       ylabel('Gain');
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
            figura = surf(X, Y, Z);
            set(figura, 'FaceColor', 'b')
            set(figura, 'EdgeAlpha', 0.2)
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
            figura = surf(X, Y, Z, 'EdgeColor', 'none');
            set(figura, 'FaceColor', 'b')
            set(figura, 'EdgeAlpha', 0.2)
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

    plot(freq_temp_Mic(1:129),WNG(1:129))
end

%% DF plotting
Start_DF = 1; % If 1 it means plot and if 0 it means not plot

if Start_DF == 1

    arrayCenter = [0 0 0]; % We moved the array to the origin center for processing tasks
    dist = norm([Xnew_source Ynew_source Znew_source]); % - arrayCenter; % distance of source frome array center.
    figure;
    for j = 1:length(w)

        DF(j) = ((abs(W(:,j)' * strVec(:,j)))^2) / (W(:,j)' * psCoher{j,1} * W(:,j));

    end
    plot(freq_temp_Mic(1:257),DF(1:257))

    DF_USMA_DS_32 = DF;
    save('DF_USMA_DS_32.mat', 'DF_USMA_DS_32');
    % save('freq_temp_Mic.mat', 'freq_temp_Mic');
end

end

