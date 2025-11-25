function enc=spiht(I, c, d, b, type, max_bits)
%********************************************************************
% description:
%   compress image with spiht method based on cdf9/7 dwt.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   I:          the carry image
%   c, d:       size of the area to be transformed
%   b:          blocksize
%   type:       name of wavelet
%   max_bits:   max bits of output bit stream
% output:
%   enc:        fixed length spiht bit stream, starting with the first 1,
%               followed by bit stream, the last 4 bits save the number of
%               bitplane.
%********************************************************************

% I/8 means to reduce the amplitude of wavelet matrix, in order to avoid 
% the error "Exceeded value of bitmax". 
% needs to *8 in extractwmd.m and extractwm.m
I = double(I)/8;
% max_bits = floor(rate*b*b);
% max_bits=316;

enc=zeros(c*d/(b*b), max_bits+4);

% wavelet decomposition level and filters
level = log2(b);
% [Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

%n=1;

for i=0:c/b-1
    t=i*d/b+1;
    for j=0:d/b-1
        % wavelet decomposition
        I_W = wavelet(type, level, I(i*b+1:i*b+b,j*b+1:j*b+b), 'sp0');
        
        % encoding
        temp = [func_SPIHT_Enc(I_W, max_bits+3, b*b, level) zeros(1,4)];
        bitplane = temp(2);        
    
        % delete the unnecessary tail elements
        %temp=temp(4:length(temp));
        temp(temp==2) = [];
        
        % append the number of bitplane to temp
        temp(length(temp)-3:length(temp))= de2bi(bitplane, 4);
        
        
        % add zeros before the output spiht vector
        enc(j+t,:)=[zeros(1, max_bits+4-length(temp)+3) temp(4:length(temp))];
        %disp(i*(d/b)+j+1-n);
        %n=n+1;
    end
end

end