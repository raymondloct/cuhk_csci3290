function [alpha] = graymatt(img,BB,layer)
%% Implement grey or flesh matting
    alpha=1-(img(:,:,3)-img(:,:,layer))/BB;
    % Normalize alpha
    alpha=max(0,min(1,alpha));
end
%%


