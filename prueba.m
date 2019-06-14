clear, close all, clc;
vidInfo = imaqhwinfo;
vid 	= videoinput('winvideo', 1);
I_fondo = getsnapshot(vid);
I_fondo_gray = rgb2gray(I_fondo);
subplot(2,2,1), imshow(I_fondo_gray);
preview(vid);
pause(5)
imgFromCam = getsnapshot(vid);
I = imgFromCam;
% message = '¿Le gustaría tomar una imagen?';
% reply   = questdlg(message, 'Tomar imagen', 'Si', 'No', 'Si');
% if strcmpi(reply, 'Si')
%     % Tomamos una foto
%     imgFromCam = getsnapshot(vid);
%     I = imgFromCam;
% else
%     % Cargamos la imagen
%     [filename, pathname] = ...
%      uigetfile({'*.*';'*.png';'*.PNG';'*.jpg';'*.tif'},'Selecciona una imagen...');
%     fullFileName = fullfile(pathname, filename);
%     I = imread(fullFileName);
% end
delete(vid);
I_gray = rgb2gray(I);
subplot(2,2,2), imshow(I_gray);

I_procesada = imsubtract(I_fondo_gray, I_gray);
subplot(2,2,3), imshow(I_procesada);

I_bin = imbinarize(I_procesada);
I_bin = imfill(I_bin, 'holes');
subplot(2,2,4), imshow(I_bin);
x_size = size(I_bin, 2);
y_size = size(I_bin, 1);
BW = bwareaopen(I_bin, round(0.01*(x_size*y_size)));

st = regionprops(BW, 'All');
mano={};
dedos_por_mano = [0];

for k=1:length(st)
    thisBB = st(k).BoundingBox;
    mano{k} = BW(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3));
    figure, imshow(mano{k});
    se = strel('square',round(0.20*size(mano{k},2)));    
    % A continuación pasamos a eliminar la palma, para poder quedarnos
    % posteriormente con los dedos y pasar a contarlos
    % 1- Los dedos son más pequeños que la palma por lo tanto podemos
    % "eliminarlos" aplicando erosión
    BW2 = imerode(mano{k}, se);
    % 2- "Reconstruimos la palma" (o un poco más grande), aplicando dilatación
    BW2 = imdilate(BW2,se);
    % Si eliminamos la palma anterior a la imagen original obtenedremos
    % solamente los dedos y tal vez algo de ruido
    BW3 = imsubtract(mano{k}, BW2);
    figure, imshow(BW3);
    % Pasamos a eliminar el ruido
    BW3 = bwareaopen(BW3, round(0.015*(size(mano{k},1)*size(mano{k},2))));
    stats = regionprops(BW3, 'All');
    dedos_por_mano(k) = length(stats);
    figure, imshow(BW3);
end

sum(dedos_por_mano);

