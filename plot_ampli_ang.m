%plot function
function plot_ampli_ang(A0,w1,w2)
w=logspace(0.1,4.2,2000);
H=A0./((1+1j.*w./w1).*(1+1j.*w./w2));
%amplification factor in dB
H_dB=20*log10(abs(H));
A0_dB=20*log10(A0);
%phase angle in deg
H_ang=angle(H);
H_ang_deg=H_ang*180/pi;


%plot1 amplitude graph
subplot(2,1,1)
semilogx(w,H_dB,'linewidth',1.5);

%set axis properties
ax1=gca;
ax1.XLim=[1 10^4.5];
ax1.YLim=[-10 A0_dB+10];
ax1.XGrid='on';
ax1.YGrid='on';
%ax1.XTick=[];
%ax1.YTick=[];
ax1.XLabel.String='lg \omega';
ax1.YLabel.String='20lg|\betaH|';
ax1.YLabel.Rotation=0;
%ax1.YLabel.Position=[0 5];

hold on;
% y=0
plot(linspace(ax1.XLim(1),ax1.XLim(2),2000),zeros(2000),'color','k');
%set figure properties
%h1=gcf;
%h1.Color='k';
%set GX point
GX_p1=w(H_dB<1);
GX_p=GX_p1(1);
plot(GX_p,0,'r.','MarkerSize',10);
text(GX_p,5,'GX');
hold off;


%plot2 phase angle graph
subplot(2,1,2)
semilogx(w,H_ang_deg,'linewidth',1.5)

%set axis properties
ax2=gca;
ax2.XLim=[1 10^4.5];
ax2.YLim=[-190 5];
ax2.XGrid='on';
ax2.YGrid='on';
%ax2.XTick=[];
ax2.YTick=[-180 -150 -120 -90 -60 -30 0];
ax2.XLabel.String='lg \omega';
ax2.YLabel.String='phase angle';
ax2.YLabel.Rotation=0;
%ax2.YLabel.Position=[0 5];


hold on;
plot(linspace(ax1.XLim(1),ax1.XLim(2),2000),-180+zeros(2000),'color','k');
%set figure properties
%h2=gcf;
%h2.Color='k';
PX_p=10*w2;
plot(PX_p,180/pi*angle(A0./((1+1j.*PX_p./w1).*(1+1j.*PX_p./w2))),'r.','MarkerSize',10);
text(PX_p,-165,'PX');
hold off;

end
