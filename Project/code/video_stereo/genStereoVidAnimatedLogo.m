function [vidL,vidR]=genStereoVidAnimatedLogo(vidName,logoName,logo_pos)
% This function applies the logo onto the video
% logo_pos: [scale, vert-disp, horz-disp, depth]
   vid=VideoReader(vidName);
   h=vid.Height;
   w=vid.Width;
   [logo,~,logo_alpha]=imread(logoName);
   logo=im2double(logo);
   logo_alpha=im2double(logo_alpha);
   logo=imresize(logo,logo_pos(1));
   logo_alpha=imresize(logo_alpha,logo_pos(1));
   N=round(5*vid.FrameRate);
   [logoLs,logoRs,alphaLs,alphaRs]=generateAnimation(N,vid.FrameRate,logo,logo_alpha,logo_pos,[h,w]);
   leftVidName=strcat('left_',vidName);
   rightVidName=strcat('right_',vidName);
   vidL=VideoWriter(leftVidName,'MPEG-4');
   vidL.FrameRate=vid.FrameRate;
   vidL.Quality=100;
   vidR=VideoWriter(rightVidName,'MPEG-4');
   vidR.FrameRate=vid.FrameRate;
   vidR.Quality=100;
   open(vidL);
   open(vidR);
   for i=1:vid.NumberOfFrames
       current=im2double(read(vid,i));
       newL=zeros(h,w,3);
       newR=zeros(h,w,3);
       for j=1:3
           frame=mod(i-1,N)+1;
           logoL=logoLs{frame};
           logoR=logoRs{frame};
           alphaL=alphaLs{frame};
           alphaR=alphaRs{frame};
           newL(:,:,j)=current(:,:,j).*(1-alphaL)+logoL(:,:,j).*alphaL;
           newR(:,:,j)=current(:,:,j).*(1-alphaR)+logoR(:,:,j).*alphaR;
       end
       writeVideo(vidL,newL);
       writeVideo(vidR,newR);
   end
   close(vidL);
   close(vidR);   
end

function [angle,opacity]=customAnimationFunction(time)
% This function specifies the rotation angle and opacity of the logo
    period=5;
    t=mod(time,period);
    if t<2
        angle=20*t;
    elseif t<4
        angle=20*(4-t);
    else
        angle=0;
    end
    if t<2
        opacity=0.5+0.25*(2-t);
    elseif t<4
        opacity=0.5+0.25*(t-2);
    else
        opacity=1;
    end
end

function [logoLs,logoRs,alphaLs,alphaRs]=generateAnimation(N,fr,logo,logo_alpha,logo_pos,vidSize)
% This function pre-generates the animated logo
    logoLs=cell(N,1);
    logoRs=cell(N,1);
    alphaLs=cell(N,1);
    alphaRs=cell(N,1);
    [ologoL,ologoR,oalphaL,oalphaR]=genStereoRotatedLogo(logo,logo_alpha,[0,logo_pos(2:4)],vidSize);
    for i=1:N
        time=(i-1)/fr;
        [angle,opacity]=customAnimationFunction(time);
        if angle==0
            logoLs{i}=ologoL;
            logoRs{i}=ologoR;
            alphaLs{i}=oalphaL*opacity;
            alphaRs{i}=oalphaR*opacity;
        else
            [logoL,logoR,alphaL,alphaR]=genStereoRotatedLogo(logo,logo_alpha,[angle,logo_pos(2:4)],vidSize);
            logoLs{i}=logoL;
            logoRs{i}=logoR;
            alphaLs{i}=alphaL*opacity;
            alphaRs{i}=alphaR*opacity;
        end
        if mod(i,20)==0
            disp(strcat('Done: ',num2str(i)));
        end
    end
end
    

