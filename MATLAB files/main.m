%% Processing recordings

clear all;
close all;
                
wavFile_CW_All = {
                  'shot 1.wav'; 
                  'shot 2.wav';
                  'shot 3.wav';
                  'shot 4.wav';
                  'shot 5.wav';
                  'shot 6.wav';
                  'shot 7.wav';
                  'shot 8.wav';
                  'shot 9.wav';
                  'shot 10.wav';
                  'shot 11.wav';
                  'shot 12.wav';
                  'shot 13.wav';
                  'shot 14.wav';
                  'shot 15.wav';
                  'shot 16.wav';
                  'shot 17.wav';
                  'shot 18.wav';
                  'shot 19.wav';
                  'shot 20.wav';
                  'shot 21.wav';
                  'shot 22.wav';
                  'shot 23.wav';
                  'shot 24.wav';
                  'shot 25.wav';
                  'shot 26.wav';
                  'shot 27.wav';
                  'shot 28.wav';
                  'shot 29.wav';
                  'shot 30.wav'
                  };
              
RecordingNo2Process = 1;              

wavFile_CW = wavFile_CW_All{RecordingNo2Process};

Processor(wavFile_CW);
