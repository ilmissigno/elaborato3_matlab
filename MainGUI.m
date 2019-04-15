function varargout = MainGUI(varargin)
% MAINGUI MATLAB code for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 15-Apr-2019 12:52:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dimA_Callback(hObject, eventdata, handles)
% hObject    handle to dimA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimA as text
%        str2double(get(hObject,'String')) returns contents of dimA as a double
handles.dimensioneA = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function dimA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimB_Callback(hObject, eventdata, handles)
% hObject    handle to dimB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimB as text
%        str2double(get(hObject,'String')) returns contents of dimB as a double
handles.dimensioneB = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function dimB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getSol.
function getSol_Callback(hObject, eventdata, handles)
% hObject    handle to getSol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dimensioneA = str2double(get(handles.dimA,'String'));
dimensioneB = str2double(get(handles.dimB,'String'));
toll = str2double(get(handles.tol,'String'));
nummax = str2double(get(handles.nmax,'String'));
if(~isnumeric(dimensioneA) || dimensioneA<=1 || isempty(dimensioneA))
     errordlg('Inserire un valore numerico che sia maggiore o uguale a 2','Errore');
     error('Inserire un valore numerico che sia maggiore o uguale a 2');
end
if(~isnumeric(dimensioneB) || dimensioneB~=dimensioneA || isempty(dimensioneB))
     errordlg('Inserire un valore numerico uguale alla dimensione di A','Errore'); 
     error('Inserire un valore numerico uguale alla dimensione di A');
end
if(isempty(toll))
    warndlg('Il valore di Tolleranza non e'' stato specificato, uso quello di default 10^-6','Attenzione');
    uiwait(gcf);
    toll = 10^-6;
end
if(isempty(nummax))
    warndlg('Il numero di iterazioni non e'' stato specificato, uso quello di default 500','Attenzione');
    uiwait(gcf);
    nummax = 500;
end
toll = 10.^(toll);
if ((~isscalar(toll)) || (~isnumeric(toll)) || (isinf(toll)) || (isnan(toll)) || (toll <= 0))
    errordlg('TOL deve essere un numero positivo','Errore');
    error('Err:TOL_NON_VALIDO','TOL deve essere un numero positivo');
end
if (toll < eps)
    warndlg('Il valore di TOL specificato è troppo piccolo. Verrà usato il valore di default TOL = 10^-6','Attenzione');
    uiwait(gcf);
    warning('Warn:TOL_PICCOLO','Il valore di TOL specificato è troppo piccolo. Verrà usato il valore di default TOL = 10^-6');
    toll = 10^-6;
end

if (toll >= 1)
    warndlg('Il valore di TOL specificato è troppo grande. Il risultato fornito potrebbe essere molto inaccurato. Si guardi la documentazione.','Attenzione');
    uiwait(gcf);
    warning('Warn:TOL_GRANDE','Il valore di TOL specificato è troppo grande. Il risultato fornito potrebbe essere molto inaccurato. Si guardi la documentazione.');
end
if ((~isscalar(nummax)) || (~isnumeric(nummax)) || (isinf(nummax)) || (isnan(nummax)) || (nummax <= 0) || (mod(nummax,1) > eps))
    errordlg('MAXITER deve essere un intero positivo','Errore');
    error('Err:MAXITER_NON_VALIDO','MAXITER deve essere un intero positivo');
end

% Segnalo se NMAX è piccolo
if (nummax < 10)
    warndlg('Il numero di iterazioni specificato è molto piccolo, l''errore di calcolo potrebbe essere elevato','Attenzione');
    uiwait(gcf);
    warning('Warn:MAXITER_PICCOLO','Il numero di iterazioni specificato è molto piccolo, l''errore di calcolo potrebbe essere elevato');
end

% Segnalo se NMAX è abbastanza grande.
if (nummax > 10000)
    warndlg('Il numero di iterazioni specificato è molto alto, l''esecuzione potrebbe essere più lenta','Attenzione');
    uiwait(gcf);
    warning('Warn:MAXITER_GRANDE','Il numero di iterazioni specificato è molto alto, l''esecuzione potrebbe essere più lenta');
end
A = gallery('poisson',dimensioneA);
b = sprand(length(A),1,0.2);
[x,niter,resrel] = Jacobi(A,b,toll,nummax);
finaltext = '';
for i=1:length(x)
testo = sprintf('x =  %.5e',x(i));
end
finaltext = [finaltext,' ',testo];
set(handles.ris,'String',sprintf('Soluzioni del Sistema \n %s \n Numero iterazioni %d \n Residuo Relativo %.13e',finaltext,niter,resrel));

% --- Executes on button press in checkAccuracy.
function checkAccuracy_Callback(hObject, eventdata, handles)
% hObject    handle to checkAccuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in testCase.
function testCase_Callback(hObject, eventdata, handles)
% hObject    handle to testCase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tol_Callback(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol as text
%        str2double(get(hObject,'String')) returns contents of tol as a double
handles.toll = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nmax_Callback(hObject, eventdata, handles)
% hObject    handle to nmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nmax as text
%        str2double(get(hObject,'String')) returns contents of nmax as a double
handles.nummax = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function nmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
