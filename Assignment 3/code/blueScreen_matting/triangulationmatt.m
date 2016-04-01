function [ alpha ] = triangulationmatt( img1,img2 )
	BB1   = getBlueBg(img1);
	BB2   = getBlueBg(img2);
    alpha=1-(img1(:,:,3)-img2(:,:,3))/(BB1-BB2);
    % Normalize alpha
    alpha=max(0,min(1,alpha));
end

