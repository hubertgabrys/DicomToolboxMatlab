function subdirList = getSubDirList( input_dir )

dirinfo = dir(input_dir);
dirinfo = dirinfo(3:end);
dirinfo = struct2table(dirinfo);
dirinfo = dirinfo(dirinfo.isdir,:);
subdirList = dirinfo.name;

end

