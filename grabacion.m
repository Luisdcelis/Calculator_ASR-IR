function [senal,recObj] = grabacion(t, Fs, Ch, nBits)
    %    disp('Start speaking');
    myicon = imread('dataBase\fotos\record.jpg');
    msg = msgbox('Diga un operador...', 'Grabrando', 'custom', myicon);
    recObj = audiorecorder(Fs, nBits, Ch);
    recordblocking(recObj, t);
    close(msg);
    %    disp('End record');
    senal = getaudiodata(recObj);
end
