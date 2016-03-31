function varargout = match(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @match_OpeningFcn, ...
                   'gui_OutputFcn',  @match_OutputFcn, ...
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


% --- Executes just before match is made visible.
function match_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.circuit);%用axes命令设定当前操作的坐标轴是axes_topo
img_src=imread('image/boost.png'); %读取图片1
imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
setappdata(handles.match,'Freq','400k');
setappdata(handles.match,'RL','3300');
setappdata(handles.match,'Req','330k');

% --- Outputs from this function are returned to the command line.
function varargout = match_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function freq_Callback(hObject, eventdata, handles)
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'Freq');
    set(hObject,'String',str);
else
    setappdata(handles.match,'Freq',str);
end



% --- Executes during object creation, after setting all properties.
function freq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function res_load_Callback(hObject, eventdata, handles)
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'RL');
    set(hObject,'String',str);
else
    setappdata(handles.match,'RL',str);
end

% --- Executes during object creation, after setting all properties.
function res_load_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function res_equ_Callback(hObject, eventdata, handles)
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'Req');
    set(hObject,'String',str);
else
    setappdata(handles.match,'Req',str);
end

% --- Executes during object creation, after setting all properties.
function res_equ_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ind1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ind1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cap1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function cap1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
val = get(handles.pop1,'Value');
switch val
    case 1
        boost(handles);
    case 2
        buck(handles);
    case 3
        T_xing(handles);
    case 4
        Pi_xing(handles);
end

function value = str2value(str)
strformat = '%f%c';
[num,k] = sscanf(str,strformat);
if k == 1
    value = num;
else
    switch num(2)
        case {107,75} % k K
            value = num(1)*1e3;
        case 77 % M
            value = num(1)*1e6;
        otherwise 
            value = num(1);
    end         
end


function Hvol_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Hvol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop1.
function pop1_Callback(hObject, eventdata, handles)
val = get(hObject,'Value');
axes(handles.circuit);%用axes命令设定当前操作的坐标轴是axes_topo
switch val
    case 1
        img_src=imread('image/boost.png'); %读取图片1
        imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
    case 2;
        img_src=imread('image/buck.png'); %读取图片1
        imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
    case 3
        img_src=imread('image/T_xing.png'); %读取图片3
        imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
    case 4
        img_src=imread('image/Pi_xing.png'); %读取图片3
        imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
    otherwise
        img_src=imread('image/boost.png'); %读取图片1
        imshow(double(img_src)./255);%用imread读入图片，并用imshow在axes_topo上显示
end

% --- Executes during object creation, after setting all properties.
function pop1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function boost(handles)
freq = str2value(get(handles.freq,'String'));
RL = str2value(get(handles.res_load,'String'));
Req = str2value(get(handles.res_equ,'String'));
if Req <= RL
    w = 2*pi*freq;
    L1 = Req*sqrt(RL/Req-1)/w;
    C1 = sqrt(RL/Req-1)/(w*RL);
    Hv = sqrt(RL/Req);
else
    L1 = 0;
    C1 = 0;
    Hv = 1;
end
set(handles.ind1,'String',num2str(L1*1e3));
set(handles.cap1,'String',num2str(C1*1e12));
set(handles.Hvol,'String',num2str(Hv));

w_start = floor(log10(freq)/2);
w_end = ceil(log10(freq))+2;
f = logspace(w_start,w_end,200);
wc = 2*pi.*f;
H = RL./(RL+1j*L1.*wc-wc.^2.*RL.*L1.*C1);
axes(handles.ampf);
semilogx(f,20.*log10(abs(H)),'Linewidth',2,'Color','b');
grid on;
xlabel('f/Hz');
ylabel('20*lg|Hv|/dB');
axes(handles.phf);
semilogx(f,angle(H).*180./pi,'Linewidth',2,'Color','r');
grid on;
xlabel('f/Hz');
ylabel('φ_{L}');


function buck(handles)
freq = str2value(get(handles.freq,'String'));
RL = str2value(get(handles.res_load,'String'));
Req = str2value(get(handles.res_equ,'String'));
if Req >= RL
w = 2*pi*freq;
L1 = RL*sqrt(Req/RL-1)/w;
C1 = L1/(Req*RL);
Hv = sqrt(RL/Req);
set(handles.res_equ,'String',num2str(L1/(RL*C1)));
else
L1 = 0;
C1 = 0;
Hv = 1;
end
set(handles.ind1,'String',num2str(L1*1e3));
set(handles.cap1,'String',num2str(C1*1e12));
set(handles.Hvol,'String',num2str(Hv));

w_start = floor(log10(freq)/2);
w_end = ceil(log10(freq))+2;
f = logspace(w_start,w_end,200);
wc = 2*pi.*f;
H = RL./(1j.*wc.*L1+RL);
axes(handles.ampf);
semilogx(f,20.*log10(abs(H)),'Linewidth',2,'Color','b');
grid on;
xlabel('f/Hz');
ylabel('20*lg|Hv|/dB');
axes(handles.phf);
semilogx(f,angle(H).*180./pi,'Linewidth',2,'Color','r');
grid on;
xlabel('f/Hz');
ylabel('φ_{L}');

function T_xing(handles)
freq = str2value(get(handles.freq,'String'));
RL = str2value(get(handles.res_load,'String'));
Req = str2value(get(handles.res_equ,'String'));
w = 2*pi*freq;
L1 = sqrt(RL*Req)/w;
C1 = 1/(sqrt(RL*Req)*w);
Hv = sqrt(RL/Req);
set(handles.ind1,'String',num2str(L1*1e3));
set(handles.cap1,'String',num2str(C1*1e12));
set(handles.Hvol,'String',num2str(Hv));

w_start = floor(log10(freq)/2);
w_end = ceil(log10(freq))+2;
f = logspace(w_start,w_end,200);
wc = 2*pi.*f;
H = RL./(-1j.*wc.^3.*L1.^2*C1-wc.^2.*RL.*C1.*L1+2j.*wc.*L1+RL);
axes(handles.ampf);
semilogx(f,20.*log10(abs(H)),'Linewidth',2,'Color','b');
grid on;
xlabel('f/Hz');
ylabel('20*lg|Hv|/dB');
axes(handles.phf);
semilogx(f,angle(H).*180./pi,'Linewidth',2,'Color','r');
grid on;
xlabel('f/Hz');
ylabel('φ_{L}');

function Pi_xing(handles)
freq = str2value(get(handles.freq,'String'));
RL = str2value(get(handles.res_load,'String'));
Req = str2value(get(handles.res_equ,'String'));
w = 2*pi*freq;
L1 = sqrt(RL*Req)/w;
C1 = 1/(sqrt(RL*Req)*w);
Hv = sqrt(RL/Req);
set(handles.ind1,'String',num2str(L1*1e3));
set(handles.cap1,'String',num2str(C1*1e12));
set(handles.Hvol,'String',num2str(Hv));

w_start = floor(log10(freq)/2);
w_end = ceil(log10(freq))+2;
f = logspace(w_start,w_end,200);
wc = 2*pi.*f;
H = RL./(RL+1j*L1.*wc-wc.^2.*RL.*L1.*C1);
axes(handles.ampf);
semilogx(f,20.*log10(abs(H)),'Linewidth',2,'Color','b');
grid on;
xlabel('f/Hz');
ylabel('20*lg|Hv|/dB');
axes(handles.phf);
semilogx(f,angle(H).*180./pi,'Linewidth',2,'Color','r');
grid on;
xlabel('f/Hz');
ylabel('φ_{L}');