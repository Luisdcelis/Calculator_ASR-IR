function sol = reconocedorOP(carac)
    load SUMA.mat
    load RESTA.mat
    load PRODUCTO.mat
    load COCIENTE.mat

    diffSUMA     = dtw(carac, SUMA);
    diffRESTA    = dtw(carac, RESTA);
    diffPRODUCTO = dtw(carac, PRODUCTO);
    diffCOCIENTE = dtw(carac, COCIENTE);

    diferencias = [diffSUMA diffRESTA diffPRODUCTO diffCOCIENTE];
    [~, ind] = min(diferencias);
    switch ind
        case 1
%             disp('La palabra dicha es SUMA');
            sol = '+';
        case 2
%             disp('La palabra dicha es RESTA');
            sol = '-';
        case 3
%             disp('La palabra dicha es PRODUCTO');
            sol = '*';
        case 4
%             disp('La palabra dicha es COCIENTE');
            sol = '/';
    end
    
end