input=[1,2,4,5];
for j=1:size(input,2)    
    index=input(j);
    source=sprintf('img/%d.bmp',index);
    source2=sprintf('img/%d-mask.bmp',index);
    out1=sprintf('img/%d_alpha_6.png',index);
    out2=sprintf('img/%d_F.png',index);
    out3=sprintf('img/%d_B.png',index);
    out4=sprintf('img/%d_matte_6.png',index);
    % input image
    img=im2double(imread(source));
    tic;
    if size(img,3) == 3
        img = rgb2gray(img);
    end
    % input trimap
    trimap=im2double(imread(source2));
    trimap=trimap(:,:,1);
    % make trimap value to standard. 1 - foregournd; 0 - background; 0.5 - undecided.
    trimap(trimap>0.8)=1;
    trimap(trimap<0.2)=0;
    trimap(trimap>0.2 & trimap<0.8)=0.5;
    % set parameters for iterations
    maxIters = 10;
    % initialize F and B, both are gray-scale image according to paper
    [F,B]=find_nearestFB(trimap,img);
    % calculate F-B
    F_B=F-B;
    % apply gaussian filter to F_B
    sigma = 2;
    H=fspecial('gaussian',[5,5],sigma);
    F_B=imfilter(F_B,H,'replicate');
    % initialize alpha
    alpha = trimap;
    criteria=0.04;
    % iteratively solving
    for i = 1:maxIters
        % solve for undecided regions using poission equation
        mask_undecided=(trimap==0.5); % mask for all undecide pixels
        alpha=poisson_equ(img,F_B,trimap );
        % update F and B
        Fe=abs(img-F);
        Be=abs(img-B);
        newF=mask_undecided.*(alpha>0.95).*(Fe<criteria);
        newB=mask_undecided.*(alpha<0.05).*(Be<criteria);
        trimap=trimap+0.5*newF-0.5*newB;
        [F,B]=find_nearestFB(trimap,img);
        % apply gaussian filter to F_B
        F_B=F-B;
        F_B=imfilter(F_B,H,'replicate');    
    end
    toc;
    imwrite(alpha,out1);
    %imwrite(F,out2);
    %imwrite(B,out3);
    imwrite(F.*alpha+(1-alpha),out4);
end