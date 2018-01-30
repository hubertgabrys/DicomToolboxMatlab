function dcm_info = read_dicominfo(filename, UseVRHeuristic, UseDictionaryVR)

% Temporarily set some dicom import-related warnings to errors
warning('error', 'images:dicominfo:fileVRDoesNotMatchDictionary');
warning('error', 'images:dicomparse:vrHeuristic');

try
    dcm_info = dicominfo(filename, 'UseVRHeuristic', UseVRHeuristic, 'UseDictionaryVR', UseDictionaryVR);
catch err
    switch err.identifier
        case 'images:dicomparse:vrHeuristic'
            UseVRHeuristic = false;
            warning('UseVRHeuristic set to false');
            dcm_info = read_dicominfo(filename, UseVRHeuristic, UseDictionaryVR);
        case 'images:dicominfo:fileVRDoesNotMatchDictionary'
            UseDictionaryVR = true;
            warning('UseDictionaryVR set to true');
            dcm_info = read_dicominfo(filename, UseVRHeuristic, UseDictionaryVR);
    end
end

% Restore the warnings
warning('on', 'images:dicominfo:fileVRDoesNotMatchDictionary');
warning('on', 'images:dicomparse:vrHeuristic');
end