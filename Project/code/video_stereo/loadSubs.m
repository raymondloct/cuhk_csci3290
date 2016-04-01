function [subs, subtime] = loadSubs(subsFile,subtimeFile)
    f1=fopen(subsFile);
    subs=textscan(f1,'%[^\n\r]');
    subs=subs{1};
    fclose(f1);
    f2=fopen(subtimeFile);
    times=textscan(f2,'%d %d');
    subtime=double([times{1},times{2}]);
end
