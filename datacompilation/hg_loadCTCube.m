function [cube, xVec, yVec, zVec] = hg_loadCTCube(input_files_list)
% The function takes a list (cell) of paths to CT dicom files and returns
% the CT cube and cube grid vectors.
% 
% Hubert Gabrys <h.gabrys@dkfz.de>, 2015
% This file is licensed under GPLv2
%

for i = 1:length(input_files_list) % for every file of a given patient
    %% load dicominfo
    dicom_info = dicominfo(input_files_list{i});
    cube(:,:,i) = dicomread(dicom_info);
    zVec(i,1) = dicom_info.ImagePositionPatient(3);
end
xVec = dicom_info.ImagePositionPatient(2) + (0:double(dicom_info.Rows-1))' * dicom_info.PixelSpacing(2);
yVec = dicom_info.ImagePositionPatient(1) + (0:double(dicom_info.Columns-1))' * dicom_info.PixelSpacing(1);

% ensure that zVec is monotonic
[zVec, idx] = sort(zVec, 'descend');
cube = cube(:,:,idx);

if zVec(2) - zVec(1) > 0 % Flip cube if zVec is ascending
    zVec(:,1) = flip(zVec);
    cube = flip(cube, 3);
end
end