oldname='TempBlk';
newname='GW047_170511_s01';

fnames=getFullFileNames(pwd,dir('*.mat'));

for i=1:length(fnames)
    load(fnames{i});
   
%     metadata.mouse=newname;
    metadata.folder=regexprep(metadata.folder,oldname,newname);
    metadata.TDTblockname=regexprep(metadata.TDTblockname,oldname,newname);
    
    newfname=regexprep(fnames{i},[oldname '_'],[newname '_']);
    
%     disp(metadata.mouse)
%     disp(metadata.folder)
    disp(newfname)
    save(newfname,'data','metadata');
%     save(newfname,'metadata');
    fprintf('Changed metadata and filename for %s\n',fnames{i});
    clear data metadata
%     clear metadata
end

fprintf('Done!\n')