function [logoL,logoR,alphaL,alphaR] = genStereoRotatedLogo(logo,logo_alpha,logo_pos,vidSize)
% logo_pos: [rotation, vert-disp, horz-disp, centroid depth]
    [lh,lw,~]=size(logo);
    angle=degtorad(logo_pos(1));
    w_disp=round((1-cos(angle))*lw/2);
    new_w=round(lw*cos(angle));
    position=[logo_pos(2),logo_pos(3)+w_disp];
    [depth,~]=meshgrid(1:lh,1:lw);
    f=45;
    depth=logo_pos(4)*(1+sin(logo_pos(1))*(depth-lw/2)/f);
    newLogo=imresize(logo,[lh,new_w]);
    newAlpha=imresize(logo_alpha,[lh,new_w]);
    depth=imresize(depth,[lh,new_w]);
    logo_frame=zeros(vidSize(1),vidSize(2),3);
    logo_frame_alpha=zeros(vidSize);
    logo_frame(position(1)+(1:lh),position(2)+(1:new_w),:)=newLogo;
    logo_frame_alpha(position(1)+(1:lh),position(2)+(1:new_w))=newAlpha;
    b=60;
    dis=zeros(vidSize);
    dis(position(1)+(1:lh),position(2)+(1:new_w))=b*f./depth;
    [logoL,logoR]=genStereo(logo_frame,dis);
    [alphaL,alphaR]=genStereo(logo_frame_alpha,dis);
    for i=1:3
        logoL(:,:,i)=min(max(logoL(:,:,i).*(1-isnan(logoL(:,:,i))),0),1);
        logoR(:,:,i)=min(max(logoR(:,:,i).*(1-isnan(logoR(:,:,i))),0),1);
    end
    alphaL=min(max(alphaL.*(1-isnan(alphaL)),0),1);
    alphaR=min(max(alphaR.*(1-isnan(alphaR)),0),1);
end