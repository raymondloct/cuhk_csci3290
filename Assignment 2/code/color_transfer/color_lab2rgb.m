function  img_rgb = color_lab2rgb( img_lab )
    [h,w,c] = size( img_lab );
    
    % TODO: lab to log(LMS)
    T=[2,1,3;2,1,-3;2,-2,0]*diag(sqrt([3,6,2]))/6;
    loglms=zeros(h,w,c);
    for i=1:h
        for j=1:w
            v1=[img_lab(i,j,1);img_lab(i,j,2);img_lab(i,j,3)];
            v2=T*v1;
            loglms(i,j,1:3)=v2;
        end
    end
    % TODO: log(LMS) to LMS
    lms=exp(loglms);
        
    % TODO: LMS to RGB
    img_rgb=zeros(h,w,c);
    T2=inv([0.3811,0.5783,0.0402;0.1967,0.7244,0.0782;0.0241,0.1288,0.8444]);
    for i=1:h
        for j=1:w
            v1=[lms(i,j,1);lms(i,j,2);lms(i,j,3)];
            v2=T2*v1;
            img_rgb(i,j,1:3)=v2;
        end
    end    
    % Output: img_rgb


end