function psnr=calc_psnr(I1,I2)
%********************************************************************
% description:
%   calculate psnr between two grayscale image.
% author: 
%   https://wolfccb.com
% input:
%   I1,I2:    images to compare, must be 2d
%********************************************************************

[aa, bb] = size(I1);
Q = 255;
MSE = sum(sum((I1 - I2) .^ 2)) / aa / bb;
psnr = 10*log10(Q*Q/MSE);

end