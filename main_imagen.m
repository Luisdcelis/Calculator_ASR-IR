function num = main_imagen()    
    addpath('IR');
    % El usuario puede elegir si tomar una imagen o cargarla
    message = 'Elija una opción';
    reply   = questdlg(message, 'Tomar imagen', 'Tomar foto', 'Cargar imagen', 'Tomar foto');
    if strcmpi(reply, 'Tomar foto')
        num = rec_imageIf();
    else
        if strcmpi(reply, 'Cargar imagen')
            % Cargamos la imagen
            [filename, pathname] = ...
             uigetfile({'*.*'},'Selecciona una imagen...');
            fullFileName = fullfile(pathname, filename);
            I = imread(fullFileName);
            num = rec_imageElse(I);        
        else
            num = 'errorInNum';
        end
    end
end