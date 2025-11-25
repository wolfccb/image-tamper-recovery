function psnr(fn1,fn2)
%********************************************************************
% description:
%   calculate and display psnr between two color images.
% author: 
%   https://wolfccb.com
% input:
%   fn1,fn2:    filenames of images to compare
%********************************************************************

coder.extrinsic('imread','num2str');

a=imread(fn1);
b=imread(fn2);
r=calc_psnr(a(:,:,1),b(:,:,1));
g=calc_psnr(a(:,:,2),b(:,:,2));
b=calc_psnr(a(:,:,3),b(:,:,3));

disp(['R=' num2str(r) ', G=' num2str(g) ', B=' num2str(b)]);
disp(['mean=' num2str((r+g+b)/3)]);
end