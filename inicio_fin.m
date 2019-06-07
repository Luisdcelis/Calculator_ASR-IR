function segmentos = inicio_fin (segmentos, num_segmentos_ruido)
M = magnitud(segmentos);
Z = cruces_por_cero(segmentos);

% Calculamos el principio de la palabra.

Ms = M(:,1:num_segmentos_ruido);
Zs = Z(:,1:num_segmentos_ruido);

UmbSupEnrg = 0.5*max(M);

UmbInfEnrg = mean2(Ms) + 2*std2(Ms);

UmbCruCero = mean2(Zs) + 2*std2(Zs);

n = num_segmentos_ruido+1;

while ~(M(n) > UmbSupEnrg)
    n = n+1;
end
ln = n;

while ~(M(n) < UmbInfEnrg)
    n = n-1;
end
le = n;

ruido = 0;
lz = 0;
for n = le:-1:le-25
    if Z(n) > UmbCruCero
        ruido = ruido + 1;
        if ruido == 3
            while Z(n) > UmbCruCero
                n = n+1;
            end
            lz = n;
        end
    else
        ruido = 0;
    end
end
    

% Calculamos el fin de la palabra.

Ms = M(:,(end - num_segmentos_ruido):end);
Zs = Z(:,(end - num_segmentos_ruido):end);

UmbSupEnrg = 0.5*max(max(M));

UmbInfEnrg = mean2(Ms) + 2*std2(Ms);

UmbCruCero = mean2(Zs) + 2*std2(Zs);

n = (size(M,2)-(num_segmentos_ruido-1));

while ~(M(n) > UmbSupEnrg)
    n = n-1;
end
fn = n;

while ~(M(n) <= UmbInfEnrg)
    n = n+1;
end
fe = n;

ruido = 0;
fz = 0;
for n = fe:(size(M,2)-(num_segmentos_ruido-1))
    if Z(n) > UmbCruCero
        ruido = ruido + 1;
        if ruido == 3
            while Z(n) > UmbCruCero
                n = n-1;
            end
            fz = n;
        end
    else
        ruido = 0;
    end
end

% Dejamos solo la palabra.

if lz ~= 0
    if fz ~= 0 
        segmentos = segmentos(:,lz:fz);
    else
        segmentos = segmentos(:,lz:fe);
    end
else
    if fz ~= 0 
        segmentos = segmentos(:,le:fz);
    else
        segmentos = segmentos(:,le:fe);
    end
end
end
