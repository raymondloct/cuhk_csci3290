function gIm = cprgb2gray(im)
	% input 'im' is a color image
	% output gIm is the resulting grayscale image
    [h,w,~]=size(im);
	% Convert the input to LAB space
    img_lab=custom_rgb2lab(im);    
	% Construct delta_xy for each neighboring pixels
    [Vd,Hd]=neighborDistance(img_lab);
	% Constructing A and Delta
    t1=1:h*w;
    t2=t1+1;
    t2(h:h:h*w)=t2(h:h:h*w)-h;
    t3=t1+h;
    t3(end-h+1:end)=1:h;
    x1=vertcat(t1',t1',t1'+h*w,t1'+h*w);
    y1=vertcat(t1',t2',t1',t3');
    v1=vertcat(-ones(h*w,1),ones(h*w,1),-ones(h*w,1),ones(h*w,1));
    A=sparse(x1,y1,v1,2*h*w,h*w);
    Delta=vertcat(Vd(:),Hd(:));
	% Solve the objective function to get G
    g=A\Delta;
    gIm=reshape(g,h,w);
	% Normalization and output gIm
	gIm = (gIm - min(gIm(:)))/ (max(gIm(:)) - min(gIm(:)));
end

