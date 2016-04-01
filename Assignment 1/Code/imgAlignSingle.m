%% CSCI 3290: Assignment 1 Starter Code
imglist=cellstr(['00170v.jpg';'00171v.jpg';'00172v.jpg';'00210v.jpg';'00308v.jpg';'00892v.jpg';'00904v.jpg';'00978v.jpg';'00999v.jpg';'01003v.jpg';'01045v.jpg';'01087v.jpg';'01721v.jpg']);
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

    % Apply Sobel Filters to the images
    sB=sobelFilter(B,75);
    sG=sobelFilter(G,75);
    sR=sobelFilter(R,75);

    [vG,~] = alignSingle(sG,sB,0,0,15);
    [vR,~] = alignSingle(sR,sB,0,0,15);

    toc;   % The Timer stops and displays time elapsed.

    %% Output Results

    % Create a color image (3D array): "cat" command
    % For your own code, "G","R" shoule be replaced to "aG","aR"
    colorImg = combineColors(R,G,B,vR,vG);

    % Show the resulting image: "imshow" command
    % imshow(colorImg);

    % Save result image to File
    imwrite(colorImg,['alignSingle-' imgname]);
end
