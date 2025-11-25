function [DCT8y, DCT8cb, DCT8cr]=dct3(I3, c, d)
%********************************************************************
% description:
%   dct on color image.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   I3:     the carry image
%   c, d:   size of the area to be transformed
% output:
%   DCT8*:  the carry image dct coefficients
%********************************************************************

% using dctmtx is faster than dct2
% using old blkproc is faster than blockproc
% in this code useparallel is much slower, so it is set false
% T = dctmtx(8);
hdct2d = vision.DCT;

DCT8y = zeros(c,d);
DCT8cb = zeros(c,d);
DCT8cr = zeros(c,d);

% blockFun = @(x) T * x * T';

%DCT8y = blkproc(I3(:,:,1),[8 8],blockFun);
% blockFun= @(block_struct)hdct2d(block_struct.data);
% % 
% DCT8y = blockproc(I3(:,:,1),[8 8],blockFun); %#ok<*DBLKPRC>
% DCT8cb = blockproc(I3(:,:,2),[8 8],blockFun);
% DCT8cr = blockproc(I3(:,:,3),[8 8],blockFun);

% DCT8y = blkproc(I3(:,:,1),[8 8],blockFun); %#ok<*DBLKPRC>
% DCT8cb = blkproc(I3(:,:,2),[8 8],blockFun);
% DCT8cr = blkproc(I3(:,:,3),[8 8],blockFun);
% blockFun = @(block_struct) dct2(block_struct.data);

% DCT8y = blockproc(I3(:,:,1),[8 8], blockFun);
for i=0:c/8-1
    for j=0:d/8-1
%        DCT8y(i*8+1:i*8+8,j*8+1:j*8+8) = dct2(I3(i*8+1:i*8+8,j*8+1:j*8+8,1));
       DCT8y (i*8+1:i*8+8,j*8+1:j*8+8) = hdct2d(I3(i*8+1:i*8+8,j*8+1:j*8+8,1));
       DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8) = hdct2d(I3(i*8+1:i*8+8,j*8+1:j*8+8,2));
       DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8) = hdct2d(I3(i*8+1:i*8+8,j*8+1:j*8+8,3));
    end
end    

% DCT8cb = zeros(c,d);
% %DCT8cb = blkproc(I3(:,:,2),[8 8],blockFun);
% % DCT8cb = blockproc(I3(:,:,2),[8 8], blockFun);
% for i=0:c/8-1
%     for j=0:d/8-1
% %        DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8) = dct2(I3(i*8+1:i*8+8,j*8+1:j*8+8,2));
%         DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8) = hdct2d(I3(i*8+1:i*8+8,j*8+1:j*8+8,2));
%     end
% end    
% 
% DCT8cr = zeros(c,d);
% %DCT8cr = blkproc(I3(:,:,3),[8 8],blockFun);
% % DCT8cr = blockproc(I3(:,:,3),[8 8], blockFun);
% for i=0:c/8-1
%     for j=0:d/8-1
% %        DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8) = dct2(I3(i*8+1:i*8+8,j*8+1:j*8+8,3));
%        DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8) = hdct2d(I3(i*8+1:i*8+8,j*8+1:j*8+8,3));
%     end
% end    

end