function [S, f, t] = STFT(y,fs, N, OverlapFactor)

% Input parameters
% y = Wav function
% fs = Sampling frequency
% N = Number of samples in a single frame.
% OverlapFactor = Overlap between successive frames as a decimal

frame_size = N;
x = single(y(:)); % Covert the signal y to a column-vector

% Other parameters
overlap = floor(frame_size * OverlapFactor); % Overlap between successive frames as an integer
no_frames = floor((length(x)-frame_size)/(frame_size-overlap))+1; % Total number of frames for signal
window = hamming(frame_size); %window function to be used

% Initiation of the matrix to store frames after FFT 
S = zeros(frame_size, no_frames); 

% First frame
X = fftshift(fft(x(1:frame_size).*window));
X_magnitude = abs(X);
S(:,1) = X_magnitude;

% Loop parameters
position = frame_size + 1; % Position of next unprocessed sample
i = 2;

while i <= no_frames-1

    start = floor(position - overlap);      % Position of 1st sample of each frame 
    ending = start + frame_size - 1; % Position of last sample of each frame 

    x_AfterWindowing = x(start:ending).*window;
    x_AfterWindowing = x_AfterWindowing - mean(x_AfterWindowing); % remove DC component
    
    X = fftshift(fft(x_AfterWindowing));
    X_magnitude = abs(X);
    S(:,i) = X_magnitude;


    position = ending +1;
    i = i + 1;

end

f = (-frame_size/2:frame_size/2-1)*(fs/frame_size);

first_time_instance = ((frame_size-1)/fs)/2 ;
t = ((0:no_frames-1)*(frame_size-overlap)/fs) + first_time_instance;

end