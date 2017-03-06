function varargout = dicom_import_gui(varargin)
% DICOM_IMPORT_GUI MATLAB code for dicom_import_gui.fig
%      DICOM_IMPORT_GUI, by itself, creates a new DICOM_IMPORT_GUI or raises the existing
%      singleton*.
%
%      H = DICOM_IMPORT_GUI returns the handle to a new DICOM_IMPORT_GUI or the handle to
%      the existing singleton*.
%
%      DICOM_IMPORT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_IMPORT_GUI.M with the given input arguments.
%
%      DICOM_IMPORT_GUI('Property','Value',...) creates a new DICOM_IMPORT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dicom_import_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dicom_import_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dicom_import_gui

% Last Modified by GUIDE v2.5 06-Mar-2017 19:37:53


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dicom_import_gui_OpeningFcn, ...
    'gui_OutputFcn',  @dicom_import_gui_OutputFcn, ...
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


% --- Executes just before dicom_import_gui is made visible.
function dicom_import_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dicom_import_gui (see VARARGIN)

% Choose default command line output for dicom_import_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dicom_import_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dicom_import_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_button.
function patDir = browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uiwait(warndlg('Choose the input directory'));
patDir = uigetdir('', 'Choose the input directory...');
if patDir ~= 0
    %patDir = [patDir '\'];
    set(handles.dir_path_field,'String',patDir);
    % Update handles structure
    guidata(hObject, handles);
    scan(hObject, eventdata, handles)
end

function scan(hObject, eventdata, handles)
% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;
[fileList, patient_listbox] = scan_import_dir(get(handles.dir_path_field,'String'));
if iscell(patient_listbox)
    handles.fileList =  fileList;
    set(handles.patient_listbox,'String',patient_listbox);
    guidata(hObject, handles);
end
% set back an arrow
set(handles.figure1, 'pointer', oldpointer)

% --- Executes on selection change in patient_listbox.
function patient_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to patient_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns patient_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from patient_listbox

if ~isempty(get(hObject,'String'))
    % enable Import button
    set(handles.import_button,'Enable','on');
    
    % handles.filelist:
    %   1. Filepath
    %   2. Modality
    %   3. PatientID
    %   4. SeriesUID
    %   5. SeriesNumber
    %   9. res_x
    %   10. res_y
    %   11. res_z
    patient_listbox = get(handles.patient_listbox,'String');
    selected_patient = patient_listbox(get(handles.patient_listbox,'Value'));
    if get(handles.SeriesUID_radiobutton,'Value') == 1
        % this gets a list of ct series for this patient
        set(handles.ctseries_listbox,'Value',1); % set dummy value to one
        set(handles.ctseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient),4)));
        % this gets a list of rtss series for this patient
        set(handles.rtseries_listbox,'Value',1); % set dummy value to one
        set(handles.rtseries_listbox,'String',handles.fileList(strcmp(handles.fileList(:,2), 'RTSTRUCT') & strcmp(handles.fileList(:,3), selected_patient),4));
        % this gets a list of rtdose series for this patient
        set(handles.rtdoseseries_listbox,'Value',1); % set dummy value to one
        set(handles.rtdoseseries_listbox,'String',handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient),4));
        % this gets a ct resolution for this patient
        selectedCtSeriesString = get(handles.ctseries_listbox,'String');
        if ~isempty(selectedCtSeriesString)
            ct_res_x = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),9));
            ct_res_y = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),10));
            ct_res_z = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),11));
        else
            ct_res_x = NaN; ct_res_y = NaN; ct_res_z = NaN;
        end
        % this gets an rtdose resolution for this patient
        selectedRTdoseSeriesString = get(handles.rtdoseseries_listbox,'String');
        if ~isempty(selectedRTdoseSeriesString)
            rtdose_res_x = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),9));
            rtdose_res_y = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),10));
            try
                rtdose_res_z = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),11));
            catch ME
                rtdose_res_z = handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,4), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),11);
                if isnan(rtdose_res_z{1})
                    set(handles.registerRTDOSE_button, 'Value',1);
                end
            end
        else
            rtdose_res_x = NaN; rtdose_res_y = NaN; rtdose_res_z = NaN;
        end
    else
        set(handles.ctseries_listbox,'Value',1); % set dummy value to one
        set(handles.ctseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient),5)));
        set(handles.rtseries_listbox,'Value',1); % set dummy value to one
        set(handles.rtseries_listbox,'String',handles.fileList(strcmp(handles.fileList(:,2), 'RTSTRUCT') & strcmp(handles.fileList(:,3), selected_patient),5));
        set(handles.rtdoseseries_listbox,'Value',1); % set dummy value to one
        set(handles.rtdoseseries_listbox,'String',handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient),4));
        selectedCtSeriesString = get(handles.ctseries_listbox,'String');
        if ~isempty(selectedCtSeriesString)
            ct_res_x = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),9));
            ct_res_y = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),10));
            ct_res_z = unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedCtSeriesString{get(handles.ctseries_listbox,'Value')}),11));
        else
            ct_res_x = NaN; ct_res_y = NaN; ct_res_z = NaN;
        end
        selectedRTdoseSeriesString = get(handles.rtdoseseries_listbox,'String');
        if ~isempty(selectedRTdoseSeriesString)
            rtdose_res_x = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),9));
            rtdose_res_y = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),10));
            rtdose_res_z = unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,5), selectedRTdoseSeriesString{get(handles.rtdoseseries_listbox,'Value')}),11));
        else
            rtdose_res_x = NaN; rtdose_res_y = NaN; rtdose_res_z = NaN;
        end
    end
    set(handles.resx_edit,'String',ct_res_x);
    set(handles.resy_edit,'String',ct_res_y);
    if numel(ct_res_z) > 1
        set(handles.resz_edit,'String','not equi');
    else
        set(handles.resz_edit,'String',ct_res_z);
    end
    set(handles.rtdose_resx_edit,'String',rtdose_res_x);
    set(handles.rtdose_resy_edit,'String',rtdose_res_y);
    if numel(ct_res_z) > 1
        set(handles.rtdose_resz_edit,'String','not equi');
    else
        set(handles.rtdose_resz_edit,'String',rtdose_res_z);
    end
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function patient_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ctseries_listbox.
function ctseries_listbox_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ctseries_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rtseries_listbox.
function rtseries_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to rtseries_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rtseries_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rtseries_listbox


% --- Executes during object creation, after setting all properties.
function rtseries_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtseries_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
% hObject    handle to import_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% show the hourglass during computation
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

patient_listbox = get(handles.patient_listbox,'String');
ctseries_listbox = get(handles.ctseries_listbox,'String');
%rtseries_listbox = get(handles.rtseries_listbox,'String');
%rtdoseseries_listbox = get(handles.rtdoseseries_listbox,'String');
selected_patient = patient_listbox(get(handles.patient_listbox,'Value'));
if isempty(ctseries_listbox)
    dicompaths.ct = cell(0,1);
else
    selected_ctseries = ctseries_listbox(get(handles.ctseries_listbox,'Value'));
    %selected_rtseries = rtseries_listbox(get(handles.rtseries_listbox,'Value'));
    %selected_rtdoseseries = rtdoseseries_listbox(get(handles.rtdoseseries_listbox,'Value'));
    
    if get(handles.SeriesUID_radiobutton,'Value') == 1
        dicompaths.ct = handles.fileList(strcmp(handles.fileList(:,3), selected_patient) & ...
            strcmp(handles.fileList(:,4), selected_ctseries),:);
    else
        dicompaths.ct = handles.fileList(strcmp(handles.fileList(:,3), selected_patient) & ...
            strcmp(handles.fileList(:,5), selected_ctseries),:);
    end
end

allRtss = handles.fileList(strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,2),'RTSTRUCT'),:);
dicompaths.rtss = allRtss(get(handles.rtseries_listbox,'Value'),:);

allRtdose = handles.fileList(strcmp(handles.fileList(:,3), selected_patient) & strcmp(handles.fileList(:,2),'RTDOSE'),:);
if get(handles.registerRTDOSE_button,'Value')
    dicompaths.rtdose = allRtdose(:,1);
else
    dicompaths.rtdose = allRtdose(get(handles.rtdoseseries_listbox,'Value'),1);
end

dicompaths.resolution = str2double(get(handles.edit10, 'String'));
dicompaths.save_matfile = true;
dicompaths.default_save_path = false;

dicom_import(dicompaths);

% set back an arrow
set(handles.figure1, 'pointer', oldpointer)

close(handles.figure1);


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes on button press in rescan_button.
function rescan_button_Callback(hObject, eventdata, handles)
% hObject    handle to rescan_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dir_path_field_Callback(hObject, eventdata, handles)
% hObject    handle to dir_path_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dir_path_field as text
%        str2double(get(hObject,'String')) returns contents of dir_path_field as a double

patDir = get(handles.dir_path_field,'String');
if patDir(end) ~= '\';
    patDir = [patDir '\'];
    set(handles.dir_path_field,'String',patDir);
    guidata(hObject, handles);
end
scan(hObject, eventdata, handles);


% --- Executes on button press in SeriesUID_radiobutton.
function SeriesUID_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to SeriesUID_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 1
    set(handles.SeriesNumber_radiobutton,'Value',0);
else
    set(hObject,'Value',1);
    set(handles.SeriesNumber_radiobutton,'Value',0);
end
patient_listbox = get(handles.patient_listbox,'String');
selected_patient = patient_listbox(get(handles.patient_listbox,'Value'));
set(handles.ctseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient),4)));
set(handles.rtseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTSTRUCT') & strcmp(handles.fileList(:,3), selected_patient),4)));
set(handles.rtdoseseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient),4)));
guidata(hObject, handles);

% --- Executes on button press in SeriesNumber_radiobutton.
function SeriesNumber_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to SeriesNumber_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.SeriesUID_radiobutton,'Value',0);
else
    set(hObject,'Value',1);
    set(handles.SeriesUID_radiobutton,'Value',0);
end
patient_listbox = get(handles.patient_listbox,'String');
selected_patient = patient_listbox(get(handles.patient_listbox,'Value'));
set(handles.ctseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'CT') & strcmp(handles.fileList(:,3), selected_patient),5)));
set(handles.rtseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTSTRUCT') & strcmp(handles.fileList(:,3), selected_patient),5)));
set(handles.rtdoseseries_listbox,'String',unique(handles.fileList(strcmp(handles.fileList(:,2), 'RTDOSE') & strcmp(handles.fileList(:,3), selected_patient),5)));
guidata(hObject, handles);



function resx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resx_edit as text
%        str2double(get(hObject,'String')) returns contents of resx_edit as a double


% --- Executes during object creation, after setting all properties.
function resx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resy_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resy_edit as text
%        str2double(get(hObject,'String')) returns contents of resy_edit as a double


% --- Executes during object creation, after setting all properties.
function resy_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resz_edit as text
%        str2double(get(hObject,'String')) returns contents of resz_edit as a double


% --- Executes during object creation, after setting all properties.
function resz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%
% % --- Executes on selection change in ctseries_listbox.
% function ctseries_listbox_Callback(hObject, eventdata, handles)
% % hObject    handle to ctseries_listbox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: contents = cellstr(get(hObject,'String')) returns ctseries_listbox contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from ctseries_listbox
%
%
% % --- Executes during object creation, after setting all properties.
% function ctseries_listbox_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ctseries_listbox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
%
%
% % --- Executes on selection change in rtseries_listbox.
% function rtseries_listbox_Callback(hObject, eventdata, handles)
% % hObject    handle to rtseries_listbox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: contents = cellstr(get(hObject,'String')) returns rtseries_listbox contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from rtseries_listbox
%
%
% % --- Executes during object creation, after setting all properties.
% function rtseries_listbox_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to rtseries_listbox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on selection change in rtdoseseries_listbox.
function rtdoseseries_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to rtdoseseries_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rtdoseseries_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rtdoseseries_listbox


% --- Executes during object creation, after setting all properties.
function rtdoseseries_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtdoseseries_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rtdose_resx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rtdose_resx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rtdose_resx_edit as text
%        str2double(get(hObject,'String')) returns contents of rtdose_resx_edit as a double


% --- Executes during object creation, after setting all properties.
function rtdose_resx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtdose_resx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rtdose_resy_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rtdose_resy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rtdose_resy_edit as text
%        str2double(get(hObject,'String')) returns contents of rtdose_resy_edit as a double


% --- Executes during object creation, after setting all properties.
function rtdose_resy_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtdose_resy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rtdose_resz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rtdose_resz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rtdose_resz_edit as text
%        str2double(get(hObject,'String')) returns contents of rtdose_resz_edit as a double


% --- Executes during object creation, after setting all properties.
function rtdose_resz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtdose_resz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in registerRTDOSE_button.
function registerRTDOSE_button_Callback(hObject, eventdata, handles)

