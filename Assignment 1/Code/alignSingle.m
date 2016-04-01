function [v,m] = alignSingle(img,B,x_shift,y_shift,range)
% This function is to align img to B using single-scale algorithms
% x_shift,y_shift are the initial displacements of img
% Output is the displacement vector v that minimizes the given metric
    [h1,w1]=size(img);
    % Compute metric for shifting by [-range,range]
    minMetric = inf; % minimum metric value
    minVector = zeros(2,1); % best shift vector by far
    x1=floor(h1/6);
    y1=floor(w1/6);
    for dx=-range:range
        for dy=-range:range
            % Metric on (h/6:5h/6,w/6:5w/6), ignoring the edges
            x2=x1+dx+x_shift;
            y2=y1+dy+y_shift;
            metric=getMetric(img(x1:5*x1-1,y1:5*y1-1),B(x2:x2+4*x1-1,y2:y2+4*y1-1));
            if metric<minMetric
                % better shift vector found
                minMetric=metric;
                minVector(1)=dx;
                minVector(2)=dy;
            end
        end
    end
    v=minVector;
    m=minMetric;
end

function metric=getMetric(A,B)
	% This time we use SSD
	metric=sumsqr(A-B);
end

