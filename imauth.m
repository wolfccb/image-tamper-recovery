function imauth(carry, blksize, q, pswd, outfn, mode, maxtime)
%********************************************************************
% description:
%   image authentication based on semi-fragile watermark - encoding.
%   tamper positioning and recovery.
% author: 
%   https://wolfccb.com
% input:
%   carry:    the carry image filename
%   blksize:  size of the embedded recover block
%   q:        quantize factor
%   pswd:     scramble password, 000001~999999, 0 means no scramble
%   outfn:    output filename
%   mode:     string, 'l' for linear scaling, 'x' for multiple embedding
%             'd' for diagonal switch. 'n' for no diagonal switch. 
%             'l' and 'x' are mutually exclusive.
%   maxtime:  max time for multiple embedding.
%********************************************************************
if nargin ~= 7 
    mode='help';
end
    
switch lower(mode)
    case {'ld','dl'}
%         embedwmd(carry, blksize, q, pswd, outfn);
    case {'xd','dx'}
        embedwmxd(carry, blksize, q, pswd, outfn, maxtime);
    case {'ln','nl'}
%         embedwm(carry, blksize, q, pswd, outfn);
    case {'xn','nx'}
%         embedwmx(carry, blksize, q, pswd, outfn);
    otherwise
        disp('-----------------------');
        disp('Invalid mode, usage:');
        disp('imauth(carry, blksize, q, pswd, outfn, mode)');
        disp('   carry:    the carry image filename');
        disp('   blksize:  size of the embedded recover block');
        disp('   q:        quantize factor');
        disp('   pswd:     scramble password, 000001~999999, 0 means no scramble');
        disp('   outfn:    output filename');
        disp('   mode:     string, ''l'' for linear scaling, ''x'' for multiple embedding');
        disp('             ''d'' for diagonal switch. ''n'' for no diagonal switch. ');
        disp('             ''l'' and ''x'' are mutually exclusive.');
        disp('-----------------------');
end