function segmentos_palabra = inicio_fin (segmentos, umbral)
    E = energia(segmentos);
    ind = find(E > umbral);
    ini = min(ind);
    fin = max(ind);
    segmentos_palabra = segmentos(:,ini:fin);
end
