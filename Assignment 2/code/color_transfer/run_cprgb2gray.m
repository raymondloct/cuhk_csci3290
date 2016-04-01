src_list=cell(10,1);
for i=1:10
    src_list{i}=strcat('./imgs/',num2str(i),'.png');
end

for i=1:size(src_list,1)
    % input color image
    Im = im2double(imread(src_list{i}));

    % Part 1: Basic Decolorization Algorithm
    tic;
    gIm = cprgb2gray(Im);
    toc;
    % Part 2: Decolorization Evaluation: Color Contrast Preserving Ratio (CCPR)
    ccprRes = 0;
    for tau = 1:15
        ccpr = CCPR(gIm, Im, tau);
        ccprRes = ccprRes + ccpr;
    end

    fprintf('CCPR is %f\n', ccprRes/24);
    figure, imshow(Im), figure, imshow(gIm);
    name=strcat('./imgs/wco2_',num2str(i),'.jpg');
    imwrite(gIm,name);
end