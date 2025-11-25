function imdeauth(carry, blksize, q, pswd, outfn, mode)
%********************************************************************
% description:
%   image authentication based on semi-fragile watermark - decoding.
%   tamper positioning and recovery.
% author: 
%   https://wolfccb.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%   mode:     string, 'd' for diagonal switch. 'n' for no diagonal switch.
%********************************************************************
coder.extrinsic('imread','deintrlv','imshow','imwrite','num2str','psnr','intrlv');
if nargin ~= 6 
    mode='help';
end
    
switch lower(mode)
    case 'd'
        extractwmd(carry, blksize, q, pswd, outfn);
    case 'n'
        %extractwm(carry, blksize, q, pswd, outfn);
    otherwise
        disp('-----------------------');
        disp('Invalid mode, usage:');
        disp('imauth(carry, blksize, q, pswd, outfn, mode)');
        disp('   carry:    the carry image filename');
        disp('   blksize:  size of the embedded recover block');
        disp('   q:        quantize factor');
        disp('   pswd:     scramble password, 000001~999999, 0 means no scramble');
        disp('   outfn:    output filename');
        disp('   mode:     string, ''d'' for diagonal switch. ''n'' for no diagonal switch. ');
        disp('-----------------------');
end