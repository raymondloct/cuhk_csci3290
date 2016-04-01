function [alpha] = noblue(img,BB)
%% Implement no blue matting
    alpha=1-img(:,:,3)/BB;
    % Normalize alpha
    alpha=max(0,min(1,alpha));
end


