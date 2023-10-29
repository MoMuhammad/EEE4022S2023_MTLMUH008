function [] = Processor(wavFile, varargin)

% Produces a DTI (Doppler x time intensity) image of the
% cantenna recording. Assumes the data is collected with
% the radar in a continuous wave (CW) mode. See inside
% the function for more parameters.
%
%    wavFile = the filename of the .WAV file to process
%    varargin determines km/hr or m/s. Default is set to m/s but
%    if it recieves a 1, it selects km/hr. 
%    Processor(wavFile) is m/s                                   
%    Processor(wavFile, 1) is km/h 

% Constants
columnNum = 299e6; % (m/s) speed of light
fc = 2590e6; % (Hz) Center frequency (connect VCO Vtune to +5)
maxSpeed_km_hr = 120; % (km/hr) maximum speed to display
maxSpeed_m_s = 33.3;% (m/s) maximum speed to display

lamda = columnNum/fc;

% Input parameters
CPI = 0.1; % seconds
OverlapFactor = 0.75; % Overlap factor between successive frames 

PFA = 10^-5;
RefWindow = 34; %reference window length
GuardCells = 2; % Number of guard cells on each

%Mode
unit = 0;
if nargin > 1  % Check if an input is there and sets unit
    unit = varargin{1};
end


% use a default filename if none is given
if ~exist('wavFile','var')
    wavFile = 'radar_test2.wav';
end

% read the raw wave data
fprintf('Loading WAV file...\n');
[Y,fs] = audioread(wavFile,'native');
y = -Y(:,2); % Received signal at baseband


% Compute the spectrogram 
NumSamplesPerFrame =  2^(nextpow2(round(CPI*fs)));      % Ensure its a power of 2

[S, f, t] = STFT(y,fs, NumSamplesPerFrame, OverlapFactor);

speed_m_per_sec = f*lamda/2;

if unit == 1
    % kilometer per hour
    speed_km_per_hr = speed_m_per_sec*(60*60/1000);
    speed_km_per_hr_Idx = find((speed_km_per_hr <= maxSpeed_km_hr) & (speed_km_per_hr >= 0));
    SpeedVectorOfInterest = speed_km_per_hr(speed_km_per_hr_Idx);
    S_OfInterest = S(speed_km_per_hr_Idx, :);
    yaxis = 'Speed (km/hr)';

else
    % meters per second
    speed_m_per_s_Idx = find((speed_m_per_sec <= maxSpeed_m_s) & (speed_m_per_sec >= 0));
    SpeedVectorOfInterest = speed_m_per_sec(speed_m_per_s_Idx);
    S_OfInterest = S(speed_m_per_s_Idx , :);
    yaxis = 'Speed (m/s)';

end


S_OfInterestToPlot = S_OfInterest/max(max(S_OfInterest)); 
%Create a scale based of max ie linear, then dB in plotting

% Plot the spectrogram 
clims = [-50 0];
figure; imagesc(t,SpeedVectorOfInterest,20*log10(S_OfInterestToPlot), clims);
xlabel('Time (s)');
ylabel(yaxis);
title('Spectogram showing speed(m/s) over time (s)');
grid on;
colorbar;
colormap('jet');
axis xy;
% Place markers on the image using scatter
hold on; % Enable hold to overlay markers on the image
no_detections = 0;
sum_speed = 0;
max_speed=0;
no_columns = size(S_OfInterestToPlot);
for i = 1:no_columns(2)
    X_complex = S_OfInterestToPlot(:, i); %Column of interest

    [positions, tac, threshold] = CACFAR(X_complex, PFA, RefWindow, GuardCells);

    % Create a column vector with the same size as target and as
    columnNum = ones(size(positions)) * i;
    % Mark detections on the spectrogram
    scatter(t(columnNum), SpeedVectorOfInterest(positions),36,'black','x'); % 'filled' fills the markers

    % Parameters for the avarage speed calculation
    no_detections = no_detections + tac;
    sum_speed = sum_speed + sum(SpeedVectorOfInterest(positions));
    
    % Max speed calculation
    if tac ~= 0 
        for j= 1:tac

            if SpeedVectorOfInterest(positions(j))> max_speed

                max_speed = SpeedVectorOfInterest(positions(j));

            end
        end
    end
end

avg_speed = sum_speed/no_detections; % Calculate avarage speed
disp("*************************************")
disp("Speed parameters")
disp("The maximum speed was " + max_speed + " m/s")
disp("The average speed was " + avg_speed + " m/s")
disp("*************************************")

end