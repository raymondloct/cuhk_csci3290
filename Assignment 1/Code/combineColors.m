function C=combineColors(R,G,B,vR,vG)
% This function combines the three channels into a color image
% vR, vG are the shift vectors for R and G
    [hb,wb]=size(B);
    [hg,wg]=size(G);
    [hr,wr]=size(R);
    x1=min([0,vR(1),vG(1)]);
    y1=min([0,vR(2),vG(2)]);
    x2=max([hb,hg+vG(1),hr+vR(1)]);
    y2=max([wb,wg+vG(2),wr+vR(2)]);
    aR=zeros(x2-x1,y2-y1);
    aR(1-x1+vR(1):hr-x1+vR(1),1-y1+vR(2):wr-y1+vR(2))=R;
    aG=zeros(x2-x1,y2-y1);
    aG(1-x1+vG(1):hg-x1+vG(1),1-y1+vG(2):wg-y1+vG(2))=G;
    aB=zeros(x2-x1,y2-y1);
    aB(1-x1:hb-x1,1-y1:wb-y1)=B;
    C = cat(3,aR,aG,aB);
end