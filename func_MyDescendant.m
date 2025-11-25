function value = func_MyDescendant(i, j, type, m)
% Matlab implementation of SPIHT (without Arithmatic coding stage)
%
% Find the descendant with largest absolute value of pixel (i,j)
%
% input:    i : row coordinate
%           j : column coordinate
%           type : type of descendant
%           m : whole image
%
% output:   value : largest absolute value
%
% Jing Tian
% Contact me : scuteejtian@hotmail.com
% This program is part of my undergraduate project in GuangZhou, P. R. China.
% April - July 1999

s = size(m,1);

% S = [];
temp=0;

index = 0; x=1;
% a = 0; b = 0;

a = i-1; b = j-1;

mind = 2*(a+1)-1:2*(a+x);
nind = 2*(b+1)-1:2*(b+x);


% chk = mind <= s;
% len = sum(chk);
len = sum(mind <= s);
% if len < length(mind)
if len < 2*x
    mind(len+1:length(mind)) = [];
end


chk = nind <= s;
len = sum(chk);
% if len < length(nind)
if len < 2*x
    nind(len+1:length(nind)) = [];
end

% S = [S reshape(m(mind,nind),1,[])];

if type ~=1

    temp=max(max(abs(m(mind,nind))));
end

index = index + 1;x=2*x;
i = 2*a+1; j = 2*b+1;
    
while ((2*i-1)<s && (2*j-1)<s)
    a = i-1; b = j-1;

    mind = 2*(a+1)-1:2*(a+x);
    nind = 2*(b+1)-1:2*(b+x);
    
    
%     chk = mind <= s;
%     len = sum(chk);
    len = sum(mind <= s);
%     if len < length(mind)
    if len < 2*x
        mind(len+1:length(mind)) = [];
    end
    
    
%     chk = nind <= s;
%     len = sum(chk);
    len = sum(nind <= s);
%     if len < length(nind)
    if len < 2*x
        nind(len+1:length(nind)) = [];
    end
    
%     S = [S reshape(m(mind,nind),1,[])];
    temp=max(temp,max(max(abs(m(mind,nind)))));
    
    index = index + 1;x=2*x;
    i = 2*a+1; j = 2*b+1;
end

% if type == 1
%     S(:,1:4) = []; 
% end

% value = max(abs(S));
value = temp;