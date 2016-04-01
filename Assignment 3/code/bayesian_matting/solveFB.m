function [F,B,lhood] = solveFB (alpha,f_bar,b_bar,sigmaF,sigmaB,C,sigmaC)
% This function solves for F and B colors given alpha, also likelihood
    Finv=pinv(sigmaF);
    Binv=pinv(sigmaB);
    M1=Finv+alpha^2*eye(3)/sigmaC^2;
    M2=alpha*(1-alpha)*eye(3)/sigmaC^2;
    M3=Binv+(1-alpha)^2*eye(3)/sigmaC^2;
    M=[M1,M2;M2,M3];
    L=[Finv*f_bar'+alpha*C/sigmaC^2;Binv*b_bar'+(1-alpha)*C/sigmaC^2];
    L=M\L;
    L=min(max(L,0),1);
    F=L(1:3);
    B=L(4:6);
    lhood=-(F'-f_bar)*Finv*(F-f_bar')/2-(B'-b_bar)*Binv*(B-b_bar')/2;
end