input=[1,2,4,5];
for j=1:size(input,2)    
    index=input(j);
    source=sprintf('img/%d.bmp',index);
    source2=sprintf('img/%d-mask.bmp',index);
    out1=sprintf('img/%d_alpha_C.png',index);
    out2=sprintf('img/%d_F_C.png',index);
    out3=sprintf('img/%d_B_C.png',index);
    out4=sprintf('img/%d_matte_C.png',index);
    % input image
    img=im2double(imread(source));
    tic;
    % input trimap
    trimap=im2double(imread(source2));
    trimap=trimap(:,:,1);
    % make trimap value to standard. 1 - foregournd; 0 - background; 0.5 - undecided.
    trimap(trimap>0.8)=1;
    trimap(trimap<0.2)=0;
    trimap(trimap>0.2 & trimap<0.8)=0.5;
    [~,~,alpha]=poissonMatte(rgb2gray(img),trimap);
    trimap1=trimap+0.5*(alpha>0.8).*(trimap==0.5);
    trimap2=trimap-0.5*(alpha<0.2).*(trimap==0.5);
    [F1,~]=find_nearestFB(trimap1,img(:,:,1));
    [~,B1]=find_nearestFB(trimap2,img(:,:,1));
    [F2,~]=find_nearestFB(trimap1,img(:,:,2));
    [~,B2]=find_nearestFB(trimap2,img(:,:,2));
    [F3,~]=find_nearestFB(trimap1,img(:,:,3));
    [~,B3]=find_nearestFB(trimap2,img(:,:,3));
    F=cat(3,F1,F2,F3);
    B=cat(3,B1,B2,B3);
    matte=cat(3,F(:,:,1).*alpha+(1-alpha),F(:,:,2).*alpha+(1-alpha),F(:,:,3).*alpha+(1-alpha));
    toc;
    imwrite(alpha,out1);
    imwrite(F,out2);
    imwrite(B,out3);
    imwrite(matte,out4);
end