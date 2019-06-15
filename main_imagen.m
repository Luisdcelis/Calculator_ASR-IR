function num = main_imagen()    
    % El usuario puede elegir si tomar una imagen o cargarla
    message = '¿Le gustaría tomar una imagen?';
    reply   = questdlg(message, 'Tomar imagen', 'Si', 'No', 'Si');
    if strcmpi(reply, 'Si')
        num = rec_imageIf();
    else
        % Cargamos la imagen
        [filename, pathname] = ...
         uigetfile({'*.*'},'Selecciona una imagen...');
        fullFileName = fullfile(pathname, filename);
        I = imread(fullFileName);
        num = rec_imageElse(I);
    end
    
end