function [F, B, alpha] = bayesian_matting(img, trimap)
    % Put your code here
    [H,W,~]=size(img);
    mask=trimap==0.5;
    N=24;
    sigma_C=0.1;
    sigma=8;
    F=zeros(H,W,3);
    B=zeros(H,W,3);
    for i=1:3
        F(:,:,i)=img(:,:,i).*(trimap==1);
        B(:,:,i)=img(:,:,i).*(trimap==0);
    end
    weight=((ones(2*N+1,1)*(-N:N))).^2+((-N:N)'*ones(1,2*N+1)).^2;
    weight=exp(-weight/sigma^2);
    % Intialize alpha
    [alpha,seq]=initialAlpha(trimap);
    for k=1:size(seq,1)
        x=seq(k,1);
        y=seq(k,2);
        % Fix alpha solve F,B
        n1=max(1,x-N):min(H,x+N);
        n2=max(1,y-N):min(W,y+N);
        F1=F(n1,n2,:);
        B1=B(n1,n2,:);
        wf=weight(N+1-x+n1,N+1-y+n2).*(alpha(n1,n2).^2);
        wb=weight(N+1-x+n1,N+1-y+n2).*((1-alpha(n1,n2)).^2);
        wf=wf(~mask(n1,n2));
        wb=wb(~mask(n1,n2));
        fv=F1(~mask(n1,n2));
        for i=2:3
            F1c=F1(:,:,i);
            fv(:,i)=F1c(~mask(n1,n2));
        end
        bv=B1(~mask(n1,n2));
        for i=2:3
            B1c=B1(:,:,i);
            bv(:,i)=B1c(~mask(n1,n2));
        end
        C=[img(x,y,1);img(x,y,2);img(x,y,3)];
        [f_bar,sigmaF]=getMeanCovar(fv,wf);
        [b_bar,sigmaB]=getMeanCovar(bv,wb);
        [F2,B2,~]=solveFB(alpha(x,y),f_bar,b_bar,sigmaF,sigmaB,C,sigma_C);
        
        F(x,y,:)=F2;
        B(x,y,:)=B2;
        mask(x,y)=false;
        % Fix F,B solve alpha
        FBdist=sumsqr(F2-B2);
        a2=0.5;
        if FBdist>0
            a2=(C-B2)'*(F2-B2);
        end
        a2=min(max(a2,0),1);
        alpha(x,y)=a2;
    end
end