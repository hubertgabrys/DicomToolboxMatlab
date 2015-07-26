function varargout = hg_importDicomBatchGUI(varargin)
% HG_IMPORTDICOMBATCHGUI MATLAB code for hg_importDicomBatchGUI.fig
%      HG_IMPORTDICOMBATCHGUI, by itself, creates a new HG_IMPORTDICOMBATCHGUI or raises the existing
%      singleton*.
%
%      H = HG_IMPORTDICOMBATCHGUI returns the handle to a new HG_IMPORTDICOMBATCHGUI or the handle to
%      the existing singleton*.
%
%      HG_IMPORTDICOMBATCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HG_IMPORTDICOMBATCHGUI.M with the given input arguments.
%
%      HG_IMPORTDICOMBATCHGUI('Property','Value',...) creates a new HG_IMPORTDICOMBATCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hg_importDicomBatchGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hg_importDicomBatchGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hg_importDicomBatchGUI

% Last Modified by GUIDE v2.5 24-Jul-2015 18:35:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @hg_importDicomBatchGUI_OpeningFcn, ...
    'gui_OutputFcn',  @hg_importDicomBatchGUI_OutputFcn, ...
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


% --- Executes just before hg_importDicomBatchGUI is made visible.
function hg_importDicomBatchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hg_importDicomBatchGUI (see VARARGIN)

% Choose default command line output for hg_importDicomBatchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hg_importDicomBatchGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hg_importDicomBatchGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dir_path_field_Callback(hObject, eventdata, handles)
input_dir = get(handles.dir_path_field,'String');
if input_dir(end) ~= '\';
    input_dir = [input_dir '\'];
    set(handles.dir_path_field,'String',input_dir);
    guidata(hObject, handles);
end
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
    input_dir = [input_dir '\'];
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
mainDirInfo = dir(input_dir); % get information about main directory
dirIndex = [mainDirInfo.isdir]; % get index of subfolders
subdirList = {mainDirInfo(dirIndex).name}'; % list of filenames in main directory
subdirList = subdirList(3:end);

h = waitbar(0,'Please wait...');
steps = length(subdirList);
for i=1:length(subdirList)
    [fileList,patientList ] = hg_scanDicomImportFolder(fullfile(input_dir,subdirList{i}));
    dicompaths.ct = fileList(strcmp(fileList(:,2),'CT'),1);
    dicompaths.rtss = fileList(strcmp(fileList(:,2),'RTSTRUCT'),1);
    dicompaths.rtdose = fileList(strcmp(fileList(:,2),'RTDOSE'),1);
    if length(patientList)~=1 || length(dicompaths.rtss)~=1 || length(dicompaths.rtdose)>2  
        msgbox(['Check DICOMs: ', subdirList{i}], 'Error','error');   
    end
    dicompaths.resolution = str2double(get(handles.edit2, 'String'));
    dicompaths.save_matfile = true;
    dicompaths.autosave = true;
    
    hg_dicomimport(dicompaths);
    waitbar(i / steps)
end
close(h)

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
