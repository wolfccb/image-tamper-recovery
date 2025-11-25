function out = morph(dirtymark)
%********************************************************************
% description:
%   morph the dirtymark by imclose.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   dirtymark:  dirtymark to be morphed
% output:
%   out:        output dirtymark matrix
%********************************************************************

sel = strel('octagon',9);
out = imclose(dirtymark,sel);

end