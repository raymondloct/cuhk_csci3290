function [F,B,alpha] = poissonMatte(img,trimap)
% This function computes the poisson matte given image and trimap
% img: either grayscale or single-channel
    % custom parameters
    maxIters = 10;
    sigma = 2;
    H=fspecial('gaussian',[5,5],sigma);
    criteria=0.1;
    % initialize F and B, both are gray-scale image according to paper
    % for 'definite foreground' pixels, F is value of img, B is zeros. 
    % for 'definite background' pixels, B is value of img, F is zeros. 
    % for 'undecided' pixels, F is the color of its nearest 'definite foreground' pixel
    % for 'undecided' pixels, B is the color of its nearest 'definite background' pixel
    [F,B]=find_nearestFB_2(trimap,img);
    % calculate F-B
    F_B = F-B;
    F_B=imfilter(F_B,H,'replicate');
    % initialize alpha
    alpha = trimap;
    
    % iteratively solving
    for i = 1:maxIters
        % solve for undecided regions using poission equation
        mask_undecided=(trimap==0.5); % mask for all undecide pixels
        alpha= poisson_equ(img,F_B,trimap);
        % update F and B
        Fe=abs(img-F);
        Be=abs(img-B);
        newF=mask_undecided.*(alpha>0.95).*(Fe<criteria);        
        newB=mask_undecided.*(alpha<0.05).*(Be<criteria);
        trimap=trimap+0.5*newF-0.5*newB;
        [F,B]=find_nearestFB_2(trimap,img);        
        % apply gaussian filter to F_B
        F_B=F-B;
        F_B=imfilter(F_B,H,'replicate');
    end
end