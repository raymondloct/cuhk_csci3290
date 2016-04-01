input=[1,2];
for j=1:size(input,2)
    index=input(j);
    source=sprintf('img/%d.png',index);
    source2=sprintf('segmentation/%d.png',index);
    out1=sprintf('img/%d_alpha_k.png',index);
    out2=sprintf('img/%d_F.png',index);
    out3=sprintf('img/%d_B.png',index);
    out4=sprintf('img/%d_matte_k.png',index);
    img= im2double(imread(source));
    trimap = im2double(imread(source2));
    trimap(trimap>0.2 & trimap<0.8)=0.5;
    trimap(trimap<=0.2)=0;
    trimap(trimap>=0.8)=1;
    trimap=trimap(:,:,1);
    tic;
    warning off;
    [F,B,alpha] = bayesian_matting_2(img, trimap);
    warning on;
    toc;
    imwrite(alpha,out1);
    %imwrite(F,out2);
    %imwrite(B,out3);
    matte=F;
    for i=1:3
        matte(:,:,i)=matte(:,:,i).*alpha+1-alpha;
    end
    imwrite(matte,out4);
end