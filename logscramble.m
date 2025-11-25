function out = logscramble(pswd, n)
%********************************************************************
% description:
%   embed watermark into cb and cr.
% author: 
%   Dong Shen. wolfccb@hotmail.com
% input:
%   pswd:       password used for generating logistic sequence
%   n:          sequence length
% output:
%   out:        output index vector
%********************************************************************

x=zeros(1,n);
% out=x;

% make the initial value between 0.09~0.99
x(1)=pswd/1100000+0.09;

% generate logistic sequence
for i=1:n-1
    x(i+1)=4*x(i)*(1-x(i));
end

[~, out]=sort(x);

end