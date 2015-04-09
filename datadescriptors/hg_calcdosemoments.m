function output = hg_calcdosemoments(tps_data, strucname, mom_def)
%
% xVec is a sagittal axis. It goes from anterior to posterior.
% yVec is a transverse axis. It goes form the right to the left; in case of
% parotis it is always from medial to lateral
% zVec is a longitudinal axis. It goes from superior to inferior
% mom_def = [0 0 0; eye(3); 1 1 0; 1 0 1; 0 1 1; 1 1 1; 2*eye(3); 3*eye(3)];
% mom_def = npermutek(0:4,3);
%
% SA - sagittal axis
% TA - transverse axis
% VA - vertical axis
%
% dosecube is SA x TA x VA
% http://www.pt.ntu.edu.tw/hmchai/PTglossary/kines.files/CardinalPlane.gif
%
% strucnames{1} = left parotid
% strucnames{2} = right parotid
%
%% Parameters
% Specify moments you want to have calculated.
shift = 'zero';
interp_method = 'nearest';
interp_interval = 2.5;

%% Calculate moments
mom_val = size(1,length(mom_def)); % prealocation
iterator = 1;

%disp(strucname);
%% Load dosecube
struct_dc = tps_data.dose.cube .* tps_data.structures.(strucname).indicator_mask;
struct_x1gv = tps_data.dose.xVec;
struct_x2gv = tps_data.dose.yVec;
struct_x3gv = tps_data.dose.zVec;

%% Crop dosecube
[struct_dc, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(struct_dc, struct_x1gv, struct_x2gv, struct_x3gv, shift);

%% Remove planes within the structure dosecube where strucutre contour is not defined
for k=1:length(struct_x3gv)
    if ~sum(sum(struct_dc(:,:,k)))
        error('Remove planes within the structure dosecube where strucutre contour is not defined!');
    end
end

%% Interpolate dosecube
[X1o,X2o,X3o] = ndgrid(struct_x1gv, struct_x2gv, struct_x3gv);
struct_x1gvi = struct_x1gv(1):interp_interval:struct_x1gv(end);
struct_x2gvi = struct_x2gv(1):interp_interval:struct_x2gv(end);
struct_x3gvi = struct_x3gv(1):interp_interval:struct_x3gv(end);
[X1i,X2i,X3i] = ndgrid(struct_x1gvi, struct_x2gvi, struct_x3gvi);
struct_dc2 = interpn(X1o,X2o,X3o,struct_dc,X1i,X2i,X3i,interp_method);
%disp('dosecube interpolated');

%% Calculate moments
for k = 1:size(mom_def,1) % for every moment setup
    mom_val(iterator,k) = hg_calcmom3d(struct_dc2, mom_def(k,1), mom_def(k,2), mom_def(k,3),'scale');
    % if the model was trained by taking into account dimensional
    % factor (interp_interval) then another normalization factor
    % must be introduced
    mom_val(iterator,k) = mom_val(iterator,k)*interp_interval^(sum(mom_def(k,:)));
end



%% output
variablenames = strrep(num2cell(num2str(mom_def),2), ' ', '')';
variablenames = cellfun(@(v) ['m' v], variablenames, 'Uniform', 0);
output = array2table(mom_val, 'VariableNames', variablenames);
%t2 = array2table({'ipsi' 'left'; 'contra' 'right'; 'ipsi' 'right'; 'contra' 'left'}, 'VariableNames', {'lateral' 'side'});
%output = [t2 t1];
%disp('Moments calculated');

end