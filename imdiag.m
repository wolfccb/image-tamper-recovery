function [outlt, outlb, outrt, outrb]=imdiag(in, c, d)
%********************************************************************
% description:
%   break the image into 4 blocks and switch diagonally.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   in:     the image
%   c,d:    size of the input image
% output:
%   out:    4 output part of the image, l=left, r=right, t=top, b=bottom
%********************************************************************

outlt=imcrop(in, [0 0 d/2 c/2]);
outlb=imcrop(in, [0 c/2+1 d/2 c/2]);
outrt=imcrop(in, [d/2+1 0 d/2 c/2]);
outrb=imcrop(in, [d/2+1 c/2+1 d/2 c/2]);

end