function varargout = dicom_import_batch_gui(varargin)
% DICOM_IMPORT_BATCH_GUI MATLAB code for dicom_import_batch_gui.fig
%      DICOM_IMPORT_BATCH_GUI, by itself, creates a new DICOM_IMPORT_BATCH_GUI or raises the existing
%      singleton*.
%
%      H = DICOM_IMPORT_BATCH_GUI returns the handle to a new DICOM_IMPORT_BATCH_GUI or the handle to
%      the existing singleton*.
%
%      DICOM_IMPORT_BATCH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_IMPORT_BATCH_GUI.M with the given input arguments.
%
%      DICOM_IMPORT_BATCH_GUI('Property','Value',...) creates a new DICOM_IMPORT_BATCH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dicom_import_batch_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dicom_import_batch_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dicom_import_batch_gui

% Last Modified by GUIDE v2.5 06-Mar-2017 19:35:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dicom_import_batch_gui_OpeningFcn, ...
    'gui_OutputFcn',  @dicom_import_batch_gui_OutputFcn, ...
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


% --- Executes just before dicom_import_batch_gui is made visible.
function dicom_import_batch_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dicom_import_batch_gui (see VARARGIN)

% Choose default command line output for dicom_import_batch_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dicom_import_batch_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dicom_import_batch_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dir_path_field_Callback(hObject, eventdata, handles)
%input_dir = get(handles.dir_path_field,'String');
% if input_dir(end) ~= '\';
%     input_dir = [input_dir '\'];
%     set(handles.dir_path_field,'String',input_dir);
%     guidata(hObject, handles);
% end
set(handles.import_button,'Enable','on');



% --- Executes during object creation, after setting all properties.
function dir_path_field_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
input_dir = uigetdir('', 'Choose the input directory...');
if input_dir ~= 0
    %input_dir = [input_dir '\'];
    set(handles.dir_path_field,'String',input_dir);
    % Update handles structure
    guidata(hObject, handles);
    %scan(hObject, eventdata, handles)
end
set(handles.import_button,'Enable','on');



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

input_dir = get(handles.dir_path_field, 'String');
skipifmatfileexists = handles.checkbox1.Value;
resolution = str2double(get(handles.edit2, 'String'));
save_matfile = true;
default_save_path = true;
showGUI = true;
dicom_import_batch(input_dir, skipifmatfileexists, resolution, save_matfile, default_save_path, showGUI);

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)
close(handles.figure1);


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
close(handles.figure1);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
