function sort_dicoms()
%hg_sortdicoms function categorizes and anonymizes dicomfiles
%   hg_sortdicoms asks for a folder containing .dcm files to be sorted. User
%   have to provide output directory and a file with anonymization key as
%   well.
%   Anonymization key should be a tab separated file with two columns of
%   strings. First column contain anonymized patientID second column
%   contain oryginal patientID.
%   Example:
%   HN001	"0000932325"
%   HN002	"0002178787"
%   HN003	"0001387462"
%
% h.gabrys@dkfz.de, 2014

input_directory = chooseInputDir(); % choose directory containing dicom files to be compiled
output_directory = input_directory; % choose directory were files after compilation are to be stored
%output_directory = chooseOutputDir(); % choose directory were files after compilation are to be stored
%anonymization_key_path = chooseAnonymizationKey(); % choose file with key for anonymization of patients IDs


input_files_list = dir(input_directory); % get a list of input files
input_files_list = input_files_list(3:end); % discard first two files (which are '.' and '..')

fprintf('List of patient''s files:\n')
for i = 1:length(input_files_list) % for every file of a given patient
    fprintf('\t%d: %s\n', i, input_files_list(i).name); % print the name of the file
    %% load dicominfo
    input_file_filename = input_files_list(i).name; % get name of  a file
    input_file_dicominfo = read_dicominfo([input_directory input_file_filename], true, false); 
    %% modify dicominfo
    input_file_dicominfo = fillOutMissingIDs(input_file_dicominfo);
    input_file_dicominfo = replaceNonalphanumericSymbols(input_file_dicominfo);
    %input_file_dicominfo = anonymizePatientID(input_file_dicominfo, anonymization_key_path);
    %% create folders
    createPatientFolders(output_directory, input_file_dicominfo);
    %% copy files
    copy2rightDir(input_directory, input_files_list(i), output_directory, input_file_dicominfo);
end
end


function input_directory = chooseInputDir()
    uiwait(warndlg('Choose Input Directory'));
    input_directory = uigetdir('', 'Choose Input Directory...');
    input_directory = [input_directory '\'];
end


function input_file_dicominfo = fillOutMissingIDs(input_file_dicominfo)
    if isempty(input_file_dicominfo.PatientID)
        input_file_dicominfo.PatientID = 'no_patientID';
    end
    if isempty(input_file_dicominfo.StudyInstanceUID)
        input_file_dicominfo.StudyInstanceUID = 'no_studyinstanceUID';
    end
    if isempty(input_file_dicominfo.Modality)
        input_file_dicominfo.Modality = 'no_modality';
    end
end


function input_file_dicominfo = replaceNonalphanumericSymbols(input_file_dicominfo)
    input_file_dicominfo.PatientID(~isstrprop(input_file_dicominfo.PatientID, 'alphanum')) = ...
        '_'; % change all nonalphanumeric values in PatientID to underscore
    input_file_dicominfo.StudyInstanceUID(~isstrprop(input_file_dicominfo.StudyInstanceUID, 'alphanum')) = ...
        '_'; % change all nonalphanumeric values in StudyInstanceUID to underscore
    input_file_dicominfo.SeriesInstanceUID(~isstrprop(input_file_dicominfo.SeriesInstanceUID, 'alphanum')) = ...
        '_'; % change all nonalphanumeric values in SeriesInstanceUID to underscore
    input_file_dicominfo.Modality(~isstrprop(input_file_dicominfo.Modality, 'alphanum')) = ...
        '_'; % change all nonalphanumeric values in Modality to underscore
end


function copy2rightDir(input_directory, patientFilesList, output_directory, temp)
source = [input_directory '/' patientFilesList.name];
destination = [output_directory '/' temp.PatientID '/' temp.Modality '/' patientFilesList.name];
copyfile(source, destination);
copyfile(source, [output_directory '/' temp.PatientID '/batch/' patientFilesList.name]);
end


function createPatientFolders(output_directory, temp)
patientPath = [output_directory '/' temp.PatientID];
if exist(patientPath, 'dir') == 7
    createModalityFolders(patientPath, temp);
else
    mkdir(patientPath);
    mkdir([patientPath '/batch']);
    createModalityFolders(patientPath, temp);
end
end


function createModalityFolders(patientPath, temp)
modalityPath = [patientPath '/' temp.Modality];
if exist(modalityPath, 'dir') ~= 7
    mkdir(modalityPath);
end
end


%% LIMBO

function input_file_dicominfo = anonymizePatientID (input_file_dicominfo, anonymization_key_path)
    keyCells = table2cell(readtable(anonymization_key_path, ...
        'ReadVariableNames', false, 'Delimiter', '\t')); % read the anonymization key from file
    ind = ismember(keyCells(:,2),input_file_dicominfo.PatientID); % find index of patient in the key
    if sum(ind) == 1 % patiend id was found in anoKey.dat
        input_file_dicominfo.PatientID = keyCells{ind,1}; % change patID according to the key
    end
end

function anonymizeFilenames

end

function anonymizeDicomFields

end

function input_file_dicominfo = loadDicomInfo(input_directory, filename)
    input_file_dicominfo = read_dicominfo([input_directory filename], true, false);
    %% take care of missing IDs
    if isempty(input_file_dicominfo.PatientID)
        input_file_dicominfo.PatientID = 'no_patientID';
    end
    if isempty(input_file_dicominfo.StudyInstanceUID)
        input_file_dicominfo.StudyInstanceUID = 'no_studyinstanceUID';
    end
    if isempty(input_file_dicominfo.Modality)
        input_file_dicominfo.Modality = 'no_modality';
    end
    %% take care of nonalphanumeric symbols
    input_file_dicominfo.PatientID(~isstrprop(input_file_dicominfo.PatientID, 'alphanum')) = '_'; % change all nonalphanumeric values in PatientID to underscore
    input_file_dicominfo.StudyInstanceUID(~isstrprop(input_file_dicominfo.StudyInstanceUID, 'alphanum')) = '_'; % change all nonalphanumeric values in StudyInstanceUID to underscore
    input_file_dicominfo.SeriesInstanceUID(~isstrprop(input_file_dicominfo.SeriesInstanceUID, 'alphanum')) = '_'; % change all nonalphanumeric values in SeriesInstanceUID to underscore
    input_file_dicominfo.Modality(~isstrprop(input_file_dicominfo.Modality, 'alphanum')) = '_'; % change all nonalphanumeric values in Modality to underscore
    %% anonymize Patient ID
    key = 'data/anoKey.dat'; % key path
    keyCells = table2cell(readtable(key, 'ReadVariableNames', false, 'Delimiter', '\t')); % read the anonymization key from file
    ind = ismember(keyCells(:,2),input_file_dicominfo.PatientID); % find index of patient in the key
    if sum(ind) == 1 % patiend id was found in anoKey.dat
        input_file_dicominfo.PatientID = keyCells{ind,1}; % change patID according to the key
    end
end

function output_directory = chooseOutputDir()
    uiwait(warndlg('Choose Output Directory'));
    output_directory = uigetdir('', 'Choose Output Directory...');
    output_directory = [output_directory '\'];
end

function anonymization_key_path = chooseAnonymizationKey()
    uiwait(warndlg('Choose Anonymization Key'));
    [anonymization_key_filename, anonymization_key_directory] = uigetfile('*.*', 'Choose Anonymization Key...');
    anonymization_key_path = [anonymization_key_directory '\' anonymization_key_filename];
end