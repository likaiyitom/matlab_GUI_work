%the calculating function of A0,2 poles
function A0=c2_A0(w1,w2,PM)
% ang is the angle in GX
ang=PM-180;
syms w;
%w is the frequency of GX
w=solve(atan(w/w1)+atan(w/w2)==-ang/180*pi,w);
w=double(w);

%GX is higher than w2
if w>w2
    B=40*log10(w/w2);
    A0_dB=B+20*log10(w2/w1);
%GX is between w1 and w2
else
    A0_dB=20*log10(w/w1);
end

A0=10.^(A0_dB/20);

end
