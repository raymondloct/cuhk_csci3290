function [b_img,g_img,r_img] = autoCropping(img)
% This function crops the given img into the 3 channels
% assumption: image borders are either horizontal or vertical
% output: 3 reduced-size images
	[h,w] = size(img);
    h1=floor(h/3);
    search_px=floor(w*0.05);
    confidence=95;
    confidence2=97;
    border_rows=ones(6,1);
    border_cols=ones(6,1);
	% compute row sums and apply 
	rowSum=sum(img,2);
	% pad the edges
	r1=rowSum(1);
	r2=rowSum(end);
	rowSum=[r1;r1;r1;rowSum;r2;r2;r2];
	% filter
	f=[1;4;5;0;-5;-4;-1];
	row_f=abs(conv(rowSum,f,'valid'));
    criteria=prctile(row_f,confidence);
    % looking for horizontal borders
	peaks=[];
    for i=2:2*search_px
        if row_f(i)>=criteria && row_f(i)>=row_f(i-1) && row_f(i)>=row_f(i+1)
            peaks=[peaks;[i,row_f(i)]];
        end
    end
    if size(peaks)>0
       border_rows(1)=peaks(end,1);
    end
    peaks=[];
    for i=h1-search_px:h1+search_px
        if row_f(i)>=criteria && row_f(i)>=row_f(i-1) && row_f(i)>=row_f(i+1)
            peaks=[peaks;[i,row_f(i)]];
        end
    end
    if size(peaks)>1
       m_index=sortrows(peaks,2);
       m1=m_index(1,1);
       m2=m_index(2,1);
       border_rows(2)=min(m1,m2);
       border_rows(3)=max(m1,m2);
    elseif size(peaks)==1
       border_rows(2)=peaks(1,1);
       border_rows(3)=peaks(1,1);
    else
       border_rows(2)=h1;
       border_rows(3)=h1;
    end
    peaks=[];
    for i=2*h1-search_px:2*h1+search_px
        if row_f(i)>=criteria && row_f(i)>=row_f(i-1) && row_f(i)>=row_f(i+1)
            peaks=[peaks;[i,row_f(i)]];
        end
    end
    if size(peaks)>1
       m_index=sortrows(peaks,2);
       m1=m_index(1,1);
       m2=m_index(2,1);
       border_rows(4)=min(m1,m2);
       border_rows(5)=max(m1,m2);
    elseif size(peaks)==1
       border_rows(4)=peaks(1,1);
       border_rows(5)=peaks(1,1);
    else
       border_rows(4)=2*h1;
       border_rows(5)=2*h1;
    end
    peaks=[];
    for i=h-2*search_px:h-1
        if row_f(i)>=criteria && row_f(i)>=row_f(i-1) && row_f(i)>=row_f(i+1)
            peaks=[peaks;i,row_f(i)];
        end
    end
    if size(peaks)>0
       border_rows(6)=peaks(1,1);
    else
       border_rows(6)=h;
    end
    % now look for vertical borders
    for j=1:3
        cropped=img(border_rows(2*j-1):border_rows(2*j),:);
        colSum=sum(cropped,1);
        c1=colSum(1);
        c2=colSum(end);
        colSum=[c1,c1,c1,colSum,c2,c2,c2];
        col_f=abs(conv(colSum,f,'valid'));
        criteria2=prctile(col_f,confidence2);        
        peaks=[];
        for i=2:2*search_px
            if col_f(i)>=criteria2 && col_f(i)>=col_f(i-1) && col_f(i)>=col_f(i+1)
                peaks=[peaks;[i,col_f(i)]];
            end
        end
        if size(peaks)>0
           border_cols(2*j-1)=peaks(end,1);
        end
        peaks=[];
        for i=w-2*search_px:w-1
            if col_f(i)>=criteria2 && col_f(i)>=col_f(i-1) && col_f(i)>=col_f(i+1)
                peaks=[peaks;i,col_f(i)];
            end
        end
        if size(peaks)>0
           border_cols(2*j)=peaks(1,1);
        else
           border_cols(2*j)=w;
        end
    end
    b_img=img(border_rows(1):border_rows(2),border_cols(1):border_cols(2));
    g_img=img(border_rows(3):border_rows(4),border_cols(3):border_cols(4));
    r_img=img(border_rows(5):border_rows(6),border_cols(5):border_cols(6));
end