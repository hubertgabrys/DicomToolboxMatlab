function varargout = GUI_start(varargin)
% GUI_START MATLAB code for GUI_start.fig
%      GUI_START, by itself, creates a new GUI_START or raises the existing
%      singleton*.
%
%      H = GUI_START returns the handle to a new GUI_START or the handle to
%      the existing singleton*.
%
%      GUI_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_START.M with the given input arguments.
%
%      GUI_START('Property','Value',...) creates a new GUI_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_start

% Last Modified by GUIDE v2.5 07-Jan-2015 12:06:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_start_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_start_OutputFcn, ...
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


% --- Executes just before GUI_start is made visible.
function GUI_start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_start (see VARARGIN)

% Choose default command line output for GUI_start
handles.output = hObject;
maximumNrOfStructures = 50;
handles.selected_structures = zeros(maximumNrOfStructures,1);
handles.defaultdatapath = 'C:\Users\gabrysh\Desktop\DICOMs\PatientData_kopfklinik\HN_compiledDICOMS\OK\';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_start wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_start_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in analysis_radio1.
function analysis_radio1_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysis_radio1


% --- Executes on button press in analysis_radio2.
function analysis_radio2_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysis_radio2


% --- Executes on button press in analysis_radio3.
function analysis_radio3_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_radio3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysis_radio3


% --- Executes on button press in LoadDose_button.
function LoadDose_button_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDose_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, directory] = uigetfile([handles.defaultdatapath '*.dcm'], 'Choose RTDose Plan...');
handles.rtdose_plan_path = [directory filename];
% Update handles structure
guidata(hObject, handles)


% --- Executes on button press in OutputDirectory_button.
function OutputDirectory_button_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirectory_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output_directory = uigetdir(handles.defaultdatapath, 'Choose Output Directory...');
handles.output_directory = [output_directory '\'];
setPatName(handles);
guidata(hObject, handles)
set(handles.calculate_button, 'Enable', 'on');
% Update handles structure
guidata(hObject, handles)


% --- Executes on button press in LoadStructures_button.
function LoadStructures_button_Callback(hObject, eventdata, handles)
% hObject    handle to LoadStructures_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, directory] = uigetfile([handles.defaultdatapath '*.dcm'], 'Choose RTStruc...');
handles.rtstruc_path = [directory filename];
% Update handles structure
guidata(hObject, handles)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in Up_button.
function Up_button_Callback(hObject, eventdata, handles)
% hObject    handle to Up_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

if (handles.slice < length(handles.dosecubes.dosecube.dosecube_zVector))
    handles.slice = handles.slice + 1;
end
% Update handles structure
guidata(hObject, handles)
plotDose( hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles)

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)


% --- Executes on button press in Down_button.
function Down_button_Callback(hObject, eventdata, handles)
% hObject    handle to Down_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

if (handles.slice > 1)
    handles.slice = handles.slice - 1;
end
% Update handles structure
guidata(hObject, handles)
plotDose( hObject, eventdata, handles );
% Update handles structure
guidata(hObject, handles)

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)


% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

% calculate
dosecubes = hg_calcdicomdosecubes(handles.rtdose_plan_path, handles.rtstruc_path, handles.output_directory);
set(handles.analysisresult_text,'String', 'Dosecubes calculated!');
set(hObject, 'Enable', 'off');
set(handles.Plot_button, 'Enable', 'on');
handles.s_fieldnames = fieldnames(dosecubes);
handles.dosecubes = dosecubes;
guidata(hObject, handles)
enablecheckboxes(hObject, eventdata, handles)

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)

% --- Executes on button press in Plot_button.
function Plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

handles.slice = 1;
% Update handles structure
guidata(hObject, handles)
plotDose( hObject, eventdata, handles );
% Update handles structure
guidata(hObject, handles)

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)


% --- Executes on button press in LoadDosecubes_button.
function LoadDosecubes_button_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDosecubes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

[filename, directory] = uigetfile([handles.defaultdatapath '*.mat'], 'Choose dosecubes.mat file...');
load([directory '\' filename]);
dosecubes = dcs;
handles.output_directory = directory;
handles.s_fieldnames = fieldnames(dosecubes);
setPatName(handles);
handles.dosecubes = dosecubes;
set(handles.Plot_button, 'Enable', 'on');
guidata(hObject, handles);
enablecheckboxes(hObject, eventdata, handles)

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)

function setPatName(handles)
[~, deepestFolder] = fileparts(handles.output_directory(1:end-1));
set(handles.patname_text, 'String', deepestFolder);


% --- Executes on button press in LoadBoost_button.
function LoadBoost_button_Callback(hObject, eventdata, handles)
% hObject    handle to LoadBoost_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in structure1_checkbox.
function structure1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure1_checkbox
checkboxmanager(1, hObject, eventdata, handles);


% --- Executes on button press in structure2_checkbox.
function structure2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure2_checkbox
checkboxmanager(2, hObject, eventdata, handles);

% --- Executes on button press in structure3_checkbox.
function structure3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure3_checkbox
checkboxmanager(3, hObject, eventdata, handles);


% --- Executes on button press in structure4_checkbox.
function structure4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure4_checkbox
checkboxmanager(4, hObject, eventdata, handles);


% --- Executes on button press in structure5_checkbox.
function structure5_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure5_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure5_checkbox
checkboxmanager(5, hObject, eventdata, handles);


% --- Executes on button press in structure6_checkbox.
function structure6_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure6_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure6_checkbox
checkboxmanager(6, hObject, eventdata, handles);


% --- Executes on button press in structure7_checkbox.
function structure7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure7_checkbox
checkboxmanager(7, hObject, eventdata, handles);


% --- Executes on button press in structure8_checkbox.
function structure8_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure8_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure8_checkbox
checkboxmanager(8, hObject, eventdata, handles);


% --- Executes on button press in structure9_checkbox.
function structure9_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure9_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure9_checkbox
checkboxmanager(9, hObject, eventdata, handles);


% --- Executes on button press in structure10_checkbox.
function structure10_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure10_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure10_checkbox
checkboxmanager(10, hObject, eventdata, handles);


% --- Executes on button press in structure11_checkbox.
function structure11_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure11_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure11_checkbox
checkboxmanager(11, hObject, eventdata, handles);


% --- Executes on button press in structure12_checkbox.
function structure12_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure12_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure12_checkbox
checkboxmanager(12, hObject, eventdata, handles);


% --- Executes on button press in structure13_checkbox.
function structure13_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure13_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure13_checkbox
checkboxmanager(13, hObject, eventdata, handles);


% --- Executes on button press in structure14_checkbox.
function structure14_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure14_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure14_checkbox
checkboxmanager(14, hObject, eventdata, handles);


% --- Executes on button press in structure15_checkbox.
function structure15_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure15_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure15_checkbox
checkboxmanager(15, hObject, eventdata, handles);


% --- Executes on button press in structure16_checkbox.
function structure16_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure16_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure16_checkbox
checkboxmanager(16, hObject, eventdata, handles);


% --- Executes on button press in structure17_checkbox.
function structure17_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure17_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure17_checkbox
checkboxmanager(17, hObject, eventdata, handles);


% --- Executes on button press in structure18_checkbox.
function structure18_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure18_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure18_checkbox
checkboxmanager(18, hObject, eventdata, handles);


% --- Executes on button press in structure19_checkbox.
function structure19_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure19_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure19_checkbox
checkboxmanager(19, hObject, eventdata, handles);


% --- Executes on button press in structure20_checkbox.
function structure20_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure20_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure20_checkbox
checkboxmanager(20, hObject, eventdata, handles);


% --- Executes on button press in structure21_checkbox.
function structure21_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure21_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure21_checkbox
checkboxmanager(21, hObject, eventdata, handles);


% --- Executes on button press in structure22_checkbox.
function structure22_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure22_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure22_checkbox
checkboxmanager(22, hObject, eventdata, handles);


% --- Executes on button press in structure23_checkbox.
function structure23_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure23_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure23_checkbox
checkboxmanager(23, hObject, eventdata, handles);


% --- Executes on button press in structure24_checkbox.
function structure24_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure24_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure24_checkbox
checkboxmanager(24, hObject, eventdata, handles);


% --- Executes on button press in structure25_checkbox.
function structure25_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure25_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure25_checkbox
checkboxmanager(25, hObject, eventdata, handles);


% --- Executes on button press in structure26_checkbox.
function structure26_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure26_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure26_checkbox
checkboxmanager(26, hObject, eventdata, handles);


% --- Executes on button press in structure27_checkbox.
function structure27_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure27_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure27_checkbox
checkboxmanager(27, hObject, eventdata, handles);


% --- Executes on button press in structure28_checkbox.
function structure28_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure28_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure28_checkbox
checkboxmanager(28, hObject, eventdata, handles);


% --- Executes on button press in structure29_checkbox.
function structure29_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure29_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure29_checkbox
checkboxmanager(29, hObject, eventdata, handles);


% --- Executes on button press in structure30_checkbox.
function structure30_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure30_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure30_checkbox
checkboxmanager(30, hObject, eventdata, handles);


% --- Executes on button press in structure31_checkbox.
function structure31_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure31_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure31_checkbox
checkboxmanager(31, hObject, eventdata, handles);


% --- Executes on button press in structure32_checkbox.
function structure32_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(32, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure33_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(33, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure34_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(34, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure35_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(35, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure36_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(36, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure37_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(37, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure38_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(38, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure39_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(39, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure40_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(40, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure41_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(41, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure42_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(42, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure43_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(43, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure44_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(44, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure45_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(45, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure46_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(46, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure47_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(47, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure48_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(48, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure49_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(49, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function structure50_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(50, hObject, eventdata, handles);

% --- Executes on button press in structure32_checkbox.
function checkbox53_Callback(hObject, eventdata, handles)
% hObject    handle to structure32_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of structure32_checkbox
checkboxmanager(51, hObject, eventdata, handles);

function enablecheckboxes(hObject, eventdata, handles)
% set checkbox names
for loopIndex = 2:numel(handles.s_fieldnames)
    set(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'String', handles.s_fieldnames{loopIndex})
    set(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'Visible', 'on')
end


function checkboxmanager( number, hObject, eventdata, handles)
if get(hObject,'Value') == 1
    handles.selected_structures(number) = 1;
    r = randi([0 1]);
    g = randi([0 1]);
    b = randi([0 1]);
    set(hObject, 'ForegroundColor', [r g b]);
    if (r*g*b == 1 || (r == 1 && g == 1 && b == 0) || (r == 0 && g == 1 && b == 0) || (r == 0 && g == 1 && b == 1))
        set(hObject, 'BackgroundColor', [0 0 0]);
    end
else
    handles.selected_structures(number) = 0;
    set(hObject, 'ForegroundColor', [0 0 0]);
    set(hObject, 'BackgroundColor', [1 1 1]);
end
% Update handles structure
guidata(hObject, handles)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analyze_button.
function analyze_button_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.analyze_popupmenu, 'Value');

switch contents
    case 1 %Check structure cube (parotid, eye)
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        set(handles.next_button,'Visible', 'on');
        % get right parotid string
        set(handles.analysisresult_text,'String', 'Choose right parotid and click next');
        uiwait;
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        rpStr = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        % get left eye string
        set(handles.analysisresult_text,'String', 'Choose left eye and click next');
        uiwait;
        set(handles.next_button,'Visible', 'off');
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        leStr = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        flag = checkStructureCube_eye2(handles.dosecubes, rpStr, leStr);
        setTestResult(handles, flag);
        
    case 2 %Check structure cube (parotid, lung)
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        set(handles.next_button,'Visible', 'on');
        % get right parotid string
        set(handles.analysisresult_text,'String', 'Choose right parotid and click next');
        uiwait; % wait for clicking 'next' button
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        rpStr = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        % get left lung string
        set(handles.analysisresult_text,'String', 'Choose left lung and click next');
        uiwait; % wait for clicking 'next' button
        set(handles.next_button,'Visible', 'off');
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        leStr = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        flag = checkStructureCube_lung2(handles.dosecubes, rpStr, leStr);
        setTestResult(handles, flag);
        
    case 3 %Calculate moments
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        %{
        set(handles.next_button,'Visible', 'on');
        set(handles.analysis_radio1, 'String', 'ipsilateral');
        set(handles.analysis_radio2, 'String', 'contralateral');
        set(handles.analysis_radio3, 'Visible', 'on');
        set(handles.uipanel3,'Visible', 'on');
        set(handles.analysisresult_text,'String', 'Choose struct and its location');
        uiwait; % wait for clicking 'next' button
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        struct = handles.s_fieldnames{tmp};
        location = get(get(handles.uipanel3,'SelectedObject'),'String');
        if ~strcmp(location, 'nonlateral')
            set(handles.analysis_radio1, 'String', 'left');
            set(handles.analysis_radio2, 'String', 'right');
            set(handles.analysis_radio3, 'Visible', 'off');
            set(handles.analysisresult_text,'String', 'Left or right?');
            uiwait; % wait for clicking 'next' button
            side = get(get(handles.uipanel3,'SelectedObject'),'String');
            set(handles.analysis_radio1, 'String', 'ipsilateral');
            set(handles.analysis_radio2, 'String', 'contralateral');
            set(handles.analysis_radio3, 'Visible', 'on');
        elseif strcmp(location, 'nonlateral')
            side = 'x';
        end
        set(handles.next_button,'Visible', 'off');
        set(handles.uipanel3,'Visible', 'off');
        clearCheckboxes(hObject, eventdata, handles);
        %}
        % calculate moments
        %calculateMoments(handles.dosecubes, struct, location, side, handles.output_directory);
        set(handles.analysisresult_text,'String', 'Not implemented yet!');
        set(handles.analysisresult_text,'ForegroundColor', [0 0.5 0]);
        %{
    case 4
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        set(handles.next_button,'Visible', 'on');
        
        set(handles.analysisresult_text,'String', 'Choose contralat. parotid');
        uiwait;
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        contrapar = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        
        set(handles.analysisresult_text,'String', 'Choose ipsilat. parotid');
        uiwait;
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        ipsipar = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        
        set(handles.analysisresult_text,'String', 'Is ipsiparotid left or right?');
        set(handles.uipanel3,'Visible', 'on');
        set(handles.analysis_radio1, 'String', 'left');
        set(handles.analysis_radio2, 'String', 'right');
        set(handles.analysis_radio3, 'Visible', 'off');
        uiwait; % wait for clicking 'next' button
        side = get(get(handles.uipanel3,'SelectedObject'),'String');
        set(handles.next_button,'Visible', 'off');
        set(handles.uipanel3,'Visible', 'off');
        clearCheckboxes(hObject, eventdata, handles);
        
        calculateMoments2(handles.dosecubes, {ipsipar, contrapar}, side, handles.output_directory);
        
        set(handles.analysisresult_text,'String', 'Moments calculated!');
        set(handles.analysisresult_text,'ForegroundColor', [0 0.5 0]);
        
    case 5
        % prepare gui
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        set(handles.next_button,'Visible', 'on');
        
        % get left parotid
        set(handles.analysisresult_text,'String', 'Choose left parotid');
        uiwait;
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        leftpar = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        
        % get right parotid
        set(handles.analysisresult_text,'String', 'Choose right parotid');
        uiwait;
        tmp = lookForEnabledCheckboxes(hObject, eventdata, handles);
        rightpar = handles.s_fieldnames{tmp};
        clearCheckboxes(hObject, eventdata, handles);
        
        % clean up gui
        set(handles.next_button,'Visible', 'off');
        set(handles.uipanel3,'Visible', 'off');
        clearCheckboxes(hObject, eventdata, handles);
        
        % calculate
        calculateMoments3(handles.dosecubes, {leftpar, rightpar}, handles.output_directory);
        
        % inform when finished
        set(handles.analysisresult_text,'String', 'Moments calculated!');
        set(handles.analysisresult_text,'ForegroundColor', [0 0.5 0]);
        %}
        
    case 4 %Calculate DVH, mean dose etc.
        % prepare gui
        set(handles.analysisresult_text,'String', '');
        set(handles.analysisresult_text,'ForegroundColor', [0 0 0]);
        clearCheckboxes(hObject, eventdata, handles);
        set(handles.next_button,'Visible', 'on');
        
        % let user select structures and calculate dvhs
        set(handles.analysisresult_text,'String', 'Choose structures for dvh calculation');
        uiwait;
        struct_sel = lookForEnabledCheckboxes2(hObject, eventdata, handles);
        dvh = hg_calcdvh(handles.dosecubes, handles.s_fieldnames(struct_sel == 1));
        writetable(dvh.array, [handles.output_directory 'dvh.txt']);
        % dvh plot
        struct_sel = find(struct_sel == 1);
        for j=1:length(struct_sel)
            linecolor = get(eval(['handles.structure' ...
                num2str(struct_sel(j)-1) '_checkbox']), 'ForegroundColor');
            title = handles.s_fieldnames{struct_sel(j)};
            hg_plotdvh(dvh.args, dvh.vals.(title), linecolor, title);
            hold on;
        end
        hold off;
        
        % clean up gui
        set(handles.next_button,'Visible', 'off');
        set(handles.uipanel3,'Visible', 'off');
        clearCheckboxes(hObject, eventdata, handles);
        
        % inform when finished
        set(handles.analysisresult_text,'String', 'DVHs calculated!');
        set(handles.analysisresult_text,'ForegroundColor', [0 0.5 0]);
end

function plotDose(hObject, eventdata, handles)
struct_sel = lookForEnabledCheckboxes2(hObject, eventdata, handles);
if sum(struct_sel) == 0
    colors = [0 0 0];
else
    colors = getCheckboxColors(hObject, eventdata, handles);
end
hg_plotdose(handles.dosecubes, handles.s_fieldnames(struct_sel == 1), handles.slice, colors);



function setTestResult(handles,flag)
if flag
    set(handles.analysisresult_text,'String', 'Test passed!');
    set(handles.analysisresult_text,'ForegroundColor', [0 0.5 0]);
else
    set(handles.analysisresult_text,'String', 'Test failed!');
    set(handles.analysisresult_text,'ForegroundColor', [1 0 0]);
end

function index = lookForEnabledCheckboxes(hObject, eventdata, handles)
% set checkbox names
for loopIndex = 2:numel(handles.s_fieldnames)
    value = get(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'Value');
    if value
        index = loopIndex;
    end
end

function index = lookForEnabledCheckboxes2(hObject, eventdata, handles)
% set checkbox names
index = zeros(numel(handles.s_fieldnames)-1,1);
for loopIndex = 2:numel(handles.s_fieldnames)
    value = get(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'Value');
    if value
        index(loopIndex) = 1;
    end
end

function colors = getCheckboxColors(hObject, eventdata, handles)
% set checkbox names
%colors = zeros(numel(handles.s_fieldnames)-1,3);
index = 1;
for loopIndex = 2:numel(handles.s_fieldnames)
    value = get(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'Value');
    if value
        colors(index,:) = get(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'ForegroundColor');
        index = index+1;
    end
end

function clearCheckboxes(hObject, eventdata, handles)
% set checkbox names
for loopIndex = 2:numel(handles.s_fieldnames)
    set(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'Value', 0);
    set(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'ForegroundColor', [0 0 0]);
    set(eval(['handles.structure' num2str(loopIndex-1) '_checkbox']), 'BackgroundColor', [1 1 1]);
end
handles.selected_structures = handles.selected_structures * 0;
guidata(hObject, handles);

% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
uiresume(gcbf);


% --- Executes on selection change in analyze_popupmenu.
function analyze_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns analyze_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from analyze_popupmenu


% --- Executes during object creation, after setting all properties.
function analyze_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analyze_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%disp(get(get(handles.uipanel3,'SelectedObject'),'String'));



% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
GUI_start();


% --- Executes on button press in loadrtstruc2_button.
function loadrtstruc2_button_Callback(hObject, eventdata, handles)
% hObject    handle to loadrtstruc2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp{1} = handles.rtstruc_path;
[filename, directory] = uigetfile([handles.defaultdatapath '*.dcm'], 'Choose RTStruc...');
temp{2} = [directory filename];
handles.rtstruc_path = temp;
% Update handles structure
guidata(hObject, handles)


% --- Executes on button press in loadrtdose2.
function loadrtdose2_Callback(hObject, eventdata, handles)
% hObject    handle to loadrtdose2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp{1} = handles.rtdose_plan_path;
[filename, directory] = uigetfile([handles.defaultdatapath '*.dcm'], 'Choose RTDose Plan...');
temp{2} = [directory filename];
%temp{2} = loadRTDosePlan();
handles.rtdose_plan_path = temp;
% Update handles structure
guidata(hObject, handles)
