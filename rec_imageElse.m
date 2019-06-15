function num = rec_imageElse(I)
   
    % Creamos una copia de la imagen original
    O = I;
    
    % Nueva imagen binaria rellena con ceros
    BW = zeros(size(I,1), size(I,2));

    % Pasamos a detectar la piel, para esto convertimos la imagen de RGB a
    % YCbCr, refs: https://en.wikipedia.org/wiki/YCbCr
    Iycbcr = rgb2ycbcr(I);
    Cb     = Iycbcr(:,:,2);        
    Cr     = Iycbcr(:,:,3);

    % Aqu� detectamos los p�xeles de la piel
    [r, c, ~] = find(Cb>=80 & Cb<=130 & Cr>=133 & Cr<=173);
    numind    = size(r,1);

    for i=1:numind
        % En la imagen original, marcamos los p�xeles de la skin con rojo
        O(r(i),c(i),:) = [255 0 0];
        % Rellenamos la imagen binaria con 1s donde detectamos p�xeles de piel
        BW(r(i),c(i)) = 1;
    end

    % Rellenamos los peque�os huecos que nos hayan quedado
    BW = imfill(BW, 'holes');
    
    % Eliminamos las �reas peque�as de la imagen
    BW = bwareaopen(BW, 900);  	
    se = strel('square', 100);
    
    % A continuaci�n pasamos a eliminar la palma, para poder quedarnos
    % posteriormente con los dedos y pasar a contarlos
    % 1- Los dedos son m�s peque�os que la palma por lo tanto podemos
    % "eliminarlos" aplicando erosi�n
    BW2 = imerode(BW, se);
    
    % 2- "Reconstruimos la palma" (o un poco m�s grande), aplicando dilataci�n
    BW2 = imdilate(BW2,se);
    % Si eliminamos la palma anterior a la imagen original obtenedremos
    % solamente los dedos y tal vez algo de ruido
    BW3 = imsubtract(BW, BW2);
    % Pasamos a eliminar el ruido
    BW3 = bwareaopen(BW3, 9000);
    BW = BW3;

    % Obtenemos informaci�n sobre las �reas contiguas
    st = regionprops(BW, 'All');
    
    % Ahora detectamos qu� hay en la imagen
    if length(st) > 9 
        num = 9;
    else
        num = length(st);
    end
    
end