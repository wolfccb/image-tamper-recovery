function out = extractc(incb, incr, b, q)
%********************************************************************
% description:
%   extract watermark from cb and cr.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   incb:   input dct block of cb
%   incr:   input dct block of cr
%   b:      blocksize
%   q:      quantize factor
% output:
%   out:    extracted bit stream
%********************************************************************

% this pattern decides the coefficients chosen to hide information
pattern = [0 0 0 0 0 0 0 0;...
           0 0 0 0 0 0 0 0;...
           0 0 0 0 0 0 0 0;...
           0 0 0 0 0 0 0 0;...
           0 0 0 0 0 0 1 1;...
           0 0 0 0 0 1 0 1;...
           0 0 0 0 1 0 0 1;...
           0 0 0 0 1 1 1 1];
       
% pattern = [0 0 0 0 0 0 0 0;...
%            0 0 0 0 0 0 0 0;...
%            0 0 0 0 0 1 0 0;...
%            0 0 0 0 0 0 0 0;...
%            0 0 0 0 0 0 1 1;...
%            0 1 0 0 0 1 0 0;...
%            0 0 0 0 1 0 0 0;...
%            0 0 0 0 0 1 0 1];

% extend the pattern to fit the blocksize b
if b~=8
    pattern = wextend(2, 'per', pattern, [b-8, b-8], 'rd');
end
     
% for each element of incb and incr
% j is the enc pointer, i is the block pointer
out=zeros(1,2*sum(sum(pattern)));
j=1;
for i=1:b*b         
    if pattern(i)==1
        % extract from cb
        if mod(round(incb(i)/q),2)==1
        % if abs(round(incb(i)/(q*0.125)))~=0
            out(j)=1;
        else
            out(j)=0;
        end
        j=j+1;
        
        % extract from cr
        if mod(round(incr(i)/q),2)==1
        % if abs(round(incr(i)/(q*0.125)))~=0
            out(j)=1;
        else
            out(j)=0;
        end
        j=j+1;
    end
end

end