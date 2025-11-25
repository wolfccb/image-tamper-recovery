function embedwmxd(carry, blksize, q, pswd, outfn, maxtime) %#codegen
%********************************************************************
% description:
%   image authentication based on semi-fragile watermark.
%   this algorithm uses diag-break and multiple embedding.
% author: 
%   https://wolfccb.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%   maxtime:  max time for multiple embedding
%********************************************************************

coder.extrinsic('imread','deintrlv','imshow','imwrite','num2str','psnr');
% The output of an extrinsic function is an mxArray - also called a MATLAB
% array. To use mxArrays returned by extrinsic functions, assign the
% mxArray to a variable whose type and size is defined.

I3u=zeros([10000 10000 3],'uint8');
coder.varsize('I3u');
I3u=imread(carry);
I3=double(I3u);

% grayscale image
I3u = rgb2ycbcr(I3u);
y = I3u(:,:,1);

% read carry image
% coder.varsize('I3');
% I3 = zeros([3 3 3],'double');
% I3 = double(imread(carry));
I3 = rgb2ycbcr(I3);

b=blksize; % for short

[aa, bb, ~] = size(I3u);
% avoid non-integer edge
c = aa-mod(aa,b*2);
d = bb-mod(bb,b*2);

y = imcrop(y, [0 0 d c]);

% diag break the gray image
[ylt, ylb, yrt, yrb]=imdiag(y, c, d);

% get encoded SPIHT vector enc for each block
max_bits = (b/8)^2*20-4;
enclt=spiht(ylt, c/2, d/2, b, '2D CDF 9/7',max_bits);
enclb=spiht(ylb, c/2, d/2, b, '2D CDF 9/7',max_bits);
encrt=spiht(yrt, c/2, d/2, b, '2D CDF 9/7',max_bits);
encrb=spiht(yrb, c/2, d/2, b, '2D CDF 9/7',max_bits);

% generate scramble vector
if pswd~=0
    scramble=logscramble(pswd,c*d/(b*b)/4);
    % scramble all encoded blocks
    enclt=deintrlv(enclt, scramble);
    enclb=deintrlv(enclb, scramble);
    encrt=deintrlv(encrt, scramble);
    encrb=deintrlv(encrb, scramble);
end

% n is the count of blocks
n=c*d/(b*b);
enc=zeros(n, max_bits+4);
j=1;
k=1;
for i=1:c/b/2
    enc(j:j+d/b/2-1,:)=encrb(k:k+d/b/2-1,:);
    enc(j+d/b/2:j+d/b-1,:)=enclb(k:k+d/b/2-1,:);
    j=j+d/b;
    k=k+d/b/2;
end

k=1;
for i=1:c/b/2
    enc(j:j+d/b/2-1,:)=encrt(k:k+d/b/2-1,:);
    enc(j+d/b/2:j+d/b-1,:)=enclt(k:k+d/b/2-1,:);
    j=j+d/b;
    k=k+d/b/2;
end

% multiple embedding process

% DCT on each 8*8 blocks
[DCT8y, DCT8cb, DCT8cr] = dct3(I3, c, d);
embedtimesrecord=1;
for embedtimes=1:maxtime
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
    I3u = uint8(I3);

    I3 = rgb2ycbcr(double(I3u));
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
    embedtimesrecord=embedtimes;

    if ndirty==1
        continue;
    else
        break;
    end
end

I3 = ycbcr2rgb_double(I3);
I3u = uint8(I3);

figure;imshow(I3u);title(['Embed times: ' num2str(embedtimesrecord)]);
disp(['Embed times: ' num2str(embedtimesrecord)]);
% write output file
imwrite(I3u,outfn);
disp(['q=' num2str(q)]);
psnr(carry,outfn);
end 