function dicomimport_batch(input_dir, skipifmatfileexists, resolution, save_matfile, default_save_path, showGUI)

fprintf('Performing batch import of dicom files...');
subDirList = getSubDirList(input_dir);
if showGUI
    h = waitbar(0,'Please wait...');
    steps = length(subDirList);
end
for i=1:length(subDirList)
    progress_tool(i, length(subDirList));
    %fprintf('%s\n', subDirList{i});
    if ~(skipifmatfileexists && exist(fullfile(input_dir, subDirList{i}, 'tps_data.mat'), 'file')) % will recalculate mat file if the mat file is missing or the user didn't select the 'skip' checkbox
        subDirPath = fullfile(input_dir,subDirList{i});
        hg_dicomimport(subDirPath, resolution, save_matfile, default_save_path, showGUI);      
    end
    if showGUI
        waitbar(i / steps)
    end
end
if showGUI
    close(h)
end
fprintf(repmat('\b',1,7)); % this is to erase progress tool
fprintf('DONE\n');
end