function extractwm(carry, blksize, q, pswd, outfn)
%********************************************************************
% description:
%   extract watermark, locate and restore the tamper zone.
% author: 
%   https://wolfccb.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%********************************************************************

% read carry image
I_test = imread(carry);

% avoid non-integer edge
[aa,bb,~] = size(I_test);
c = aa-mod(aa,blksize);
d = bb-mod(bb,blksize);
I_test=imcrop(I_test, [1 1 d c]);

I3 = rgb2ycbcr(double(I_test));

% DCT on each 8*8 blocks
[DCT8y, DCT8cb, DCT8cr] = dct3(I3, c, d);

% extracting process
b=blksize; % for short

% wavelet decomposition level
level = log2(b);

% generate filters
type = '2D CDF 9/7';
% type = 'haar';
% [Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

% extracted image
I = uint8(zeros(aa-mod(aa,blksize),bb-mod(bb,blksize)));

% dirtymark matrix
dirtymark=I;

max_bits = (b/8)^2*20-4;
enc=zeros(c*d/(b*b), max_bits+4);

n=1;
% for each block
for i=0:c/b-1
    for j=0:d/b-1
        % extract recovery watermark from DCT8cb and DCT8cr blocks
        temp = extractc(DCT8cb(i*b+1:i*b+b,j*b+1:j*b+b), ...
                            DCT8cr(i*b+1:i*b+b,j*b+1:j*b+b), ...
                            b, q);
        
        % decode bitplane
        bitplane = bi2de(temp( (length(temp)-3):length(temp)));
        
        % reconstruct spiht stream
        temp = [b bitplane level ...
            temp( find(temp,1,'first'):(length(temp)-4) )];
        
        enc(n,:) = [temp 2*ones(1,320-length(temp))];
        
        n=n+1;
    end
end

for i=0:c/8-1
    for j=0:d/8-1
       dirtymark(i*8+1:i*8+8,j*8+1:j*8+8) = extracty(DCT8y(i*8+1:i*8+8,j*8+1:j*8+8), ...
           DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8), DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8), q);
   end
end

% generate scramble vector
if pswd~=0
    scramble=logscramble(pswd,c*d/(b*b));
else
    scramble=1:c*d/(b*b);
end

% scramble enc vectors
% detect=intrlv(enc, scramble);

n=1;
for i=0:c/b-1
    for j=0:d/b-1
        try
            I(i*b+1:i*b+b,j*b+1:j*b+b) = ...
                wavelet(type, -1*level, ...
                func_SPIHT_Dec(enc(scramble(n),:))*8, 'sp0');
        catch
            I(i*b+1:i*b+b,j*b+1:j*b+b) = 0;
        end
        n=n+1;
    end
end

% morph the dirtymark
dirtymark=morph(dirtymark);

I_test=rgb2ycbcr(I_test);
I_gray=I_test(:,:,1);
I_test(:,:,1)=I.*dirtymark+I_gray.*uint8(~dirtymark);

% figure; imshow(I);title('Extracted image');
% figure; imshow(dirtymark*255);title('Dirty mark');
% figure; imshow(I_test(:,:,1));title('Restored image');
imwrite(I_test(:,:,1),outfn);
end