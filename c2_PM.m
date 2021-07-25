%the calculating function of PM,2 poles
function PM=c2_PM(w1,w2,A0)
% w1<w2
A0_dB=20*log10(A0);
%B is the amplifcation factor when w2 
B=A0_dB-20*log10(w2/w1);
if B<0
%GX is the frequency of gain crossover point
    GX=w1*10^(A0_dB/20);
else
    GX=w2*10^(B/40);
end
%ang is the angle of betaH in GX
ang=atan(GX/w1)+atan(GX/w2);
ang=ang*180/pi;
PM=180-ang;
end