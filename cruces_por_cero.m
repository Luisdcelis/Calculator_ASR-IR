function salida = cruces_por_cero(segmentos)
    for i=1:size(segmentos,2)
        for j=1:size(segmentos,1)-1
            nCruces(j) = abs(sign(segmentos(j,i)) - sign(segmentos(j+1,i)))/2;
        end
        salida(i) = sum(nCruces)/size(segmentos,1);
    end
end