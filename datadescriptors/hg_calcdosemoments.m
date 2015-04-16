function output = hg_calcdosemoments(struct_dc, mom_def)
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


interp_interval = 2.5; % it shouldn't be hardcoded. What's more it should be 
% the same value as in the hg_loadcube function. Maybe it's better to get rid 
%of this interpolation in moment's calculation...

mom_val = size(1,length(mom_def)); % prealocation
iterator = 1;


%% Calculate moments
for k = 1:size(mom_def,1) % for every moment setup
    mom_val(iterator,k) = hg_calcmom3d(struct_dc, mom_def(k,1), mom_def(k,2), mom_def(k,3),'scale');
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