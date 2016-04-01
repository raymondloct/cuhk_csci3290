function ccrpRe = CCPR(imGray, imColor, THR)
    img_lab=custom_rgb2lab(imColor);
    imGray=imGray*100;
    [Vd,Hd]=neighborDistance(img_lab);
    Vd=abs(Vd);
    Hd=abs(Hd);
    % First consider the vertical neighbours
    v_dist_g=abs(circshift(imGray,[-1,0])-imGray);
    v_sig=Vd>=THR;
    v_sig_g=and(v_sig,v_dist_g>=THR);
    % Then consider the horizontal neighbours
    h_dist_g=abs(circshift(imGray,[0,-1])-imGray);
    h_sig=Hd>=THR;
    h_sig_g=and(h_sig,h_dist_g>=THR);
    % compute ratio
    sig_total=sum(v_sig(:))+sum(h_sig(:));
    sig_new=sum(v_sig_g(:))+sum(h_sig_g(:));
    ccrpRe=sig_new/sig_total;
end