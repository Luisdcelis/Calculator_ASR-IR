function [inicio, fin] = inicio_fin(senyal)
%EJERCICIO 2
a = 0.95;
num_muestras = 15;
despl = 5;
senyal = preenfasis(senyal , a);

segmentos = segmentacion(senyal, num_muestras, despl);
segmentos_enventanados = enventanado(segmentos, 'hamming');
E = energia(segmentos_enventanados);
M = magnitud(segmentos_enventanados);
Z = cruces_por_cero(segmentos_enventanados);
% mProm          = magnitudPromedio(segmentos_enventanados);
Ms             = M(1:10);
Zs             = Z(1:10);

UmbSupEnrg     = 0.5*max(M);
UmbInfEnrg     = mean(Ms) + 2*std(Ms);
UmbCruCero     = mean(Zs) + 2*std(Zs);

In = -1;
i = 11;
while (In == -1 && i<length(M))
if mProm(i) > UmbSupEnrg
    In = i;
end
i = i + 1;  
end
i = In;
Ie = -1;
while (Ie == -1 && i>0)
    if mProm(i) < UmbInfEnrg
    Ie = i;
    end
    i = i-1;
end
n = Ie;

cont = 0;
while (n > Ie-25 && n > 11)   
    
   if Z(n) > UmbCruCero
   cont = cont+1;    
   else
   cont = 0;
   inicio = Ie;
   end
   
   if cont>=3
   inicio = n+2; 
   n = 10; %salir del bucle
   end
   n = n-1;
end






mProm          = fliplr(mProm);
Z              = fliplr(Z);
Ms             = mProm(1:10);
Zs             = Z(1:10);

UmbSupEnrg     = 0.5*max(mProm);
UmbInfEnrg     = mean(Ms) + 2*std(Ms);
UmbCruCero     = mean(Zs) + 2*std(Zs);

In = -1;
i = 11;
while (In == -1 && i<length(mProm))
if mProm(i) > UmbSupEnrg
    In = i;
end
i = i + 1;  
end
i = In;
Ie = -1;
while (Ie == -1 && i>0)
    if mProm(i) < UmbInfEnrg
    Ie = i;
    end
    i = i-1;
end
n = Ie;

cont = 0;
while (n > Ie-25 && n > 11)   
    
   if Z(n) > UmbCruCero
   cont = cont+1;    
   else
   cont = 0;
   fin = Ie;
   end
   
   if cont>=3
   fin = n+2; 
   n = 10; %salir del bucle
   end
   n = n-1;
end
fin = length(Z)-fin+1;
end