function [ fileList, patientList ] = scan_import_dir( patDir )
% get information about main directory
mainDirInfo = dir(patDir);
% get index of subfolders
dirIndex = [mainDirInfo.isdir];
% list of filenames in main directory
fileList = {mainDirInfo(~dirIndex).name}';
patientList = 0;

% create full path for all files in main directory
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(patDir,x),...
        fileList, 'UniformOutput', false);
    
    %% check for dicom files and differentiate patients, types, and series
    numOfFiles = numel(fileList(:,1));
    %h = waitbar(0,'Please wait...');
    %h.WindowStyle = 'Modal';
    %steps = numOfFiles;
    for i = numOfFiles:-1:1
        %waitbar((numOfFiles+1-i) / steps)
        try 
            info = read_dicominfo(fileList{i}, true, false);
        catch
            fileList(i,:) = [];
            continue;
        end
        try
            fileList{i,2} = info.Modality;
        catch
            fileList{i,2} = NaN;
        end
        try
            fileList{i,3} = info.PatientID;
        catch
            fileList{i,3} = NaN;
        end
        try
            fileList{i,4} = info.SeriesInstanceUID;
        catch
            fileList{i,4} = NaN;
        end
        try
            fileList{i,5} = num2str(info.SeriesNumber);
        catch
            fileList{i,5} = NaN;
        end
        try
            fileList{i,6} = info.PatientName.FamilyName;
        catch
            fileList{i,6} = NaN;
        end
        try
            fileList{i,7} = info.PatientName.GivenName;
        catch
            fileList{i,7} = NaN;
        end
        try
            fileList{i,8} = info.PatientBirthDate;
        catch
            fileList{i,8} = NaN;
        end
        try
            if strcmp(info.Modality,'CT') || strcmp(info.Modality,'RTDOSE')
                fileList{i,9} = num2str(info.PixelSpacing(1));
            else
                fileList{i,9} = NaN;
            end
        catch
            fileList{i,9} = NaN;
        end
        try
            if strcmp(info.Modality,'CT') || strcmp(info.Modality,'RTDOSE')
                fileList{i,10} = num2str(info.PixelSpacing(2));
            else
                fileList{i,10} = NaN;
            end
        catch
            fileList{i,10} = NaN;
        end
        try
            if strcmp(info.Modality,'CT') || strcmp(info.Modality,'RTDOSE')
                slicethickness = info.SliceThickness;
                if slicethickness ~= 0
                    fileList{i,11} = num2str(slicethickness);
                else
                    slicethickness = abs(info.GridFrameOffsetVector(1)-info.GridFrameOffsetVector(end))/(length(info.GridFrameOffsetVector)-1);
                    fileList{i,11} = num2str(slicethickness);
                end
            else
                fileList{i,11} = NaN;
            end
        catch
            fileList{i,11} = NaN;
        end     
    end
    %close(h)
    
    if ~isempty(fileList)
        patientList = unique(fileList(:,3));
    end
else
    msgbox('Search folder empty!', 'Error','error');   
end
end