function v = alignMulti(img,B)
% This function is to align img to B using multi-scale algorithms
% Output is the displacement vector v that minimizes the given metric    
    range1=2;
    range2=15;
    
	pyramid_scale = 2;
	pyramid_levels = 5; % choose your value
	gaussianf = fspecial('gaussian', [5,5], 1.5); % change if you need
	
	imgs = cell(pyramid_levels,1);
	imgs{1} = img;
	Bs = cell(pyramid_levels,1);
	Bs{1} = B;
	
	for ilevel = 2:1:pyramid_levels
		% Build Image Pyramid for img & B
		newImg=conv2(imgs{ilevel-1},gaussianf);
        imgs{ilevel}=newImg(1:pyramid_scale:end,1:pyramid_scale:end);
        newB=conv2(Bs{ilevel-1},gaussianf);
        Bs{ilevel}=newB(1:pyramid_scale:end,1:pyramid_scale:end);
    end
    
    v=zeros(2,1);
    
	% Match using Image Pyramids
	for ilevel = pyramid_levels:-1:1
		% First, apply Sobel filter to get the edges
        threshold=75;
        I1=sobelFilter(imgs{ilevel},threshold);
        B1=sobelFilter(Bs{ilevel},threshold);
        if ilevel==pyramid_levels
            range=range2;
        else
            range=range1;
        end
        [vec,~]=alignSingle(I1,B1,pyramid_scale*v(1),pyramid_scale*v(2),range);
        v(1)=pyramid_scale*v(1)+vec(1);
        v(2)=pyramid_scale*v(2)+vec(2);
    end
end