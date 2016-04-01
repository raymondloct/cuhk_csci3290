function [F, B, alpha] = bayesian_matting_2(img, trimap)
    % Put your code here
    [H,W,~]=size(img);
    mask=trimap==0.5;
    N=10;
    sigma_C=0.2;
    sigma=5;
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
        idx=kmeans(fv,3,'start','uniform', 'emptyaction','singleton');
        f_seg=cell(3,2);
        fc=0;
        for i=1:3
            if size(fv(idx==i,:),1)>size(fv,1)/6
                fc=fc+1;
                [f_bar,sigmaF]=getMeanCovar(fv(idx==i,:),wf(idx==i));
                f_seg{fc,1}=f_bar;
                f_seg{fc,2}=sigmaF;
            end
        end
        
        idx=kmeans(bv,3,'start','uniform', 'emptyaction','drop');
        b_seg=cell(3,2);
        bc=0;
        for i=1:3
            if size(bv(idx==i,:),1)>size(bv,1)/6
                bc=bc+1;
                [b_bar,sigmaB]=getMeanCovar(bv(idx==i,:),wb(idx==i));
                b_seg{bc,1}=b_bar;
                b_seg{bc,2}=sigmaB;
            end
        end
        
        maxL=-inf;
        maxF=[];
        maxB=[];
        
        for i=1:fc
            for j=1:bc
                [F2,B2,lhood]=solveFB(alpha(x,y),f_seg{i,1},b_seg{j,1},f_seg{i,2},b_seg{j,2},C,sigma_C);
                if lhood>maxL
                    maxF=F2;
                    maxB=B2;
                end
            end
        end
        
        F(x,y,:)=maxF;
        B(x,y,:)=maxB;
        mask(x,y)=false;
        % Fix F,B solve alpha
        FBdist=sumsqr(maxF-maxB);
        a2=0.5;
        if FBdist>0
            a2=(C-maxB)'*(maxF-maxB);
        end
        a2=min(max(a2,0),1);
        alpha(x,y)=a2;
    end
end