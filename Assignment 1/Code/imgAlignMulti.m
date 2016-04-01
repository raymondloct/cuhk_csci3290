%% CSCI 3290: Assignment 1 Starter Code
imglist=cellstr(['00170u.tif';'00171u.tif';'00172u.tif';'00210u.tif';'00308u.tif';'00892u.tif';'00904u.tif';'00978u.tif';'00999u.tif';'01003u.tif';'01045u.tif';'01087u.tif';'01721u.tif']);
for i=1:size(imglist,1)
    % Input glass plate image
    imgname = imglist{i};
    fullimg = imread(imgname);

    % Convert to double matrix
    fullimg = im2double(fullimg);

    % TODO1: Extract 3 channels from input image
    [B,G,R]=autoCropping(fullimg);
    %% Align the images
    % Functions that might be useful:"circshift", "sum", and "imresize"

    tic;   % The Timer starts. To Evalute algorithms' efficiency.

    vG = alignMulti(G,B);
    vR = alignMulti(R,B);
    %aG = imresize(imrotate(G,vG(3)),1+vG(4));
    %aR = imresize(imrotate(R,vR(3)),1+vR(4));

    toc;   % The Timer stops and displays time elapsed.

    %% Output Results

    % Create a color image (3D array): "cat" command
    % For your own code, "G","R" shoule be replaced to "aG","aR"
    colorImg = combineColors(R,G,B,vR,vG);

    % Show the resulting image: "imshow" command
    % imshow(colorImg);

    % Save result image to File
    imwrite(colorImg,['alignMulti-' strrep(imgname,'.tif','.png')]);
end
