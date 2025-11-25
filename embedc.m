function [outcb, outcr] = embedc(incb, incr, b, enc, q)
%********************************************************************
% description:
%   embed watermark into cb and cr.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   incb:   input dct block of cb
%   incr:   input dct block of cr
%   b:      blocksize
%   enc:    bit stream to embed
%   q:      quantize factor
% output:
%   outcb:  embedded dct block of cb
%   outcr:  embedded dct block of cr
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
%            0 0 0 1 1 0 0 0;...
%            0 0 1 1 1 0 0 0;...
%            0 1 1 1 0 0 0 0;...
%            0 1 1 0 0 0 0 0;...
%            0 0 0 0 0 0 0 0;...
%            0 0 0 0 0 0 0 0;...
%            0 0 0 0 0 0 0 0];
% extend the pattern to fit the blocksize b
pattern = wextend(2, 'per', pattern, [b-8, b-8], 'rd');
     
% enc=ones(1,320);
% for each element of incb and incr
% j is the enc pointer, i is the block pointer
j=1;
outcb=incb; outcr=incr;
for i=1:b*b         
    if pattern(i)==1
        %if j==177 && i==647
        %    disp(j);
        %end
        
        % embed into cb
        if enc(j)==1
            % embed 1, make mod (out,2) is odd, energy cut towards zero
            temp=round(incb(i)/q);
            if mod(temp,2)==0
                if incb(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            outcb(i)=temp*q;
        else
            % embed 0, make mod (out,2) is even, energy cut towards zero
            temp=round(incb(i)/q);
            if mod(temp,2)==1
                if incb(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            outcb(i)=temp*q;
        end
        j=j+1;
        
        % embed into cr
        if enc(j)==1
            % embed 1, make mod (out,2) is odd, energy cut towards zero
            temp=round(incr(i)/q);
            if mod(temp,2)==0
                if incr(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            outcr(i)=temp*q;
        else
            % embed 0, make mod (out,2) is even, energy cut towards zero
            temp=round(incr(i)/q);
            if mod(temp,2)==1
                if incr(i)>0
                    temp=temp-1;
                else
                    temp=temp+1;
                end
            end
            outcr(i)=temp*q;
        end
        j=j+1;
    end
end

end