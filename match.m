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
setappdata(handles.match,'Ind','10m');
setappdata(handles.match,'Cap','12u');
setappdata(handles.match,'Hvg','10');

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
set(handles.note1,'String','');
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
set(handles.note1,'String','');
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'Ind');
    set(hObject,'String',str);
else
    setappdata(handles.match,'Ind',str);
end


% --- Executes during object creation, after setting all properties.
function ind1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cap1_Callback(hObject, eventdata, handles)
set(handles.note1,'String','');
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'Cap');
    set(hObject,'String',str);
else
    setappdata(handles.match,'Cap',str);
end

% --- Executes during object creation, after setting all properties.
function cap1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Hvol_Callback(hObject, eventdata, handles)
set(handles.note0,'String','');
str = get(hObject,'String');
value = str2value(str);
if value < 0 % 判断输入是否有效 无效输入
    str = getappdata(handles.match,'Hvg');
    set(hObject,'String',str);
else
    setappdata(handles.match,'Hvg',str);
end

% --- Executes during object creation, after setting all properties.
function Hvol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
set(handles.note1,'String','');
val = get(handles.pop1,'Value');
switch val
    case 1
        boost(handles,1);
    case 2
        buck(handles,1);
    case 3
        T_xing(handles,1);
    case 4
        Pi_xing(handles,1);
end

function value = str2value(str)
unit_map = containers.Map({'M','k','K','m','u','n','p'},...
    {1e6,1e3,1e3,1e-3,1e-6,1e-9,1e-12});
strformat = '%f%c';
[num,k] = sscanf(str,strformat);
if k == 1
    value = num;
else
    if isKey(unit_map,char(num(2)))
        value = num(1) * unit_map(char(num(2)));
    else 
        value = num(1);
    end
end

function unitstr = value2str(value)
unitpnum = [1e6,1e3,1,1e-3,1e-6,1e-9,1e-12];
unitpstr = ['M','k',' ','m','u','n','p'];
unitstr = '0';
for i = 1:length(unitpnum)
    if value >= unitpnum(i)
        unitstr = strcat(num2str(value/unitpnum(i)),unitpstr(i));
        break;
    end
end


% --- Executes on selection change in pop1.
function pop1_Callback(hObject, eventdata, handles)
set(handles.note0,'String','');
set(handles.note1,'String','');
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

function boost(handles,flag)
if flag == 1
    freq = str2value(get(handles.freq,'String'));
    Hv = str2value(get(handles.Hvol,'String'));
    Req = str2value(get(handles.res_equ,'String'));
    RL = Req*Hv^2;
    if Hv > 1
        w = 2*pi*freq;
        L1 = Req*sqrt(RL/Req-1)/w;
        C1 = sqrt(RL/Req-1)/(w*RL);
    else
        set(handles.note0,'String','Hv应大于1');
        L1 = 0;
        C1 = 0;
    end
    set(handles.ind1,'String',value2str(L1));
    set(handles.cap1,'String',value2str(C1));
    set(handles.res_load,'String',value2str(RL));
else 
    L1 = str2value(get(handles.ind1,'String'));
    C1 = str2value(get(handles.cap1,'String'));
    RL = str2value(get(handles.res_load,'String'));
    if (C1*RL^2)/L1 > 1
        w = sqrt((C1*RL^2)/L1-1)/(RL*C1);
        freq = w/(2*pi);
        Hv = sqrt((w*RL*C1)^2+1);
        Req = RL/((w*RL*C1)^2+1);
    else 
        set(handles.note1,'String','参数错误!');
        freq = 0;
        Hv = 1;
        Req =0;
    end
    set(handles.freq,'String',value2str(freq));
    set(handles.Hvol,'String',num2str(Hv));
    set(handles.res_equ,'String',value2str(Req));
end

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


function buck(handles,flag)
if flag == 1
    freq = str2value(get(handles.freq,'String'));
    Hv = str2value(get(handles.Hvol,'String'));
    Req = str2value(get(handles.res_equ,'String'));
    RL = Req*Hv^2;
    if Hv < 1
        w = 2*pi*freq;
        L1 = RL*sqrt(Req/RL-1)/w;
        C1 = L1/(Req*RL);
    else
        set(handles.note0,'String','Hv应小于1');
        L1 = 0;
        C1 = 0;
    end
    set(handles.ind1,'String',value2str(L1));
    set(handles.cap1,'String',value2str(C1));
    set(handles.res_load,'String',value2str(RL));
else
    L1 = str2value(get(handles.ind1,'String'));
    C1 = str2value(get(handles.cap1,'String'));
    RL = str2value(get(handles.res_load,'String'));
    if (1/(L1*C1)-(RL/L1)^2) > 0
        w = sqrt(1/(L1*C1)-(RL/L1)^2);
        freq = w/(2*pi);
        Hv = RL*sqrt(C1/L1);
        Req = L1/(RL*C1);
    else
        set(handles.note1,'String','参数错误!');
        freq = 0;
        Hv = 1;
        Req =0;
    end
    set(handles.freq,'String',value2str(freq));
    set(handles.Hvol,'String',num2str(Hv));
    set(handles.res_equ,'String',value2str(Req));
end

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

function T_xing(handles,flag)
if flag == 1
    freq = str2value(get(handles.freq,'String'));
    Hv = str2value(get(handles.Hvol,'String'));
    Req = str2value(get(handles.res_equ,'String'));
    RL = Req*Hv^2;
    w = 2*pi*freq;
    L1 = sqrt(RL*Req)/w;
    C1 = 1/(sqrt(RL*Req)*w);
    set(handles.ind1,'String',value2str(L1));
    set(handles.cap1,'String',value2str(C1));
    set(handles.res_load,'String',value2str(RL));
else
    L1 = str2value(get(handles.ind1,'String'));
    C1 = str2value(get(handles.cap1,'String'));
    RL = str2value(get(handles.res_load,'String'));
    
    w = sqrt(1/(L1*C1));
    freq = w/(2*pi);
    Hv = RL*sqrt(C1/L1);
    Req = L1/(RL*C1);

    set(handles.freq,'String',value2str(freq));
    set(handles.Hvol,'String',num2str(Hv));
    set(handles.res_equ,'String',value2str(Req));
end
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

function Pi_xing(handles,flag)
if flag == 1
    freq = str2value(get(handles.freq,'String'));
    Hv = str2value(get(handles.Hvol,'String'));
    Req = str2value(get(handles.res_equ,'String'));
    RL = Req*Hv^2;
    w = 2*pi*freq;
    L1 = sqrt(RL*Req)/w;
    C1 = 1/(sqrt(RL*Req)*w);
    set(handles.ind1,'String',value2str(L1));
    set(handles.cap1,'String',value2str(C1));
    set(handles.res_load,'String',value2str(RL));
else
    L1 = str2value(get(handles.ind1,'String'));
    C1 = str2value(get(handles.cap1,'String'));
    RL = str2value(get(handles.res_load,'String'));
    
    w = sqrt(1/(L1*C1));
    freq = w/(2*pi);
    Hv = RL*sqrt(C1/L1);
    Req = L1/(RL*C1);

    set(handles.freq,'String',value2str(freq));
    set(handles.Hvol,'String',num2str(Hv));
    set(handles.res_equ,'String',value2str(Req));
end

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


% --- Executes on button press in resolve.
function resolve_Callback(hObject, eventdata, handles)
set(handles.note0,'String','');
val = get(handles.pop1,'Value');
switch val
    case 1
        boost(handles,2);
    case 2
        buck(handles,2);
    case 3
        T_xing(handles,2);
    case 4
        Pi_xing(handles,2);
end


% --- Executes on button press in quit.
function quit_Callback(hObject, eventdata, handles)
close(handles.match);
