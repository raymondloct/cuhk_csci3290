function [mu,sigma] = getMeanCovar(v,w)
% This function gives the weighted mean and covariances of the given colors
% v: nx3 vector for colors, w: weights
    mu=[0,0,0];
    sigma=eye(3);
    wsum=sum(w);
    if wsum<=0
        return;
    end
    w=w/wsum;
    n=size(w,1);
    d=spdiags(w,0,n,n);
    mu=sum(d*v);
    v(:,1)=v(:,1)-mu(1);
    v(:,2)=v(:,2)-mu(2);
    v(:,3)=v(:,3)-mu(3);
    sigma=v'*d*v;
end