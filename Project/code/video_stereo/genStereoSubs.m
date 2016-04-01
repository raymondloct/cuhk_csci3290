function [vidL,vidR]=genStereoSubs(vidName,subsFile,subtimeFile,subs_pos)
% This function applies the subs onto the video
% subs_pos: [size, vert-disp, horz-disp, depth]
    vid=VideoReader(vidName);
    fr=vid.FrameRate;
    N=vid.NumberOfFrames;
    [subs,subtime]=loadSubs(subsFile,subtimeFile);
    subindex=zeros(N,1);
    for i=1:size(subtime,1)
        subrange=min(max(round(subtime(i,:)*fr/1000),1),N);
        subindex(subrange(1):subrange(2))=i;
    end
    f=45;
    b=60;
    posL=[subs_pos(3)+b*f/subs_pos(4)/2,subs_pos(2)];
    posR=[subs_pos(3)-b*f/subs_pos(4)/2,subs_pos(2)];
    leftVidName=strcat('left_sub_',vidName);
    rightVidName=strcat('right_sub_',vidName);
    vidL=VideoWriter(leftVidName,'MPEG-4');
    vidL.FrameRate=fr;
    vidL.Quality=100;
    vidR=VideoWriter(rightVidName,'MPEG-4');
    vidR.FrameRate=fr;
    vidR.Quality=100;
    open(vidL);
    open(vidR);
    for i=1:N
        current=im2double(read(vid,i));
        newL=current;
        newR=current;
        if subindex(i)>0
            newL=insertText(newL,posL,subs{subindex(i)},'FontSize',subs_pos(1),'BoxColor','green','BoxOpacity',0.6,'TextColor','white');
            newR=insertText(newR,posR,subs{subindex(i)},'FontSize',subs_pos(1),'BoxColor','green','BoxOpacity',0.6,'TextColor','white');
        end
        writeVideo(vidL,newL);
        writeVideo(vidR,newR);
    end
    close(vidL);
    close(vidR);
end