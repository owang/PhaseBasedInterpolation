%% Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!!

% reconstruct an image from the interpolated pyramid
function out_img = reconstructImage(pyr,param,pind)

imSize = pind(1,:);
dim = size(pyr,2);
out_img = zeros(imSize(1),imSize(2),dim);

% reconstruct each color channel
for i=1:dim
    out_img(:,:,i) = reconSCFpyr_scale(pyr(:,i), pind, ...
        'all', 'all', param.tWidth, param.scale, param.nScales);
end

% convert to RGB
out_img = im2uint8(out_img);
cform = makecform('lab2srgb');
out_img = applycform(out_img,cform);

end

