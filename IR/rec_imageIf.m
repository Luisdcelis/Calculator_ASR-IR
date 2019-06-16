function num = rec_imageIf()
    
    vid = videoinput('winvideo', 1);
    vidInfo = imaqhwinfo(vid);
    vidRes = vid.VideoResolution;
    imWidth = vidRes(1);
    imHeight = vidRes(2);
    numBands = vid.NumberOfBands;
    hFig = figure;
    hAxes = axes(hFig);
    hImage = image(hAxes, zeros(imHeight, imWidth, 3));
    preview(vid, hImage);
    hRect1 = rectangle('Position', [1,round(imHeight/3),400,400],...
              'EdgeColor','r','LineWidth',1 );
    hRect2 = rectangle('Position', [imWidth-400,round(imHeight/3),400,400],...
              'EdgeColor','r','LineWidth',1 );

    pause(15)
    I = getsnapshot(vid);
    delete(vid);
    
    img = {};
    thisBB = [1,round(imHeight/3),400,400];
    img{1} = I(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3),:);
    thisBB = [imWidth-400,round(imHeight/3),400,400];
    img{2} = I(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3),:);
    
    %Extraer imagen binaria de la original
    num = 0;
    for k=1:2   % Procesamos cada una de las imágines
        I = img{k};
        height = size(I,1);
        width = size(I,2);

        % Creamos una copia de la imagen original
        O = I;
        % Nueva imagen binaria rellena con ceros
        BW = zeros(height, width);

        % Pasamos a detectar la piel, para esto convertimos la imagen de RGB a
        % YCbCr, refs: https://en.wikipedia.org/wiki/YCbCr
        Iycbcr = rgb2ycbcr(I);
        Cb = Iycbcr(:,:,2);        
        Cr = Iycbcr(:,:,3);

        % Aquí detectamos los píxeles de la piel
        [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
        numind = size(r,1);

        for i=1:numind
            % En la imagen original, marcamos los píxeles de la skin con rojo
            O(r(i),c(i),:) = [255 0 0];
            % Rellenamos la imagen binaria con 1s donde detectamos píxeles de piel
            BW(r(i),c(i)) = 1;
        end

        % Rellenamos los pequeños huecos que nos hayan quedado
        BW = imfill(BW, 'holes');
        img{k} = BW;

        % Eliminamos las áreas pequeñas de la imagen
        BW = bwareaopen(BW, round(0.0175*(height*width)));
        se = strel('square',round(0.125*width));   
        
        % A continuación pasamos a eliminar la palma, para poder quedarnos
        % posteriormente con los dedos y pasar a contarlos
        % 1- Los dedos son más pequeños que la palma por lo tanto podemos
        % "eliminarlos" aplicando erosión
        BW2 = imerode(BW, se);
        
        % 2- "Reconstruimos la palma" (o un poco más grande), aplicando dilatación
        BW2 = imdilate(BW2,se);
        % Si eliminamos la palma anterior a la imagen original obtenedremos
        % solamente los dedos y tal vez algo de ruido
        BW3 = imsubtract(BW, BW2);
        % Pasamos a eliminar el ruido
        BW3 = bwareaopen(BW3, round(0.0175*height*width));     
        BW = BW3;
%         figure, imshow(BW)

        % Obtenemos información sobre las áreas contiguas
        st = regionprops(BW, 'All');
        num = num + length(st); 
    end
    
    % Ahora detectamos qué hay en la imagen
    if num > 9 
        num = 9;
    end
    
    close(hFig);
    
end