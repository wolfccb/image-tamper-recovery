function out = embedy(iny, incb, incr, q)
%********************************************************************
% description:
%   embed watermark into y.
% author: 
%   https://wolfccb.com
% input:
%   in:         input dct block
%   b:          blocksize
%   enc:        bitstream in cb and cr
%   q:          quantize factor
% output:
%   out:        embedded dct block
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

out=iny;
j=1;
for i=1:64
    if pattern(i)==1
        if parityvec(j)==1
            % embed 1, make mod (out,2) is odd, energy cut towards zero
            temp=round(iny(i)/q);
            if mod(temp,2)==0
                if iny(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            out(i)=temp*q;
        else
            % embed 0, make mod (out,2) is even, energy cut towards zero
            temp=round(iny(i)/q);
            if mod(temp,2)==1
                if iny(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            out(i)=temp*q;
        end
        j=j+1;
    end
end

end