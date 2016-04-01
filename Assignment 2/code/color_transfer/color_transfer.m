function img_res = color_transfer( img_src, img_tar )
    % img_src - input source image in Lab colorspace
    % img_tar - input target image in Lab colorspace
    % img_res - color transfered image from img_src to img_tar
    [hs,ws,cs] = size( img_src );
    % [ht,wt,ct] = size( img_tar );
    
    % TODO: calculate mean value for each channel of img_src & img_tar
    % TODO: calculate std value for each channel of img_src & img_tar
    color_mean=zeros(3,2);
    color_sd=zeros(3,2);
    for i=1:3
       channel=img_src(:,:,i);
       channel=channel(:);
       color_mean(i,1)=mean(channel);
       color_sd(i,1)=std(channel);
       channel=img_tar(:,:,i);
       channel=channel(:);
       color_mean(i,2)=mean(channel);
       color_sd(i,2)=std(channel);
    end    
    
    % TODO: do color transfer
    img_res=zeros(hs,ws,cs);
    for i=1:3
        img_res(:,:,i)=(img_src(:,:,i)-color_mean(i,1))*color_sd(i,2)/color_sd(i,1)+color_mean(i,2);
    end    
    % output img_res
    
end