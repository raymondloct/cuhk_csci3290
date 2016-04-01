function [logoL,logoR,alphaL,alphaR] = genStereoLogo(logoName,logo_pos,vidSize)
% This function generates the stereo versions of the logo
% logo_pos: [scale, vert-disp, horz-disp, depth]
    [logo,~,logo_alpha]=imread(logoName);
    logo=imresize(logo,logo_pos(1));
    logo_alpha=imresize(logo_alpha,logo_pos(1));
    logo=im2double(logo);
    logo_alpha=im2double(logo_alpha);
    [lh,lw]=size(logo_alpha);
    logo_frame=zeros(vidSize(1),vidSize(2),3);
    logo_frame_alpha=zeros(vidSize);
    logo_frame(logo_pos(2)+(1:lh),logo_pos(3)+(1:lw),:)=logo;
    logo_frame_alpha(logo_pos(2)+(1:lh),logo_pos(3)+(1:lw))=logo_alpha;
    f=45;
    b=60;
    dis=zeros(vidSize);
    dis(logo_pos(2)+(1:lh),logo_pos(3)+(1:lw))=ones(lh,lw)*b*f/logo_pos(4);
    [logoL,logoR]=genStereo(logo_frame,dis);
    [alphaL,alphaR]=genStereo(logo_frame_alpha,dis);
    for i=1:3
        logoL(:,:,i)=min(max(logoL(:,:,i).*(1-isnan(logoL(:,:,i))),0),1);
        logoR(:,:,i)=min(max(logoR(:,:,i).*(1-isnan(logoR(:,:,i))),0),1);
    end
    alphaL=min(max(alphaL.*(1-isnan(alphaL)),0),1);
    alphaR=min(max(alphaR.*(1-isnan(alphaR)),0),1);
end