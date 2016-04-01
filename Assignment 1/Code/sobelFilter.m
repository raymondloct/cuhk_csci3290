function G=sobelFilter(img,threshold)
% This function applies Sobel Operator on img
% to detect the edges in the image
    [h,w]=size(img);
    % pad the edges
    img2=zeros(h+2,w+2);
    img2(2:end-1,2:end-1)=img;
    img2(1,:)=img2(2,:);
    img2(end,:)=img2(end-1,:);
    img2(:,1)=img2(:,2);
    img2(:,end)=img2(:,end-1);
    % apply Sobel kernels
    Sx=[-1,0,1;-2,0,2;-1,0,1];
    Sy=[-1,-2,-1;0,0,0;1,2,1];
    Gx=conv2(img2,Sx,'valid');
    Gy=conv2(img2,Sy,'valid');
    G=sqrt(Gx.^2+Gy.^2);
    % set the threshold
    criteria=prctile(G(:),threshold);
    pass=G>criteria;
    G=G.*pass;
    % normalize image
    G_max=max(G(:));
    G=G/G_max;    
end