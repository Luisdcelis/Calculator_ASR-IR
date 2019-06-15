function sol = reconocedorOP(carac)
    load dataBase/recording/SUMA.mat
    load dataBase/recording/RESTA.mat
    load dataBase/recording/PRODUCTO.mat
    load dataBase/recording/COCIENTE.mat

    diffSUMA     = dtw(carac, SUMA);
    diffRESTA    = dtw(carac, RESTA);
    diffPRODUCTO = dtw(carac, PRODUCTO);
    diffCOCIENTE = dtw(carac, COCIENTE);

    diferencias = [diffSUMA diffRESTA diffPRODUCTO diffCOCIENTE];
    [~, ind] = min(diferencias);
    switch ind
        case 1
            sol = '+';
        case 2
            sol = '-';
        case 3
            sol = '*';
        case 4
            sol = '/';
    end
    
end