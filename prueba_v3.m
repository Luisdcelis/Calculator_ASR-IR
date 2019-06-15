clear, clc, close all
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

pause(7)
I = getsnapshot(vid);
subplot(1,3,1), imshow(I);
delete(vid)
img = {};
thisBB = [1,round(imHeight/3),400,400];
img{1} = I(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3),:);
subplot(1,3,2), imshow(img{1});
thisBB = [imWidth-400,round(imHeight/3),400,400];
img{2} = I(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3),:);
subplot(1,3,3), imshow(img{2});


%Extraer imagen binaria de la original
for k=1:2
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

%     figure(1)
%     subplot(2,2,2)
%     imshow(Iycbcr);


    % Aqu� detectamos los p�xeles de la piel
    [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
    numind = size(r,1);

    for i=1:numind
        % En la imagen original, marcamos los p�xeles de la skin con rojo
        O(r(i),c(i),:) = [255 0 0];
        % Rellenamos la imagen binaria con 1s donde detectamos p�xeles de piel
        BW(r(i),c(i)) = 1;
    end

    % Rellenamos los peque�os huecos que nos hayan quedado
    BW = imfill(BW, 'holes');
%     figure, imshow(BW);
    img{k} = BW;
%     subplot(1,2,k), imshow(img{k})
    
    % Eliminamos las �reas peque�as de la imagen
    BW = bwareaopen(BW, round(0.01*(height*width)));

    se = strel('square',round(0.10*width));    % 100 para las im�genes de pruebav2
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
    BW3 = bwareaopen(BW3, round(0.015*height*width));     % 9000 para las im�genes de prueba
    BW = BW3;

    figure;
    imshow(BW);

    % Obtenemos informaci�n sobre las �reas contiguas
    st = regionprops(BW, 'All');

%     fprintf(1,'Area #    Area\n');
    for j = 1 : length(st)
        thisBB = st(j).BoundingBox;
        hold on
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
          'EdgeColor','r','LineWidth',1 );
        hold off
%         fprintf(1,'#%2d %16.1f\n',k,st(j).Area);
    end
    length(st)
end


      