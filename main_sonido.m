function sol = main_sonido()
    % 1) Grabamos señal
    t = 4; Fs = 11025; Ch = 1; nBits = 16;
    [grab, sound] = grabacion(t, Fs, Ch, nBits);
    play(sound);
%     subplot(2,1,1), plot(grab);
    
    % 2) Detectar inicio-fin de palabra
    num_muestras = 40; despl = round(num_muestras/4);
    segmentos = segmentacion(grab, num_muestras, despl);
    umbral = 0.4;
    segmentos_palabra = inicio_fin(segmentos, umbral);
    palabra = inv_segmentacion(segmentos_palabra, despl);
%     subplot(2,1,2), plot(palabra);
    
    % 3) Preenfasis
    palabra = preenfasis(palabra, 0.95);

    % 4) Segmentación-Enventanado de Hamming
    num_muestras = 40; despl = round(num_muestras/4);
    segmentos = segmentacion(palabra, num_muestras, despl);
    segmentos = enventanado(segmentos, 'hamming');

    % 5) Extracción de Patrones de Voz
    c = rceps(segmentos);
    sol = reconocedorOP(c);    
    % Training
%     RESTA = c;
%     cad = 'RESTA';
%     save(cad, cad);
    
end
