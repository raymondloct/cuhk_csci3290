function img_lab = color_rgb2lab( img_rgb )
    [h,w,c] = size( img_rgb );
    
    % TODO: RGB to LMS
    lms=zeros(h,w,c);
    T=[0.3811,0.5783,0.0402;0.1967,0.7244,0.0782;0.0241,0.1288,0.8444];
    for i=1:h
        for j=1:w
            v1=[img_rgb(i,j,1);img_rgb(i,j,2);img_rgb(i,j,3)];
            v2=T*v1;
            lms(i,j,1:3)=v2;
        end
    end
    % TODO: LMS to log(LMS)
    loglms=log(max(eps,lms));    
    % TODO: log(LMS) to lab
    img_lab=zeros(h,w,c);
    T2=diag(1./sqrt([3,6,2]))*[1,1,1;1,1,-2;1,-1,0];
    % Output: img_lab   
    for i=1:h
        for j=1:w
            v1=[loglms(i,j,1);loglms(i,j,2);loglms(i,j,3)];
            v2=T2*v1;
            img_lab(i,j,1:3)=v2;
        end
    end
end