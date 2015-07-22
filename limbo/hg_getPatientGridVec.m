function [xVec, yVec, zVec] = hg_getPatientGridVec(input)
% This function returns grid vectors defined in RTDOSE dicom file. Input
% can be provided as a path to the file or a result of dicominfo() matlab 
% function.
%
% Hubert Gabrys <h.gabrys@dkfz.de>, 2015
% This file is licensed under GPLv2
%

if ischar(input)
    dicom_info = dicominfo(file_path);
else
    dicom_info = input;
end

% gets grid vectors of a dose cube
xVec = dicom_info.ImagePositionPatient(2) + ...
    (0:double(dicom_info.Rows-1))' * dicom_info.PixelSpacing(2);
yVec = dicom_info.ImagePositionPatient(1) + ...
    (0:double(dicom_info.Columns-1))' * dicom_info.PixelSpacing(1);
% get offset
if dicom_info.GridFrameOffsetVector(1) ~= 0
    offset = dicom_info.GridFrameOffsetVector - ...
        dicom_info.GridFrameOffsetVector(1);
else
    offset = dicom_info.GridFrameOffsetVector;
end
zVec = dicom_info.ImagePositionPatient(3) + offset;
end