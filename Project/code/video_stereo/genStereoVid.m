function [vidL,vidR]=genStereoVid(vidName,logoName,logo_pos)
% This function applies the logo onto the video
% logo_pos: [scale, vert-disp, horz-disp, depth]
   vid=VideoReader(vidName);
   h=vid.Height;
   w=vid.Width;
   [logoL,logoR,alphaL,alphaR]=genStereoLogo(logoName,logo_pos,[h,w]);
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
          newL(:,:,j)=current(:,:,j).*(1-alphaL)+logoL(:,:,j).*alphaL;
          newR(:,:,j)=current(:,:,j).*(1-alphaR)+logoR(:,:,j).*alphaR;
       end
       writeVideo(vidL,newL);
       writeVideo(vidR,newR);
   end
   close(vidL);
   close(vidR);   
end