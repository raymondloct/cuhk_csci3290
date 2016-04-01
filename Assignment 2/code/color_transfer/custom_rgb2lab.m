function img_lab = custom_rgb2lab(img_rgb)
    [h,w,~]=size(img_rgb);
    r=img_rgb(:,:,1);
    g=img_rgb(:,:,2);
    b=img_rgb(:,:,3);
    rgb=horzcat(r(:),g(:),b(:));
    filter1=rgb>0.04045;
    rgb_l=filter1.*((rgb+0.055)/1.055).^2.4+(~filter1).*rgb/12.92;
    xyz=rgb_l*[0.4124,0.3576,0.1805;0.2126,0.7152,0.0722;0.0193,0.1192,0.9505]';
    xyz(:,1)=xyz(:,1)/0.95047;
    xyz(:,3)=xyz(:,3)/1.08883;
    filter2=xyz>(6/29)^3;
    fxyz=filter2.*xyz.^(1/3)+(~filter2).*((29/6)^2*xyz/3+4/29);
    lab=horzcat(116*fxyz(:,2)-16,500*(fxyz(:,1)-fxyz(:,2)),200*(fxyz(:,2)-fxyz(:,3)));
    img_lab=cat(3,reshape(lab(:,1),h,w),reshape(lab(:,2),h,w),reshape(lab(:,3),h,w));
end