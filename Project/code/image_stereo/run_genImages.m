imgs={'Aloe.png','Bowling2.png','Flowerpots.png','Middlebury_20_clean_color.png','Middlebury_21_clean_color.png'};
disps={'Aloe_disp.png','Bowling2_disp.png','Flowerpots_disp.png','Middlebury_20_output_disparity.png','Middlebury_21_output_disparity.png'};
for i=1:size(imgs,2)
    img=im2double(imread(imgs{i}));
    dis=im2double(imread(disps{i}));
    [imgL,imgR]=genStereo(img, dis*10);
    nameL=sprintf('%d_left.jpg',i);
    nameR=sprintf('%d_right.jpg',i);
    imwrite(imgL,nameL);
    imwrite(imgR,nameR);
end