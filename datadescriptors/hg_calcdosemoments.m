function output = hg_calcdosemoments(dosecubes, strucnames, mom_def)
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
mom_val = size(length(strucnames),length(mom_def)); % prealocation
iterator = 1;
for j = 1:2
    if j == 1
        ipsiside = 'left';
    elseif j == 2
        ipsiside = 'right';
        % algotithm assumes that input{1} is ipsi parotid and input{2} is
        % contraparotid so input needs to be fliped.
        strucnames = flip(strucnames);
    end
    for i=1:length(strucnames) % for each dosecube
        disp(ipsiside);
        disp(strucnames{i});
        %% Load dosecube
        struct_dc = dosecubes.dosecube.dosecube .* dosecubes.(strucnames{i}).indicator_mask;
        struct_x1gv = dosecubes.dosecube.dosecube_xVector;
        struct_x2gv = dosecubes.dosecube.dosecube_yVector;
        struct_x3gv = dosecubes.dosecube.dosecube_zVector;
        
        %% Crop dosecube
        [struct_dc, struct_x1gv, struct_x2gv, struct_x3gv] = hg_cropcube(struct_dc, struct_x1gv, struct_x2gv, struct_x3gv, shift);
        
        %% Remove planes within the structure dosecube where strucutre contour is not defined
        l = 1;
        for k=1:length(struct_x3gv)
            if sum(sum(struct_dc(:,:,k)))
                struct_dc_new(:,:,l) = struct_dc(:,:,k);
                struct_x3gv_new(l,1) = struct_x3gv(k);
                l = l+1;
            end
        end
        struct_dc = struct_dc_new;
        struct_x3gv = struct_x3gv_new;
        clear struct_dc_new struct_x3gv_new
        
        %% Interpolate dosecube
        [X1o,X2o,X3o] = ndgrid(struct_x1gv, struct_x2gv, struct_x3gv);
        struct_x1gvi = struct_x1gv(1):interp_interval:struct_x1gv(end);
        struct_x2gvi = struct_x2gv(1):interp_interval:struct_x2gv(end);
        struct_x3gvi = struct_x3gv(1):interp_interval:struct_x3gv(end);
        [X1i,X2i,X3i] = ndgrid(struct_x1gvi, struct_x2gvi, struct_x3gvi);
        struct_dc2 = interpn(X1o,X2o,X3o,struct_dc,X1i,X2i,X3i,interp_method);
        disp('dosecube interpolated');
        
        %% Flip dosecube if needed
        if strcmp(ipsiside, 'right')
            struct_dc2 = flip(struct_dc2, 2);
            disp('dosecube flipped');
        end
        
        %% Calculate moments
        for k = 1:size(mom_def,1) % for every moment setup
            mom_val(iterator,k) = hg_calcmom3d(struct_dc2, mom_def(k,1), mom_def(k,2), mom_def(k,3),'scale');
            % if the model was trained by taking into account dimensional
            % factor (interp_interval) then another normalization factor
            % must be introduced
            mom_val(iterator,k) = mom_val(iterator,k)*interp_interval^(sum(mom_def(k,:)));
        end
        iterator = iterator + 1;
    end  
end
%% output
variablenames = strrep(num2cell(num2str(mom_def),2), ' ', '')';
variablenames = cellfun(@(v) ['m' v], variablenames, 'Uniform', 0);
t1 = array2table(mom_val, 'VariableNames', variablenames);
t2 = array2table({'ipsi' 'left'; 'contra' 'right'; 'ipsi' 'right'; 'contra' 'left'}, 'VariableNames', {'lateral' 'side'});
output = [t2 t1];
disp('Moments calculated');

end