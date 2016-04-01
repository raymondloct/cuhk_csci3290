function newImg=autoContrasting(img)
    % First, convert the color image from RGB to CIE Lab space
    colorTransform = makecform('srgb2lab');
    lab_img=applycform(img, colorTransform);
    % Extract L channel and perform Histogram Equalization
    l_img=lab_img(:,:,1);
    l2=uint8(l_img*255/100);
    new_l=double(histeq(l2))*100/255;
    lab_img(:,:,1)=new_l;
    % convert back to RGB
    colorTransform = makecform('lab2srgb');
    newImg=applycform(lab_img, colorTransform);
end