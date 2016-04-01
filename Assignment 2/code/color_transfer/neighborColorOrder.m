function [Vo,Ho] = neighborColorOrder(img_rgb)
% This function detects strong color order between neighboring pixels
% i.e. Rx>=Ry, Gx>=Gy, Bx>=By
% Vd: Vertical neighbors: I(p+1,q)-I(p,q)
% Hd: Horizontal neighbors: I(p,q+1)-I(p,q)
    vIm=circshift(img_rgb,[-1,0])-img_rgb;
    hIm=circshift(img_rgb,[0,-1])-img_rgb;
    Vo=vIm(:,:,1)>=0 & vIm(:,:,2)>=0 & vIm(:,:,3)>=0;
    Ho=hIm(:,:,1)>=0 & hIm(:,:,2)>=0 & hIm(:,:,3)>=0;
    Vo=Vo|(vIm(:,:,1)<=0 & vIm(:,:,2)<=0 & vIm(:,:,3)<=0);
    Ho=Ho|(hIm(:,:,1)<=0 & hIm(:,:,2)<=0 & hIm(:,:,3)<=0);
    Vo=0.5+Vo/2;
    Ho=0.5+Ho/2;
end