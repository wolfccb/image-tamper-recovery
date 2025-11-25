function I3=idct3(DCT8y, DCT8cb, DCT8cr, c, d)
%********************************************************************
% description:
%   idct on color image.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   DCT8*:  the carry image dct coefficients
%   c, d:   size of the area to restore
% output:
%   I3:     the restored image
%********************************************************************

% T = dctmtx(8);
hidct2d = vision.IDCT;

I3 = zeros(c, d, 3);

% blockFun = @(block_struct) idct2(block_struct.data);
% blockFun = @(x) T' * x * T;
% I3(:,:,1) = blkproc(DCT8y,[8 8], blockFun); %#ok<*DBLKPRC>
% I3(:,:,2) = blkproc(DCT8cb,[8 8], blockFun);
% I3(:,:,3) = blkproc(DCT8cr,[8 8], blockFun);
% I3(:,:,1) = blockproc(DCT8y,[8 8], blockFun);
% I3(:,:,2) = blockproc(DCT8cb,[8 8], blockFun);
% I3(:,:,3) = blockproc(DCT8cr,[8 8], blockFun);

% I3(:,:,1) = blkproc(DCT8y,[8 8],'P1*x*P2',T',T);
% I3(:,:,2) = blkproc(DCT8cb,[8 8],'P1*x*P2',T',T);
% I3(:,:,3) = blkproc(DCT8cr,[8 8],'P1*x*P2',T',T);

for i=0:c/8-1
    for j=0:d/8-1
%        I3(i*8+1:i*8+8,j*8+1:j*8+8,1) = idct2(DCT8y(i*8+1:i*8+8,j*8+1:j*8+8));
       I3(i*8+1:i*8+8,j*8+1:j*8+8,1) = hidct2d(DCT8y(i*8+1:i*8+8,j*8+1:j*8+8));
       I3(i*8+1:i*8+8,j*8+1:j*8+8,2) = hidct2d(DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8));
       I3(i*8+1:i*8+8,j*8+1:j*8+8,3) = hidct2d(DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8));
   end
end

% for i=0:c/8-1
%     for j=0:d/8-1
% %        I3(i*8+1:i*8+8,j*8+1:j*8+8,2) = idct2(DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8));
%        I3(i*8+1:i*8+8,j*8+1:j*8+8,2) = hidct2d(DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8));
%    end
% end
% 
% for i=0:c/8-1
%     for j=0:d/8-1
% %        I3(i*8+1:i*8+8,j*8+1:j*8+8,3) = idct2(DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8));
%        I3(i*8+1:i*8+8,j*8+1:j*8+8,3) = hidct2d(DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8));
%    end
% end

end