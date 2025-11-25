function embedwmx(carry, blksize, q, pswd, outfn)
%********************************************************************
% description:
%   image authentication based on semi-fragile watermark.
%   this algorithm uses multiple embedding.
% author: 
%   https://wolfccb.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%********************************************************************

coder.extrinsic('imread','deintrlv','imshow','imwrite','num2str');
% The output of an extrinsic function is an mxArray - also called a MATLAB
% array. To use mxArrays returned by extrinsic functions, assign the
% mxArray to a variable whose type and size is defined.
I3=zeros([3 3 3],'uint8');
I3=imread(carry);

% grayscale image
I3 = rgb2ycbcr(I3);
y = I3(:,:,1);

% read carry image
I3 = double(imread(carry));
I3 = rgb2ycbcr(I3);

[aa, bb, ~] = size(I3);

b=blksize; % for short

% avoid non-integer edge
c = aa-mod(aa,b);
d = bb-mod(bb,b);

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

% multiple embedding process

% DCT on each 8*8 blocks
[DCT8y, DCT8cb, DCT8cr] = dct3(I3, c, d);

% max times of multiple embedding
maxtimes=5;
for embedtimes=1:maxtimes
    n=1;
    ndirty=0;

    % for each block
    for i=0:c/b-1
        for j=0:d/b-1

            % embed recovery watermark into DCT8cb and DCT8cr blocks
            [DCT8cb(i*b+1:i*b+b,j*b+1:j*b+b), DCT8cr(i*b+1:i*b+b,j*b+1:j*b+b)] = ...
                embedc(DCT8cb(i*b+1:i*b+b,j*b+1:j*b+b), ...
                DCT8cr(i*b+1:i*b+b,j*b+1:j*b+b), b, enc(n,:), q);
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
    I3 = ycbcr2rgb_double(I3);
    I3 = uint8(I3);

    I3 = rgb2ycbcr(double(I3));
    [DCT8y, DCT8cb, DCT8cr] = dct3(I3, c, d);
    
    for i=0:c/8-1
        for j=0:d/8-1
            ndirty = pretest(DCT8y(i*8+1:i*8+8,j*8+1:j*8+8), ...
                DCT8cb(i*8+1:i*8+8,j*8+1:j*8+8), DCT8cr(i*8+1:i*8+8,j*8+1:j*8+8), q);
            if ndirty==1
                break;
            end
        end
        if ndirty==1
            break;
        end
    end

    if ndirty==1
        continue;
    else
        break;
    end
    
end

I3 = ycbcr2rgb_double(I3);
I3 = uint8(I3);

figure;imshow(I3);title(['Embed times: ' num2str(embedtimes)]);
disp(['Embed times: ' num2str(embedtimes)]);
% write output file
imwrite(I3,outfn);
disp(['q=' num2str(q)]);
psnr(carry,outfn);
end 