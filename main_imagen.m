function num = main_imagen()
    % Obtenemos informaci�n de las c�maras conectadas a nuestro PC (toolbox de procesamiento de im�genes)
    vidInfo = imaqhwinfo;
    % Iniciamos el objeto c�mara
    vid 	= videoinput('winvideo', 1);
    % Abrimos el video en preview
    preview(vid);

    % El usuario puede elegir si tomar una imagen o cargarla
    message = '�Le gustar�a tomar una imagen?';
    reply   = questdlg(message, 'Tomar imagen', 'Si', 'No', 'Si');
    if strcmpi(reply, 'Si')
        % Tomamos una foto
        imgFromCam = getsnapshot(vid);
        I = imgFromCam;
    else
        % Cargamos la imagen
        [filename, pathname] = ...
         uigetfile({'*.*';'*.png';'*.PNG';'*.jpg';'*.tif'},'Selecciona una imagen...');
        fullFileName = fullfile(pathname, filename);
        I = imread(fullFileName);
    end
    % Eliminamos el objeto c�mara
    delete(vid)


% for i=0:10
%     vFotos{:,i+1} = strcat(int2str(i),'.jpeg');
% end

% for i=9:11
%     I = imread(strcat('dataBase/fotosdedosv2/', vFotos{:, i}));
    % Eliminamos el objeto c�mara
    % delete(vid);

    figure(1)
    subplot(2,2,1)
    imshow(I);

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

    figure(1)
    subplot(2,2,2)
    imshow(Iycbcr);


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
    % Eliminamos las �reas peque�as de la imagen
    BW = bwareaopen(BW, 900);  	% 900 para las im�genes de pruebav2

    se = strel('square',100);    % 100 para las im�genes de pruebav2
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
    BW3 = bwareaopen(BW3, 9000);     % 9000 para las im�genes de prueba
    BW = BW3;

    figure(1)
    subplot(2,2,3)
    imshow(BW);

    % Obtenemos informaci�n sobre las �reas contiguas
    st = regionprops(BW, 'All');

    fprintf(1,'Area #    Area\n');
    for k = 1 : length(st)
        thisBB = st(k).BoundingBox;
        hold on
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
          'EdgeColor','r','LineWidth',1 );
        hold off
        fprintf(1,'#%2d %16.1f\n',k,st(k).Area);
    end

    % Ordenamos las �reas
    allAreas = [st.Area];
    [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');

    % Contamos las areas y las etiquetamos en la imagen binaria
    for k = 1 : length(st)
        centerX = st(sortingIndexes(k)).Centroid(1);
        centerY = st(sortingIndexes(k)).Centroid(2);
        text(centerX,centerY,num2str(k),'Color', 'b', 'FontSize', 14)
    end


    % Ahora detectamos qu� hay en la imagen
    if length(st) > 10 
        num = 10;
    else
        num = length(st);
    end

    % close all;

    % end
    
end