% a son los coeficientes lpc
% n es el coeficiente cepstrum que queremos calcular
% p es el número de coeficientes lpc dados
function c = lpc2ceps(a, n, p, G)
    if n <= 0
        c = 0;
    else
        if n==1
            c = log(G);
        else
            if n <= p
                sumatorio = 0;
                for k=1:n-1
                    sumatorio = sumatorio + (k/n) * lpc2ceps(a, k, p, G) * a(n-k);
                end
                c = a(n) + sumatorio;
            else
                c = 0;
                for k=(n-p):(n-1)
                    c = c + (k/n) * lpc2ceps(a, k, p, G) * a(n-k);
                end
            end
        end
    end
end