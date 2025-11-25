function out = postscale(in, rmin, rmax)
%********************************************************************
% description:
%   map the value range in input matrix to [rmin, rmax].
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   in:         input image
%   rmin:       3x1 array contains min for each color components 
%   rmax:       3x1 array contains max for each color components
% output:
%   out:        normalized image range from 0~255
%********************************************************************

out=zeros(size(in));
for i=1:3
    mn=min(min(in(:,:,i)));
    mx=max(max(in(:,:,i)));
    out(:,:,i)=(in(:,:,i)-mn)/(mx-mn)*(rmax(i)-rmin(i))+rmin(i);
end

end