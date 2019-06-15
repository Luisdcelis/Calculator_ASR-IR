function palabra = inv_segmentacion(segmentos, desp)
    N = size(segmentos,1);
    num_seg = size(segmentos,2);
    palabra = reshape(segmentos,N*num_seg,1);
    aux = [];
    for i = 1:desp
        aux = [aux N+i:N:(N*num_seg)];
    end
    palabra(aux) = [];
end


