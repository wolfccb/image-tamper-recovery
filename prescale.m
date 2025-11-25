function [rmin,rmax]=prescale(in)
%********************************************************************
% description:
%   get the min and max value of a matrix.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   in:         input image
% output:
%   rmin:       3x1 array contains min for each color components 
%   rmax:       3x1 array contains max for each color components
%********************************************************************
rmin=[0,0,0];rmax=[0,0,0];
for i=1:3
    rmin(i)=min(min(in(:,:,i)));
    rmax(i)=max(max(in(:,:,i)));
end

end