function gIm = wco_color2gray(img_rgb)
% This function applies weak order decolorization on RGB image
% Ref: www.cse.cuhk.edu.hk/~leojia/papers/decolorization_ijcv14.pdf
    img_lab=custom_rgb2lab(img_rgb);
    [Vd,Hd]=neighborDistance(img_lab);
    [Vo,Ho]=neighborColorOrder(img_rgb);
    Vd=Vd/100;
    Hd=Hd/100;
    r=img_rgb(:,:,1);
    g=img_rgb(:,:,2);
    b=img_rgb(:,:,3);
    l=cat(3,r,g,b,r.*g,r.*b,g.*b,r.^2,g.^2,b.^2);
    Vl=circshift(l,[-1,0,0])-l;
    Hl=circshift(l,[0,-1,0])-l;
    l_sum=zeros(9);
    for i=1:9
        for j=1:9
            l_sum(i,j)=sum(sum(Vl(:,:,i).*Vl(:,:,j)))+sum(sum(Hl(:,:,i).*Hl(:,:,j)));
        end
    end
    w=[0.33;0.33;0.34;0;0;0;0;0;0];
    k_max=15;
    sigma=0.02;
    for i=1:k_max
        tempV=0;
        for j=1:9
            tempV=tempV+w(j)*Vl(:,:,j);
        end
        a1=max(Vo.*exp((tempV-Vd).^2/(-2*sigma)),eps);
        a2=max((1-Vo).*exp((tempV+Vd).^2/(-2*sigma)),eps);
        betaV=a1./(a1+a2);
        tempH=0;
        for j=1:9
            tempH=tempH+w(j)*Hl(:,:,j);
        end
        a1=max(Ho.*exp((tempH-Hd).^2/(-2*sigma)),eps);
        a2=max((1-Ho).*exp((tempH+Hd).^2/(-2*sigma)),eps);
        betaH=a1./(a1+a2);
        a3=zeros(9,1);
        for j=1:9
            a3(j)=sum(sum((2*betaV-1).*Vd.*Vl(:,:,j)))+sum(sum((2*betaH-1).*Hd.*Hl(:,:,j)));
        end
        w=l_sum\a3;
    end
    gIm=0;
    for i=1:9
        gIm=gIm+w(i)*l(:,:,i);
    end
    gIm = (gIm - min(gIm(:)))/ (max(gIm(:)) - min(gIm(:)));
end