function varargout = Calculadora(varargin)
% Calculadora MATLAB code for Calculadora.fig
%      Calculadora, by itself, creates a new Calculadora or raises the existing
%      singleton*.
%
%      H = Calculadora returns the handle to a new Calculadora or the handle to
%      the existing singleton*.
%
%      Calculadora('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Calculadora.M with the given input arguments.
%
%      Calculadora('Property','Value',...) creates a new Calculadora or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the Calculadora before Calculadora_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calculadora_OpeningFcn via varargin.
%
%      *See Calculadora Options on GUIDE's Tools menu.  Choose "Calculadora allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calculadora

% Last Modified by GUIDE v2.5 15-Jun-2019 12:15:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calculadora_OpeningFcn, ...
                   'gui_OutputFcn',  @Calculadora_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Calculadora is made visible.
function Calculadora_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFc
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calculadora (see VARARGIN)

% Choose default command line output for Calculadora
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calculadora wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calculadora_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in operador.
function operador_Callback(hObject, eventdata, handles)
expr = get(handles.commandLine, 'String');
expr = strcat(expr, main_sonido());
set(handles.commandLine, 'String', expr);
% hObject    handle to operador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in numero.
function numero_Callback(hObject, eventdata, handles)
num = get(handles.commandLine, 'String');
num = strcat(num, num2str(main_imagen()));
if strcmp(num, 'errorInNum') == 0    
    set(handles.commandLine, 'String', num);
end
% hObject    handle to numero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in botonIgual.
function botonIgual_Callback(hObject, eventdata, handles)
sNum = get(handles.commandLine,'String');
op = {sNum};
op = eval(op{1});
set(handles.resultado, 'String', op);
set(handles.commandLine, 'String', '');
% hObject    handle to botonIgual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function operador_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
