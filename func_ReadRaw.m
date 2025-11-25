function result = func_ReadRaw(filename, nSize, nRow, nColumn)
% Matlab implementation of SPIHT (without Arithmatic coding stage)
%
% Read a RAW format gray scale image from disk
%
% input:    filename : input file
%           nSize : size of the output image
%           nRow : row of the output image
%           nColumn : column of the output image
%
% output:   result : output data in matrix format
%
% Jing Tian
% Contact me : scuteejtian@hotmail.com
% This program is part of my undergraduate project in GuangZhou, P. R. China.
% April - July 1999

fid = fopen(filename,'rb');
if (fid==1)
   error('Cannot open image file...press CTRL-C to exit ');
end
temp = fread(fid, nSize, 'uchar');
fclose(fid);
result = reshape(temp, [nRow nColumn])';

