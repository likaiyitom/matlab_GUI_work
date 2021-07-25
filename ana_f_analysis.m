function varargout = ana_f_analysis(varargin)
% ANA_F_ANALYSIS MATLAB code for ana_f_analysis.fig
%      ANA_F_ANALYSIS, by itself, creates a new ANA_F_ANALYSIS or raises the existing
%      singleton*.
%
%      H = ANA_F_ANALYSIS returns the handle to a new ANA_F_ANALYSIS or the handle to
%      the existing singleton*.
%
%      ANA_F_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANA_F_ANALYSIS.M with the given input arguments.
%
%      ANA_F_ANALYSIS('Property','Value',...) creates a new ANA_F_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ana_f_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ana_f_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ana_f_analysis

% Last Modified by GUIDE v2.5 04-Jun-2021 21:21:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ana_f_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @ana_f_analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before ana_f_analysis is made visible.
function ana_f_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ana_f_analysis (see VARARGIN)

% Choose default command line output for ana_f_analysis
handles.output = hObject;

global mode;
mode=1;
image1=imread('circuit1.png');
axes(handles.axes1);
imshow(image1);


%turn off which is used in mode 2
set(handles.text4,'visible','off');
set(handles.text5,'visible','off');
set(handles.text7,'visible','off');
set(handles.edit2,'visible','off');

%disable the edit5(add the capacitor)
set(handles.edit5,'enable','off');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ana_f_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ana_f_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

%----------------self-defined function-------------------------------

%the calculating function of PM,2 poles
%A0 is the amplification factor
function PM=c2_PM(w1,w2,A0)
% w1<w2
A0_dB=20*log10(A0);
%B is the amplification factor when w2 
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


%the calculating function of A0,2 poles
%A0 is the amplification factor
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
ax1.XLabel.String='lg \omega';
ax1.YLabel.String='20lg|\betaH|';
ax1.YLabel.Rotation=0;
ax1.YLabel.Position=[1 A0_dB+15];

hold on;
plot(linspace(ax1.XLim(1),ax1.XLim(2),2000),zeros(2000),'color','k');

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
ax2.YTick=[-180 -150 -120 -90 -60 -30 0];
ax2.XLabel.String='lg \omega';
ax2.YLabel.String='phase angle';
ax2.YLabel.Rotation=0;
ax2.YLabel.Position=[1 5];


hold on;
plot(linspace(ax1.XLim(1),ax1.XLim(2),2000),-180+zeros(2000),'color','k');

PX_p=10*w2;
plot(PX_p,180/pi*angle(A0./((1+1j.*PX_p./w1).*(1+1j.*PX_p./w2))),'r.','MarkerSize',10);
text(PX_p,-165,'PX');
hold off;

end

%----------------end of self-defined function----------------------


% ------------------------- reset ------------------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.edit5,'string','');
set(handles.edit6,'string','');
set(handles.edit7,'string','');
set(handles.edit8,'string','');
set(handles.edit9,'string','');

set(handles.text6,'string','');
set(handles.text7,'string','');

global C1;
C1=0;
global R1;
R1=0;
global C2;
C2=0;
global R2;
R2=0;
global CL;
CL=0;
global A0_input;
A0_input=0;
global PM_input;
PM_input=0;

end


% ------------------------ inputs -----------------------------------

% -------------------------- C1 -------------------------------------
function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit6 as text
global C1;
C1=str2double(get(hObject,'String'));

end


% -------------------------- R1 -------------------------------------
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit7 as text
global R1;
R1=str2double(get(hObject,'String'));

end


% -------------------------- C2 -------------------------------------
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit8 as text
global C2;
C2=str2double(get(hObject,'String'));

end


% -------------------------- R2 -------------------------------------
function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit9 as text
global R2;
R2=str2double(get(hObject,'String'));

end


% -------------------------- CL -------------------------------------
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit5 as text
global CL;
val=str2double(get(hObject,'string'));
if ~isempty(val)
    CL=str2double(get(hObject,'String'));
else
    CL=0;
end

end


% ----------------- A0_input in mode 1 ----------------------------
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
global A0_input;
val=str2double(get(hObject,'string'));
if ~isempty(val)
    A0_input=str2double(get(hObject,'String'));
else
    A0_input=0;
end

end


% ----------------- PM_input in mode 2 ----------------------------
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
global PM_input;
val=str2double(get(hObject,'string'));
if ~isempty(val)
    PM_input=str2double(get(hObject,'String'));
else
    PM_input=0;
end

end

% --------------------- end of inputs -------------------------------


% --------------- the selection of the circuit -----------------------

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to 1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

sel=get(handles.popupmenu1,'value');
image1=imread('circuit1.png');
image2=imread('circuit2.png');
switch sel
    case 1  % common-source mode
     axes(handles.axes1);
     imshow(image1);
    case 2  % common-gate mode
     axes(handles.axes1);
     imshow(image2);
end

end

% --------------- end of the selection of the circuit ---------------


% ----------------------- mode 1 ----------------------------------
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
global mode;
%calculate PM
mode=1;

%turn on which is used in mode 1
set(handles.text2,'visible','on');
set(handles.text3,'visible','on');
set(handles.text6,'visible','on');
set(handles.edit1,'visible','on');

%turn off which is used in mode 2
set(handles.text4,'visible','off');
set(handles.text5,'visible','off');
set(handles.text7,'visible','off');
set(handles.edit2,'visible','off');


end


%------------------------ mode 2 ----------------------------------
% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
global mode;
%calculate A0
mode=2;     


%turn on which is used in mode 2
set(handles.text4,'visible','on');
set(handles.text5,'visible','on');
set(handles.text7,'visible','on');
set(handles.edit2,'visible','on');

%turn off which is used in mode 1
set(handles.text2,'visible','off');
set(handles.text3,'visible','off');
set(handles.text6,'visible','off');
set(handles.edit1,'visible','off');


end


% ------------------ calculate and plot ----------------------------
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A0_input;
global PM_input;

global C1;
global R1;
global C2;
global R2;
global CL;

global mode;


% point A
w1=1/(R1*C1);
%point B
if CL~=0
    w2=1/(R2*(C2+CL));
else
    w2=1/(R2*C2);
end

%if w1>w2,exchange them so that w1<w2
if w1>w2
    w0=w1;
    w1=w2;
    w2=w0;
end

if mode==1
    PM_output=c2_PM(w1,w2,A0_input);
    set(handles.text6,'string',num2str(PM_output));
elseif mode==2
    A0_output=c2_A0(w1,w2,PM_input);
    set(handles.text7,'string',num2str(A0_output));
end

%axes2 display
axes(handles.axes2);
if mode==1
    plot_ampli_ang(A0_input,w1,w2);
elseif mode==2
    plot_ampli_ang(A0_output,w1,w2);
end

end


% ---------------- frequency compensation -----------------------
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1
if get(hObject,'value')
    set(handles.edit5,'enable','on');
else
    set(handles.edit5,'enable','off');
end

end

% -------------------------------------------------------------------
function popupmenu1_CreateFcn(hObject, eventdata, handles)

end
