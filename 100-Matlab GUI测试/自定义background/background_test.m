
%{
ActiveX控件
https://wenku.baidu.com/view/3dd3106427d3240c8447efad.html
https://www.mathworks.com/matlabcentral/fileexchange/4441-activex-control-for-windows-media-player
%}


function varargout = background_test(varargin)
% BACKGROUND_TEST MATLAB code for background_test.fig
%      BACKGROUND_TEST, by itself, creates a new BACKGROUND_TEST or raises the existing
%      singleton*.
%
%      H = BACKGROUND_TEST returns the handle to a new BACKGROUND_TEST or the handle to
%      the existing singleton*.
%
%      BACKGROUND_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACKGROUND_TEST.M with the given input arguments.
%
%      BACKGROUND_TEST('Property','Value',...) creates a new BACKGROUND_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before background_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to background_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help background_test

% Last Modified by GUIDE v2.5 15-May-2019 01:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @background_test_OpeningFcn, ...
                   'gui_OutputFcn',  @background_test_OutputFcn, ...
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


% --- Executes just before background_test is made visible.
function background_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to background_test (see VARARGIN)

% Choose default command line output for background_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes background_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global t
t = 0;


%% 配置按钮背景图片
II = imread('2.jpg');
set(handles.pushbutton1,'CData',II);

set(handles.togglebutton1,'CData',II);

set(handles.text,'CData',II);

set(handles.pushbutton1,'CData',II);

I = imread('background.jpg');

set(handles.edit1,'cdata',I);

set(handles.checkbox1,'CData',I);

set(handles.radiobutton1,'CData',I);


%% 给axes添加背景图片
global  text3
II = imread('2.jpg');
image(handles.axes3,II)
% 文字上添加文字，设定字体
text3 = text(handles.axes3,'string', '文字', 'position', [100 100], 'Horizontal', 'left','FontName', '华文楷体', 'FontSize', 25, 'FontWeight', 'bold','color',[1 1 1]);
set(handles.axes3 ,'handlevisibility','off','visible','off');

%% figure2

II = imread('2.jpg');
image(handles.axes4,II)
% colormap gray
strCell = {'独上江楼思渺然，', '月光如水水如天。', '同来望月人何在？', '风景依稀似去年。'};

for i = 1 : numel(strCell)      %穷举每条诗句
	strTemp = strCell{i};       %获取第i条诗句
	str = [strTemp; 10*ones(1, length(strTemp))];	%诗句的每个字后添加一个换行符
	str = str(:)';	%获取添加了换行符的诗句字符串
	text(handles.axes4,'string', str, 'position', [500-100*i 200], 'Horizontal', 'right','FontName', '华文楷体', 'FontSize', 6, 'FontWeight', 'bold','color',[1 1 1]);
end

set(handles.axes4 ,'handlevisibility','off','visible','off');


% methodsview(handles.activex1) 

% handles.activex1.openPlayer('E:\1.mp4')
% handles.activex1.close
% handles.activex1.get
% set(handles.activex1,'enabled',0);
% set(handles.activex1,'windowlessVideo',0);
% --- Outputs from this function are returned to the command line.
function varargout = background_test_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('background.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global t text3
% t = t+1;
% % text3
% % plot(handles.axes3,[1 2],[1 2])
% text3.String = num2str(t);
% handles.activex1.URL = 'E:\1.mp4';
% 
% for i = 3:1000
% text3.String = num2str(i);
% end
playVideo('H:\4-mymovies\own\外骨骼渲染.mp4')
% close(figure())                              % close删除的是figure句柄对象



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
% handles.activex1.close

global t text3
t = t+1;
% text3
% plot(handles.axes3,[1 2],[1 2])
text3.String = num2str(t);



% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% ha=axes('units','normalized','position',[0 0 1 1]);
% uistack(ha,'down')
% II=imread('background.jpg');
% image(II)
% colormap gray
% set(ha,'handlevisibility','off','visible','on');


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

II = imread('2.jpg');
image(II)
% colormap gray
set(hObject ,'handlevisibility','on','visible','on');


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function uipanel2_SizeChangedFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function activex1_OpenStateChange(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
% s = 'activex1_OpenStateChange'
% hObject

% --------------------------------------------------------------------
function activex1_PlayStateChange(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
% s = 'activex1_PlayStateChange'
% whos hObject
% currentPosition = hObject.control.currentPosition


% --------------------------------------------------------------------
function activex1_PositionChange(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
% currentPosition = hObject.control.currentPosition


% --------------------------------------------------------------------
function activex1_EndOfStream(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.close

% --------------------------------------------------------------------
function activex1_SwitchedToControl(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
