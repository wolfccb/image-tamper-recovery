function embedwm(carry, blksize, q, pswd, outfn)
%********************************************************************
% description:
%   image authentication based on semi-fragile watermark.
%   this algorithm uses linear scaling.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%********************************************************************

coder.extrinsic('imread','deintrlv','imshow','imwrite','num2str');
% read carry image
I3 = imread(carry);

% get min and max rgb value
[rgbmin, rgbmax]=prescale(double(I3));

I3 = rgb2ycbcr(I3);

% grayscale image
y = I3(:,:,1);

I3=double(I3);

% expand rgb scale to enhance invisibility
% I3 = postscale(I3, rgbmin, rgbmax);

% get value scale from original image ycbcr
% rmin=zeros(1,3); rmax=zeros(1,3);
[rmin, rmax] = prescale(I3);
[aa, bb, ~] = size(I3);

b=blksize; % for short

% avoid non-integer edge
c = aa-mod(aa,b);
d = bb-mod(bb,b);

% DCT on each 8*8 blocks
[DCT8y, DCT8cb, DCT8cr] = dct3(I3, c, d);

% get encoded SPIHT vector enc for each block
max_bits = (b/8)^2*20-4;
enc=spiht(y, c, d, blksize, '2D CDF 9/7',max_bits);
% enc=ones(c*d/(blksize*blksize), 400);

% generate scramble vector
if pswd~=0
    scramble=logscramble(pswd,c*d/(b*b));
else
    scramble=1:c*d/(b*b);
end

% scramble all encoded blocks
enc=deintrlv(enc, scramble);

% embedding process
n=1;
% for each block
for i=0:c/b-1
    for j=0:d/b-1
        
        % embed recovery watermark into DCT8cb and DCT8cr blocks
        [DCT8cb(i*b+1:i*b+b,j*b+1:j*b+b), DCT8cr(i*b+1:i*b+b,j*b+1:j*b+b)] = ...
            embedc(DCT8cb(i*b+1:i*b+b,j*b+1:j*b+b), ...
                   DCT8cr(i*b+1:i*b+b,j*b+1:j*b+b), b, enc(n,:), q);
         
        % embed authentication watermark into DCT8y blocks
        
%         DCT8y(i*b+1:i*b+b,j*b+1:j*b+b) = ...
%             embedy(DCT8y(i*b+1:i*b+b,j*b+1:j*b+b), b, enc(n,:), q);
              
        n=n+1;
    end
end
    
for i=0:c/8-1
    for j=0:d/8-1
       DCT8y(i*8+1:i*8+8,j*8+1:j*8+8) = embedy(DCT8y(i*8+1:i*8+8,j*8+1:j*8+8), ...
           DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8), DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8), q);
   end
end

% IDCT to restore the ycbcr image
I3 = idct3(DCT8y, DCT8cb, DCT8cr, c, d);

I3 = postscale(I3, rmin, rmax);
I3 = ycbcr2rgb_double(I3);
I3 = postscale(I3, rgbmin, rgbmax);
I3 = uint8(I3);
% figure;imshow(I3);

% write output file
imwrite(I3,outfn);
disp(['q=' num2str(q)]);
% psnr(carry,outfn);
end 