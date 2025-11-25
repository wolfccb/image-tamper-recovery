function out = extracty(iny, incb, incr, q)
%********************************************************************
% input:
%   in:         input dct block
%   b:          blocksize
%   enc:        bitstream in cb and cr
%   q:          quantize factor
% output:
%   out:        dirtymark matrix, 1 means dirty
%********************************************************************

% pattern decides the coefficients chosen to hide information
% pattern =  [0 0 0 0 0 0 0 0;...
%             0 0 0 0 0 0 0 0;...
%             0 0 0 0 0 0 0 0;...
%             0 0 0 0 0 0 0 0;...
%             0 0 0 0 0 1 0 0;...
%             0 0 0 0 0 0 1 0;...
%             0 0 0 0 1 0 0 0;...
%             0 0 0 0 0 0 0 0];

pattern =  [0 0 0 0 0 0 0 0;...
            0 0 0 0 0 0 0 0;...
            0 0 0 0 0 0 0 0;...
            0 0 0 0 0 0 0 0;...
            0 0 0 0 0 0 0 0;...
            0 0 0 0 0 0 1 0;...
            0 0 0 0 0 1 1 0;...
            0 0 0 0 0 0 0 0];

embeddedc = extractc(incb, incr, 8, q);
embeddedc = reshape(embeddedc, 2, []);

% generate parity bits for the 8*8 block
parityvec = zeros(1,3);
parityvec(1) = ~mod(sum(embeddedc(1,:)),2);
parityvec(2) = mod(sum(embeddedc(2,:)),2);
parityvec(3) = mod(sum(parityvec(1:2)),2);
% parityvec(3) = mod(round(iny(4,4)/q),2);

temp=zeros(1,3);
j=1;
for i=1:64
    if pattern(i)==1
        if mod(round(iny(i)/q),2)==parityvec(j)
            temp(j)=0;
        else
            temp(j)=1;
        end
        j=j+1;
    end
end

if sum(temp)~=0
    out=ones(8,8);
else
    out=zeros(8,8);
end

end