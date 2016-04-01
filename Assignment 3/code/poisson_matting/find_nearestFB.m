function [F,B] = find_nearestFB(trimap,img)
% Input:
% 	- trimap: where 1 indicates foreground, 0 indicates background, 0.5 for undecided
% 	- img: input color image
% Output:
% for 'definite foreground' pixels, F is value of img, B is zeros. 
% for 'definite background' pixels, B is value of img, F is zeros. 
% for 'undecided' pixels, F is the color of its nearest 'definite foreground' pixel
% for 'undecided' pixels, B is the color of its nearest 'definite background' pixel
    % separate img to foreground part and background part
    [x,y]=find(trimap==1);
    f1=horzcat(x,y);
    [x,y]=find(trimap==0.5);
    u1=horzcat(x,y);
    [x,y]=find(trimap==0);
    b1=horzcat(x,y);
    F=img.*(trimap==1);
    B=img.*(trimap==0);
    Fv=img(trimap==1);
    Bv=img(trimap==0);
    % for each undecided pixel, search for its nearest neighbor in F
    md1=KDTreeSearcher(f1);
    idx=knnsearch(md1,u1);    
    for i=1:size(u1,1)
        Fnb=Fv(idx(i),:);
        F(u1(i,1),u1(i,2))=Fnb;
    end
    % for each undecided pixel, search for its nearest neighbor in B
    md1=KDTreeSearcher(b1);
    idx=knnsearch(md1,u1);
    for i=1:size(u1,1)
        Bnb=Bv(idx(i),:);
        B(u1(i,1),u1(i,2))=Bnb;
    end
end