src_list={'./imgs/ocean_day.jpg';'./imgs/woods.jpg';'./imgs/fallingwater.jpg';'./imgs/storm.jpg'};
tar_list={'./imgs/ocean_sunset.jpg';'./imgs/autumn.jpg';'./imgs/storm.jpg';'./imgs/ocean_day.jpg'};
name_list={'./imgs/1.jpg';'./imgs/2.jpg';'./imgs/3.jpg';'./imgs/4.jpg'};

for i=1:size(src_list,1)
    % read source image
    img_src = im2double(imread(src_list{i}));

    % read target image
    img_tar = im2double(imread(tar_list{i}));

    % convert source & target image from RGB to Lab
    img_lab_s = color_rgb2lab( img_src );
    img_lab_t = color_rgb2lab( img_tar );

    % do color transfer in Lab colorspace
    img_lab_res = color_transfer( img_lab_s, img_lab_t );

    % convert result back to RGB color space
    img_res = color_lab2rgb( img_lab_res );

    %figure, imshow( img_res );
    imwrite(img_res,name_list{i});
end

