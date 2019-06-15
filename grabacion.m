function [senal,recObj] = grabacion(t, Fs, Ch, nBits)
    myicon = imread('dataBase\fotos\record.jpg');
    msg = msgbox('Diga un operador...', 'Grabrando', 'custom', myicon);
    recObj = audiorecorder(Fs, nBits, Ch);
    recordblocking(recObj, t);
    close(msg);
    senal = getaudiodata(recObj);
end
