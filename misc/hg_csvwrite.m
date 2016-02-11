function myCSVwrite(array, filename, header)
% header in comma separeted values, strings in ""
%% create header
fid = fopen(filename, 'w');
fprintf(fid, header);
fclose(fid);

%% append array
dlmwrite(filename, array, '-append');
end