function res = poisson_equ( img, F_B, trimap )
% Input:
%   - img: input color image
%   - F_B: F-B image
%   - trimap: trimap
% Output:
%   - res: result of alpha 

    [H,W,C] = size(img);
    if C==3
        img = rgb2gray(img);
    end
% use robust eps to avoid dividing 0
% TODO: change eps value will probably produce better results
    eps     = 0.1;
    F_B     = sign(F_B).*max(abs(F_B),eps);
    F_B(F_B==0)  = eps;
    %% calculate image gradients
    gx = zeros(H,W); 
    gy = zeros(H,W); 
    j = 1:H-1; 
    k = 1:W-1;
    gx(j,k) = (img(j,k+1) - img(j,k)); 
    gy(j,k) = (img(j+1,k) - img(j,k));
    % image gradients are divided by F-B
    gx = gx./F_B;
    gy = gy./F_B;
    
    %% solve Poisson equation
    mask_undecided = (trimap==0.5);
    res = solve_poisson_equ( gx, gy, mask_undecided, trimap );
    
    res(res>1) = 1;
    res(res<0) = 0;
end

function out = solve_poisson_equ( Ix, Iy, mask, img )
    
    [H,W] = size(img);
    gxx = zeros(H,W); 
    gyy = zeros(H,W);
    j = 1:H-1; 
    k = 1:W-1;
    % Laplacian
    gxx(j,k+1) = Ix(j,k+1) - Ix(j,k); 
    gyy(j+1,k) = Iy(j+1,k) - Iy(j,k); 
    f = -(gxx + gyy);
    
    I = f.*mask;
    h   = fspecial('laplacian', 0);
    chi = imfilter(double(mask),h);
    chi(chi<0) = 0;
    chi(chi>0) = 1;
    chi = chi.*(~mask);
    I(chi>0) = img(chi>0);
    
    [r,c] = size(img);
    k = r*c;

    %% Matrix Construction
    % Ones for columns and rows
    dy = ones(size(I,1)-1, size(I,2));
    dy = padarray(dy, [1 0], 'post');
    dy = dy(:);

    dx = ones(size(I,1), size(I,2)-1);
    dx = padarray(dx, [0 1], 'post');
    dx = dx(:);
    
    % Construct five-point spatially homogeneous Laplacian matrix
    C(:,1) = dx;
    C(:,2) = dy;
    d = [-r,-1];
    A = spdiags(C,d,k,k);

    e = dx;
    w = padarray(dx, r, 'pre'); w = w(1:end-r);
    s = dy;
    n = padarray(dy, 1, 'pre'); n = n(1:end-1);

    % D = -(e+w+s+n);
    D = ((e+w+s+n)) .* mask(:) + (1-mask(:));
    L = -(A + A');
    m = find(~mask);
    L(m,:) = 0;
    L = L+spdiags(D, 0, k, k);

    % Solve
    out = L\I(:);
    out = reshape(out, r, c);

    out(~mask) = img(~mask);
end