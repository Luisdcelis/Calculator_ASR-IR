clear, close all, clc;

% 1) Grabamos señal
t = 4; Fs = 11025; Ch = 1; nBits = 16;
[grab, sound] = grabacion(t, Fs, Ch, nBits);
play(sound);

% 2) Detectar inicio-fin de palabra
num_muestras = 40; despl = round(num_muestras/4);
segmentos = segmentacion(grab, num_muestras, despl);
num_segmentos_ruido = 10;
segmentos_palabra = inicio_fin(segmentos, num_segmentos_ruido);
palabra = inv_segmentacion(segmentos_palabra, despl);
plot(palabra);

% 3) Preenfasis
palabra = preenfasis(palabra, 0.95);

% 4) Segmentación-Enventanado de Hamming
num_muestras = 40; despl = round(num_muestras/4);
segmentos = segmentacion(palabra, num_muestras, despl);
segmentos = enventanado(segmentos, 'hamming');

% 5) Extracción de Patrones de Voz
p=13;
lpccoefs = lpc(segmentos, p);
p = size(lpccoefs, 2);

for j=1:size(segmentos,2)
    p = 13;
    lpccoefs = lpc(segmentos(:,j), p);
    p = length(lpccoefs);
    estsenal = filter([0 -lpccoefs(2:end)], 1, segmentos(:,j));
    error = segmentos(:,j) - estsenal;
    G = sqrt(sum(error .^ 2));
    for i=1:p
        ceps(j,i) = lpc2ceps(lpccoefs, i, p, G);
    end
end

reconocedorOP(ceps');

% COCIENTE = ceps';
% cad = 'COCIENTE';
% save(cad, cad);

