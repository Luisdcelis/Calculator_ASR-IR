clear, close all, clc;
vidInfo = imaqhwinfo;
vid 	= videoinput('winvideo', 1);
I_fondo = getsnapshot(vid);
I_fondo_gray = rgb2gray(I_fondo);
subplot(2,1,1), imshow(I_fondo_gray);
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
subplot(2,1,2), imshow(I_gray);
% 
% I_procesada = imsubtract(I_fondo_gray, I_gray);
% subplot(2,2,3), imshow(I_procesada);
% 
% I_bin = imbinarize(I_procesada);
% I_bin = imfill(I_bin, 'holes');
% subplot(2,2,4), imshow(I_bin);


I_fondo_imagen = imsubtract(I_fondo_gray, I_gray);
figure;
subplot(3,3,1), imshow(I_fondo_imagen), title('Fondo - Imagen'); 
I_imagen_fondo = imsubtract(I_gray, I_fondo_gray);
subplot(3,3,2), imshow(I_imagen_fondo), title('Imagen - Fondo'); 
fusion = imfuse(I_fondo_imagen, I_imagen_fondo);
subplot(3,3,3), imshow(fusion), title('Fusion');

fusion_bw = im2bw(fusion, 0.125);
I_bin = fusion_bw;

I_bin = imfill(I_bin, 'holes');
figure, imshow(I_bin);
x_size = size(I_bin, 2);
y_size = size(I_bin, 1);
BW = bwareaopen(I_bin, round(0.01*(x_size*y_size)));


