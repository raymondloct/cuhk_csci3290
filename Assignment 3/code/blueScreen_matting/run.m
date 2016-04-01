
%%
% In this basic part, you should complete noblue.m, graymatt.m,
% triangulationmatt.m
%%
noblue_imgs=1:27;
gray_imgs=[4,7,16,24,25,27];
tri_imgs=1:27;

for i=1:size(noblue_imgs,2)
    %part1: noblue matting
    index=noblue_imgs(i);
    source=sprintf('img/NOBLUE/%02d.png',index);
    out1=sprintf('img/NOBLUE/alpha_%02d.jpg',index);
    out2=sprintf('img/NOBLUE/matte_%02d.jpg',index);
    img   = im2double(imread(source));
    BB=getBlueBg(img);
    alpha = noblue(img,BB);
    imwrite(alpha,out1);
    matte=zeros(size(img));
    matte(:,:,1)=img(:,:,1)+1-alpha;
    matte(:,:,2)=img(:,:,2)+1-alpha;
    matte(:,:,3)=1-alpha;
    imwrite(matte,out2);
end

%part2; gray matting
for i=1:size(gray_imgs,2)
    index=gray_imgs(i);
    source=sprintf('img/GRAY/%02d.png',index);
    out1=sprintf('img/GRAY/alpha1_%02d.jpg',index);
    out2=sprintf('img/GRAY/matte1_%02d.jpg',index);
    out3=sprintf('img/GRAY/alpha2_%02d.jpg',index);
    out4=sprintf('img/GRAY/matte2_%02d.jpg',index);
    img = im2double(imread(source));
    BB=getBlueBg(img);
    alpha = graymatt(img,BB,2);
    imwrite(alpha,out1);
    matte=zeros(size(img));
    matte(:,:,1)=img(:,:,1)+1-alpha;
    matte(:,:,2)=img(:,:,2)+1-alpha;
    matte(:,:,3)=img(:,:,3)+(1-alpha)*(1-BB);
    imwrite(matte,out2);
    alpha = graymatt(img,BB,1);
    imwrite(alpha,out3);
    matte=zeros(size(img));
    matte(:,:,1)=img(:,:,1)+1-alpha;
    matte(:,:,2)=img(:,:,2)+1-alpha;
    matte(:,:,3)=img(:,:,3)+(1-alpha)*(1-BB);
    imwrite(matte,out4);
end

%part3:trauangulation matting
for i=1:size(tri_imgs,2)
    index=tri_imgs(i);
    source1=sprintf('img/TRIANGULATION/%02d_1.png',index);
    source2=sprintf('img/TRIANGULATION/%02d_2.png',index);
    out1=sprintf('img/TRIANGULATION/alpha_%02d.jpg',index);
    out2=sprintf('img/TRIANGULATION/matte_%02d.jpg',index);
    img1 = im2double(imread(source1));
    img2 = im2double(imread(source2));
    alpha = triangulationmatt(img1,img2);
    imwrite(alpha,out1);
    BB1=getBlueBg(img1);
    matte=zeros(size(img1));
    matte(:,:,1)=img1(:,:,1)+1-alpha;
    matte(:,:,2)=img1(:,:,2)+1-alpha;
    matte(:,:,3)=img1(:,:,3)+(1-alpha)*(1-BB1);
    imwrite(matte,out2);
end

