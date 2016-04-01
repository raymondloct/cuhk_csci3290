function [imgL,imgR] = genStereo(img,dis)
% This function generates the left and right images of the given image
    [h,w,c]=size(img);
    [x,y]=ndgrid(1:h,1:w);
    lefty=y+dis/2;
    lefty=lefty-lefty(1,1);
    righty=y-dis/2;
    righty=righty-righty(1,1);
    x=x(:);
    y=y(:);
    lefty=lefty(:);
    righty=righty(:);
    imgL=zeros(h,w,c);
    imgR=imgL;
    for i=1:c
        imgv=img(:,:,i);
        imgv=imgv(:);
        imgL(:,:,i)=reshape(griddata(x,lefty,imgv,x,y),h,w);
        imgR(:,:,i)=reshape(griddata(x,righty,imgv,x,y),h,w);
    end
end