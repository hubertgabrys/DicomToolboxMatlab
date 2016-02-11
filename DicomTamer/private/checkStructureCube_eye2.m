function flag = checkStructureCube_eye2( dosecubes, rpStr, leStr )
%
% xVec is a sagittal axis. It goes from anterior to posterior.
% yVec is a transverse axis. It goes form the right to the left; in case of
% parotis it is always from medial to lateral
% zVec is a longitudinal axis. It goes from superior to inferior
%
% SA - sagittal axis
% TA - transverse axis
% VA - vertical axis
%
% dosecube is TA x SA x VA
%

dc = dosecubes.dosecube.dosecube;
indmsk = dosecubes.(rpStr).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
dc(dc == 0 & indmsk == 1) = 0.00001;

structure_dosecube = dc .* indmsk;
dosecube_xVector = dosecubes.dosecube.dosecube_xVector;
dosecube_yVector = dosecubes.dosecube.dosecube_yVector;
dosecube_zVector = dosecubes.dosecube.dosecube_zVector;

%% Crop cube
SA_Min_parotidR = 0;
SA_Max_parotidR = 0;
TA_Min_parotidR = 0;
TA_Max_parotidR = 0;
VA_Min_parotidR = 0;
VA_Max_parotidR = 0;
for i=1:length(dosecube_xVector)
    if sum(sum(structure_dosecube(i,:,:))) > 0
        if SA_Min_parotidR==0
            SA_Min_parotidR = i;
        end
        if i>SA_Max_parotidR
            SA_Max_parotidR = i;
        end
    end
end
for i=1:length(dosecube_yVector)
    if sum(sum(structure_dosecube(:,i,:))) > 0
        if TA_Min_parotidR==0
            TA_Min_parotidR = i;
        end
        if i>TA_Max_parotidR
            TA_Max_parotidR = i;
        end
    end
end
for i=1:length(dosecube_zVector)
    if sum(sum(structure_dosecube(:,:,i))) > 0
        if VA_Min_parotidR==0
            VA_Min_parotidR = i;
        end
        if i>VA_Max_parotidR
            VA_Max_parotidR = i;
        end
    end
end

%% Load left eye
dc = dosecubes.dosecube.dosecube;
indmsk = dosecubes.(leStr).indicator_mask;
% in case that there are voxels with 0 dose inside volume, change 0
% to 0.00001 (or any small value)
dc(dc == 0 & indmsk == 1) = 0.0001;
structure_dosecube = dc .* indmsk;

%% Crop cube
SA_Min_eyeL = 0;
SA_Max_eyeL = 0;
TA_Min_eyeL = 0;
TA_Max_eyeL = 0;
VA_Min_eyeL = 0;
VA_Max_eyeL = 0;
for i=1:length(dosecube_xVector)
    if sum(sum(structure_dosecube(i,:,:))) > 0
        if SA_Min_eyeL==0
            SA_Min_eyeL = i;
        end
        if i>SA_Max_eyeL
            SA_Max_eyeL = i;
        end
    end
end
for i=1:length(dosecube_yVector)
    if sum(sum(structure_dosecube(:,i,:))) > 0
        if TA_Min_eyeL==0
            TA_Min_eyeL = i;
        end
        if i>TA_Max_eyeL
            TA_Max_eyeL = i;
        end
    end
end
for i=1:length(dosecube_zVector)
    if sum(sum(structure_dosecube(:,:,i))) > 0
        if VA_Min_eyeL==0
            VA_Min_eyeL = i;
        end
        if i>VA_Max_eyeL
            VA_Max_eyeL = i;
        end
    end
end

flag = false;
fprintf('VA_Min_parotidR %f should be larger than VA_Max_eyeL %f\n', ...
    VA_Min_parotidR, VA_Max_eyeL);
if VA_Min_parotidR>VA_Max_eyeL
    disp('TRUE!')
    fprintf('TA_Min_eyeL %f should be larger than TA_Max_parotidR %f\n',...
        TA_Min_eyeL, TA_Max_parotidR);
    if TA_Min_eyeL>TA_Max_parotidR
        disp('TRUE!')
        flag = true;
    else
        disp('FALSE!')
    end
else
    disp('FALSE!')
end
end