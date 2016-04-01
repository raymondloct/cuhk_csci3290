function BB = getBlueBg(img)
% This function detects the blue background of the given image
% It looks at the 4 corners
    if(img(1,1,1)==0 && img(1,1,2)==0)
        BB=img(1,1,3);
    elseif(img(end,end,1)==0 && img(end,end,2)==0)
        BB=img(end,end,3);
    elseif(img(1,end,1)==0 && img(1,end,2)==0)
        BB=img(1,end,3);
    elseif(img(end,1,1)==0 && img(end,1,2)==0)
        BB=img(end,1,3);
    else
        BB=1;
    end
end