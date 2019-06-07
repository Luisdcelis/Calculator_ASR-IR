function [senal,recObj] = grabacion(t, Fs, Ch, nBits)
%    disp('Start speaking');
   recObj = audiorecorder(Fs, nBits, Ch);
   recordblocking(recObj, t);
%    disp('End record');
   senal = getaudiodata(recObj);
end
