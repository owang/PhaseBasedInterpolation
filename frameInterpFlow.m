% Simple flow based frame interpolation
% Forward warp first frame, backwards warp second frame and blend
% Replace parfor with for if the parallel toolbox is not available.
function out = frameInterpFlow(im1, im2, flow, alpha)  

%% Setup
im1 = im2double(im1);
im2 = im2double(im2);
[h, w, c] = size(im2);
[mx, my]   = meshgrid(1:w,1:h);

%% Forward warp flow
fmx = mx + alpha*flow(:,:,1);
fmy = my + alpha*flow(:,:,2);
flow(:,:,1) = griddata(fmx, fmy, flow(:,:,1), mx, my);
flow(:,:,2) = griddata(fmx, fmy, flow(:,:,2), mx, my);

%% Forward warp im1 
im1f = zeros(h,w,c);
parfor i = 1:c
    im1f(:,:,i) = griddata(fmx, fmy, im1(:,:,i), mx, my);
end

%% Replace empty pixels
nans=find(isnan(im1f));
im1f(nans)=im1(nans);

%% Backwards warp im2
bmx = mx + (1-alpha)*flow(:,:,1);
bmy = my + (1-alpha)*flow(:,:,2);

im2b = zeros(h,w,c);
parfor i = 1:c
    im2b(:,:,i) = interp2(mx, my, im2(:, :, i), bmx, bmy, 'bicubic', NaN);
end

%% Replace empty pixels
nans=find(isnan(im2b));
im2b(nans)=im2(nans);

%% Cap values
im2b = min(im2b,1);

%% Blend images
out = (1-alpha)*im1f + alpha*im2b;