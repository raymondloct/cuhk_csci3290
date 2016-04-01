function [Vd,Hd] = neighborDistance(img_lab)
% This function computes the LAB color distance between neighboring pixels
% Sign determined by L channel
% Vd: Vertical neighbors: I(p+1,q)-I(p,q)
% Hd: Horizontal neighbors: I(p,q+1)-I(p,q)
    vIm=circshift(img_lab,[-1,0])-img_lab;
    hIm=circshift(img_lab,[0,-1])-img_lab;
	Vd=sqrt(vIm(:,:,1).^2+vIm(:,:,2).^2+vIm(:,:,3).^2).*sign(vIm(:,:,1));
    Hd=sqrt(hIm(:,:,1).^2+hIm(:,:,2).^2+hIm(:,:,3).^2).*sign(hIm(:,:,1));
end