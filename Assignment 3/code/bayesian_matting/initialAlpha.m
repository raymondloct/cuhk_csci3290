function [alpha,seq] = initialAlpha(trimap)
% This function initializes alpha values with the given trimap
% seq gives the sequence of initialization
    a_range=3;
    [H,W]=size(trimap);
    mask=trimap==0.5;
    h   = [0,1,0;1,-4,1;0,1,0];
    alpha=trimap.*(~mask);
    ucount=sum(sum(double(mask)));
    seq=zeros(ucount,2);
    init=0;
    while init<ucount
        chi = imfilter(double(~mask),h);
        chi(chi<0) = 0;
        chi(chi>0) = 1;
        chi = chi.*mask;
        [br,bc]=find(chi);
        newAlpha=zeros(H,W);
        for i=1:size(br,1)
            n1=max(1,br(i)-a_range):min(H,br(i)+a_range);
            n2=max(1,bc(i)-a_range):min(W,bc(i)+a_range);
            nbhd=trimap(n1,n2);
            nbhd=nbhd(~mask(n1,n2));
            newAlpha(br(i),bc(i))=mean(nbhd);
            mask(br(i),bc(i))=false;
            init=init+1;
            seq(init,:)=[br(i),bc(i)];
        end
        alpha=alpha+newAlpha;
    end
end