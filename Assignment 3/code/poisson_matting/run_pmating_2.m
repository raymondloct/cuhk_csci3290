input=[1,2,4,5];
for j=1:size(input,2)    
    index=input(j);
    source=sprintf('img/%d.bmp',index);
    source2=sprintf('img/%d-mask.bmp',index);
    out1=sprintf('img/%d_alpha.png',index);
    out2=sprintf('img/%d_F.png',index);
    out3=sprintf('img/%d_B.png',index);
    out4=sprintf('img/%d_matte.png',index);
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
    [F,B,alpha]=poissonMatte(rgb2gray(img),trimap);
    toc;
    imwrite(alpha,out1);
    %imwrite(F,out2);
    %imwrite(B,out3);
    %imwrite(F.*alpha+(1-alpha),out4);
end