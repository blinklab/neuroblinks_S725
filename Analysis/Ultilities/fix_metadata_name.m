fnames=getFullFileNames(pwd,dir('*.mat'));

parfor i=1:length(fnames)
    d=load(fnames{i});
    
    d.metadata.mouse='GW015';
    d.metadata.folder='d:\data\Greg\TrkB Experiments\GW015\160911';
    d.metadata.TDTblockname='GW015_160911_s01';
    
    
    if isfield(d,'data')
        data=d.data;
        metadata=d.metadata;
        save(fnames{i},'data','metadata');
    else
        metadata=d.metadata;
        save(fnames{i},'metadata');
    end
    
end
fprintf('Done!\n')