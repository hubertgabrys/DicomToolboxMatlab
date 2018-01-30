function [cube, xVec, yVec, zVec] = load_ct_cube(input_files_list)
% The function takes a list (cell) of paths to CT dicom files and returns
% the CT cube and cube grid vectors.
% 
% the cube is in LPS coordinate system (Anterior->Posterior, Right->Left,
% Inferior->Superior)
% http://www.itk.org/Wiki/images/thumb/f/f8/ImageOrientationStandard.png/800px-ImageOrientationStandard.png
%
% Hubert Gabrys <hubert.gabrys@gmail.com>, 2015-2016
% License MIT
%

for i = 1:length(input_files_list) % for every file of a given patient
    %% load dicominfo
    dicom_info = read_dicominfo(input_files_list{i}, true, false);
    cube(:,:,i) = dicomread(dicom_info);
    zVec(i,1) = dicom_info.ImagePositionPatient(3);
end

if dicom_info.ImageOrientationPatient(1) == 1 && dicom_info.ImageOrientationPatient(2) == 0 && dicom_info.ImageOrientationPatient(3) == 0
    yVec = dicom_info.ImagePositionPatient(2) + (0:double(dicom_info.Rows-1))' * dicom_info.PixelSpacing(2);
elseif dicom_info.ImageOrientationPatient(1) == -1 && dicom_info.ImageOrientationPatient(2) == 0 && dicom_info.ImageOrientationPatient(3) == 0
    yVec = dicom_info.ImagePositionPatient(2) - (0:double(dicom_info.Rows-1))' * dicom_info.PixelSpacing(2);
    yVec = sort(yVec);
    cube = flip(cube,1);
else
    error('Not supported patient''s orientation');
end

if dicom_info.ImageOrientationPatient(4) == 0 && dicom_info.ImageOrientationPatient(5) == 1 && dicom_info.ImageOrientationPatient(6) == 0
    xVec = dicom_info.ImagePositionPatient(1) + (0:double(dicom_info.Columns-1))' * dicom_info.PixelSpacing(1);
elseif dicom_info.ImageOrientationPatient(4) == 0 && dicom_info.ImageOrientationPatient(5) == -1 && dicom_info.ImageOrientationPatient(6) == 0
    xVec = dicom_info.ImagePositionPatient(1) - (0:double(dicom_info.Columns-1))' * dicom_info.PixelSpacing(1);
    xVec = sort(xVec);
    cube = flip(cube,2);
else
    error('Not supported patient''s orientation');
end

% ensure that zVec is monotonic
[zVec, idx] = sort(zVec);
cube = cube(:,:,idx);

end