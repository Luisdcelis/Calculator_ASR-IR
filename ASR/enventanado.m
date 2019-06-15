function segmentos_enventanados = enventanado(segmentos, ventana)
    if isequal(ventana, 'rectangular')
        ventana = rectwin(size(segmentos,1));
    else
        if isequal(ventana, 'hamming')
            ventana = hamming(size(segmentos,1));
        else
            if isequal(ventana, 'hanning')
                ventana = hanning(size(segmentos,1));
            end
        end
    end
    segmentos_enventanados = segmentos.*ventana;
end