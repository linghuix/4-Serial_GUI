function varargout = serial_GUI(varargin)
global AAA sum_col
% AAA=[
%   776（|干扰） 770(误差10%) 1120 1227 1252 1252 960 800;
%   740 930 1126 1234 1250 1256 965 800;
%   790 920（干扰大） 1200 950 1250 1250 960 790;
%   780 944 930 1226 1250 1250 960 795;
%   715 944 1150 1111 1180 850 890 730;
%   715 870 1145 1157 850 1183 850 727;
%   725 870 1147 1160 1185 1100 890 650;
%   715 870 1145 1160 1185 1185 780 730];

load('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\AAA.mat');
load('D:\1-embed\4-Serial_GUI\2-ARM小体积\static\data\sum_col.mat');
AAA
sum_col
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serial_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @serial_GUI_OutputFcn, ...
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



% --- Executes just before serial_GUI is made visible.
function serial_GUI_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to serial_GUI (see VARARGIN)

    clc
    clear COM rate Stopbit Databit terminator command maxNum J K pause h t h2 
    tic
    % COM串口号，rate 波特率 Stopbit停止位，Databit数据位    
    % command采样命令，savename保存文件名    
    % J、K 传感器序号    
    global COM rate Stopbit Databit terminator command
    global maxNum J K
    global pause showfigure flag_tell flag_data
    
    % 默认值初始化
    pause = 1;
    COM = 'COM3';
    rate = 115200;
    Stopbit = 1;
    Databit = 8;
    terminator = 'LF';
    command = 'start';
    maxNum = 2000;
    J = 1;K = 1;
    showfigure = 0;
    flag_tell = 0;
    flag_data = 0;


    
    % 初始化成功！    
    set(handles.popCOM,'value',3);
    set(handles.popRate,'value',4);
    set(handles.popStopbit,'value',1);
    set(handles.popDatabit,'value',4);
    set(handles.terminator,'value',2);
    set(handles.maxNum,'value',2);

    fprintf('*****************************************\n');
    fprintf('欢迎使用ARM Serial_GUI！\n');
    fprintf('Author—Linghui Xu\n');
    fprintf('Product Time—2019.04.02\n');
    fprintf('*****************************************\n');

    %初始化界面
    %设置方法为，string数组中的下标，从1开始
    set(handles.HighLevel,'value',1);
    % set(handles.interrupt,'visible','off');
    % set(handles.text9,'visible','off');
    % set(handles.text10,'visible','off');
    % set(handles.terminator,'visible','off');
    % set(handles.StartCollect,'visible','off');
    % set(handles.bytes,'visible','off');
    % set(handles.text16,'visible','off');
    % set(handles.bytesint,'visible','off');
    set(handles.startdata,'visible','off');
    set(handles.enddata,'visible','off');


    set(handles.enddata,'visible','off');
    set(handles.reStart,'visible','off');

    set(handles.ShowCurve,'value',1);
    set(handles.ShowFiliteredCurve,'value',1);

    % set(handles.figure,'ytick',0:100:1024,'xtick',0:100:1500);
    % set(handles.figure, 'XTick', 0:10:1500); 
    % set(handles.figure, 'XTickLabel' ,{'a','b','c'}) ; %将上面的三个刻度值改为a,b,c    
    set(handles.st, 'String', '初始化成功！,默认选择传感器块(1,1)')

    % Choose default command line output for serial_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes serial_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    


function varargout = serial_GUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to Sendtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sendtext as text
%        str2double(get(hObject,'String')) returns contents of Sendtext as a double


% --- Executes during object creation, after setting all properties.
function Sendtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sendtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenSerial.
function OpenSerial_Callback(~, ~,handles)
    % hObject    handle to OpenSerial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    set(handles.st, 'String', '打开串口，删除旧的存储数据')
    
    %%如果matlab已经打开了串口，关闭它，防止占用
    if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
         fprintf('关闭matlab已经打开了串口 %s \n',instrfind);
    end

    global COM rate Stopbit terminator 
    global s x x1 y1 wcold maxNum
    global wc Ts data after bbb wcmin h h2     %t定时器
    
    data = [];
    after = [];

    % h2 是删除的句柄，虽然删除了句柄，但是指向的对象的变量还是存在的
    % 因此，需要用isvalid判断，是否是有效的句柄    
    if (isempty(h2))
        h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
        h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
        fprintf('create h and h2 \n');
    elseif (~isvalid(h2))
        h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
        h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
        fprintf('create h and h2 \n');
    else
        clearpoints(h);
        clearpoints(h2);
        fprintf('clearpoints \n');
    end

    %axis(handles.figure,[0 1500 0 1024]);

    %傅里叶变换，间隔tt
    tt = 10;
    % 数字滤波器缓存区
    x  = [];
    x1 = zeros(8,8);    %滞后
    y1 = zeros(8,8);    %滞后

    % 数字滤波器的参数，wc为截止频率，wcmin为初始化截止频率。Ts为采样周期    
    wcold = 5*2*pi;
    wc = 4;wcmin = wc;
    Ts = 1/50;

    % 传感器数据存储区
    data = [];
    % 滤波后的数据
    after = [];

    bbb=[];

    s = serial(COM);         %定义串口对象
    set(s,'BaudRate',rate);  %设置波特率    
    s.parity = 'none';       %设置校验位无奇偶校验，默认none
    s.stopbits = Stopbit;    %设置停止位，默认1
    s.Terminator = terminator;
    s.inputbuffersize = 1024;  %设置输入缓冲区，缺省值为512b 
    
    % 设置中断响应模式（有“byte”和“Terminator”两种模式可选，“byte”是达到设定的字节数产生中断，“Terminator”可用作键盘某个按键事件来产生中断）
    s.BytesAvailableFcnMode = 'byte';
    s.BytesAvailableFcnCount = 128;
    s.BytesAvailableFcn =  {@ReceiveCallback,handles};
    
    fopen(s);                  %打开串口对象s
    fprintf('打开串口: %s \n',s.Port);
    
    % ASCII码形式发送
    fwrite(s,'start','char');
 
        

function ReceiveCallback( ~, ~,handles)

    global x  flag_tell flag_data
    global J K
    global pause
     
    global s AAA sum_col
    global x1 y1 wc Ts data after  wcmin h h2

    recivedata = fread (s,128)';
    high = recivedata(2:2:128);                         %取高位 
    low = recivedata(1:2:128);                                                                    %取底位
%     x = (high*256+low)*3.3/4095;
    x = (high*256+low);
    %由于实际的ADC采样的电压值比较小，所以并没有化为单位伏特
    x = reshape(x,8,8)';
    data = cat(3,data,x);
    %data(1,1,:);

    % 滤波器核心代码，y滤波后的数据 %
    y = (wc*(x+x1)-(wc-2/Ts)*y1)/(2/Ts+wc);
    after = cat(3,after,y);                                                                         % 滤波输出

%             speed = abs(y(1,1)-x(1,1));
%             speed = abs(x1(1,1)-x(1,1));
    speed = abs(y-x);                                                                              % 修改为采样值与滤波后得到的前一刻的差值
%             speed = abs(x1-x);
    speedmax = max(max(speed));                                                                      % 速度最大240左右,情况pi*beta/22,wcmin =4; 截止频率变化范围 5-15Hz
    pi_2_beta = 0.05;

    wc = wcmin+speedmax*pi_2_beta;                                                                % 更新滤波截止频率
    y1 = y; x1 = x; 
    x = [];

%           % 图像显示
    length_data = size(data(J,K,:),3);
    
    if(pause)
        addpoints(h, length_data,[data(J,K,end)]);
        addpoints(h2,length_data,[after(J,K,end)]);
        drawnow limitrate
    end
    
    % 打印数据
    if(flag_data && mod(length_data,10) == 0)
        set(handles.st, 'String', num2str(data(J,K,end)));
    end
    
    
    %% gait analysis
    if ((mod(length_data,100) == 0) && flag_tell)
        
        Avr = 20;
        SUM = 0;
        
        for j = 0:(Avr-1)
            SUM = SUM + after(:,:,end-j)-AAA;
        end
        avr = SUM/Avr;
        sample = reshape(avr,1,64);
        
        sample = sample/sum(sample);
%         for j = 1:Avr
%            sample(j) =  sample(j)*100.0./sum_col(j);
%         end
        
        result = Model_py(sample)                 % 返回字符结果
        set(handles.st, 'String', result);
    end
   
    
% --- Executes on selection change in popCOM.
function popCOM_Callback(hObject, ~, ~)
    % hObject    handle to popCOM (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popCOM contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popCOM
    global COM;
    val=get(hObject,'value');
    switch val
        case 1
            COM='COM1';
            set(handles.st, 'String', '成功设置串口COM1')
        case 2
            COM='COM2';
            set(handles.st, 'String', '成功设置串口COM2')
        case 3
            COM='COM3';
            set(handles.st, 'String', '成功设置串口COM3')
        case 4
            COM='COM4';
            set(handles.st, 'String', '成功设置串口COM4')
        case 5
            COM='COM5';
            set(handles.st, 'String', '成功设置串口COM5')
        case 6
            COM='COM6';
            set(handles.st, 'String', '成功设置串口COM6')
        case 7
            COM='COM7';
            set(handles.st, 'String', '成功设置串口COM7')
        case 8
            COM='COM8';
            set(handles.st, 'String', '成功设置串口COM8')
        case 9
            COM='COM9';
            set(handles.st, 'String', '成功设置串口COM9')
    end

    %fprintf('成功设置串口号为 = %s\n',COM);


% --- Executes during object creation, after setting all properties.
function popCOM_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popCOM (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on selection change in popRate.
function popRate_Callback(hObject, eventdata, handles)
    % hObject    handle to popRate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popRate contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popRate
    global rate;
    val=get(hObject,'value');

    switch val
        case 1
            rate=9600;
            set(handles.st, 'String', '成功设置波特率为9600')
        case 2
            rate=19200;
            set(handles.st, 'String', '成功设置波特率为19200')
        case 3
            rate=38400;
            set(handles.st, 'String', '成功设置波特率为38400')
        case 4
            rate=115200;
            set(handles.st, 'String', '成功设置波特率为115200')
    end %此处的end是switch
    %fprintf('成功设置波特率为 %d \n',rate);


% --- Executes during object creation, after setting all properties.
function popRate_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popRate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in ShowCurve.
function ShowCurve_Callback(hObject, eventdata, handles)
    % hObject    handle to ShowCurve (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of ShowCurve

    global h
    
    val = get(hObject,'value');
    if (val)
        fprintf('绘制原始数据曲线')
%         set(h, 'Color',[1 0 0]);
        set(h,'visible','on')
    else
        fprintf('关闭绘制原始数据曲线')
%         set(h, 'Color',[1 1 1],'LineWidth',0); 
        set(h,'visible','off')
    end


% --- Executes on button press in ShowFiliteredCurve.
function ShowFiliteredCurve_Callback(hObject, eventdata, handles)
    % hObject    handle to ShowFiliteredCurve (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of ShowFiliteredCurve
    
    global h2
    
    val = get(hObject,'Value');
    
    if (val)
        fprintf('绘制Filitered数据曲线')
%         set(h2, 'Color',[0 0 0]);
        set(h2,'visible','on')
    else
        fprintf('关闭绘制Filitered数据曲线')
%         set(h2, 'Color',[1 1 1],'LineWidth',0,'LineStyle', '.','MarkerSize',0.5);
        set(h2,'visible','off')
    end

% --- Executes on button press in CloseSerial.
function CloseSerial_Callback(~, ~, handles)
    % hObject    handle to CloseSerial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global s COM
    
    fwrite(s,'close','char');
    
    fclose(s);
    delete(s);


    % clearpoints(h);
    % clearpoints(h2);
    % data = [];
    % after = [];
    
    set(handles.st, 'String', 'Close COM，数据还是保存着哦')
    fprintf('Close %s \n',COM);




function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit3 as text
    %        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in maxNum.
function maxNum_Callback(hObject, eventdata, handles)
    % hObject    handle to maxNum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns maxNum contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from maxNum

    global maxNum h h2
    val = get(hObject,'value');
    switch val
        case 1
            maxNum = 1000;
        case 2
            maxNum = 2000;
        case 3
            maxNum = 3000;
        case 4
            maxNum = 4000;
        case 5
            maxNum = 5000;
    end

    if (~isempty(h2))
        set(h,'MaximumNumPoints',maxNum);
        set(h2,'MaximumNumPoints',maxNum);
    %     fprintf('成功 %d \n',maxNum);
    end

    set(handles.st, 'String','成功设置最大接收数据')
    fprintf('成功设置接收数据%d \n',maxNum);



% --- Executes during object creation, after setting all properties.
function maxNum_CreateFcn(hObject, ~, handles)
    % hObject    handle to maxNum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in popStopbit.
function popStopbit_Callback(hObject, eventdata, handles)
    % hObject    handle to popStopbit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popStopbit contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popStopbit


% --- Executes during object creation, after setting all properties.
function popStopbit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popStopbit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in popDatabit.
function popDatabit_Callback(hObject, eventdata, handles)
    % hObject    handle to popDatabit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns popDatabit contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popDatabit


% --- Executes during object creation, after setting all properties.
function popDatabit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popDatabit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in terminator.
function terminator_Callback(hObject, eventdata, handles)
    % hObject    handle to terminator (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns terminator contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from terminator


% --- Executes during object creation, after setting all properties.
function terminator_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to terminator (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in StartCollect.
function StartCollect_Callback(hObject, eventdata, handles)
% hObject    handle to StartCollect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StartCollect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StartCollect


% --- Executes during object creation, after setting all properties.
function StartCollect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartCollect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enddata_Callback(hObject, eventdata, handles)
% hObject    handle to enddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enddata as text
%        str2double(get(hObject,'String')) returns contents of enddata as a double


% --- Executes during object creation, after setting all properties.
function enddata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startdata_Callback(hObject, eventdata, handles)
% hObject    handle to startdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startdata as text
%        str2double(get(hObject,'String')) returns contents of startdata as a double


% --- Executes during object creation, after setting all properties.
function startdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in SaveData.
function SaveData_Callback(~, ~, handles)
    % hObject    handle to SaveData (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    cd 'D:\1-embed\4-Serial_GUI\fig_arm\Small_50Hz_fig'
    
    global savename h 
    global data after 
    
    time = toc;
    [x,y] = getpoints(h);
    save( strcat([savename '_' datestr(now,30)],'.mat'),'data','after','y');
    set(handles.st,'String','保存成功＿');
    cd 'D:\1-embed\4-Serial_GUI\2-ARM小体积\static\展示'



function SaveName_Callback(hObject, eventdata, handles)
    % hObject    handle to SaveName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of SaveName as text
    %        str2double(get(hObject,'String')) returns contents of SaveName as a double

    global savename
    savename = get(hObject,'String')
    set(handles.st,'String','名称成功更改');

% --- Executes during object creation, after setting all properties.
function SaveName_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to SaveName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in filiter.
function filiter_Callback(hObject, eventdata, handles)
% hObject    handle to filiter (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of filiter

    val = get(hObject,'value');
        if (val)
            fprintf('开启滤波')
        else
            fprintf('关闭滤波')
        end
    

function Freq_Callback(hObject, eventdata, handles)
    % hObject    handle to Freq (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of Freq as text
    %        str2double(get(hObject,'String')) returns contents of Freq as a double


% --- Executes during object creation, after setting all properties.
function Freq_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Freq (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in DataType.
function DataType_Callback(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DataType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataType


% --- Executes during object creation, after setting all properties.
function DataType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ts_Callback(hObject, eventdata, handles)
% hObject    handle to Ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ts as text
%        str2double(get(hObject,'String')) returns contents of Ts as a double


% --- Executes during object creation, after setting all properties.
function Ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bytesint.
function bytesint_Callback(hObject, eventdata, handles)
% hObject    handle to bytesint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bytesint



function bytes_Callback(hObject, eventdata, handles)
% hObject    handle to bytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bytes as text
%        str2double(get(hObject,'String')) returns contents of bytes as a double


% --- Executes during object creation, after setting all properties.
function bytes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bytes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in HighLevel.
function HighLevel_Callback(hObject, eventdata, handles)
    % hObject    handle to HighLevel (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of HighLevel

    % 按下去是1，不按时0
    val = get(hObject,'value');
    if (val)
        
        set(handles.interrupt,'visible','on');
        set(handles.text9,'visible','on');
        set(handles.text10,'visible','on');
        set(handles.terminator,'visible','on');
        set(handles.StartCollect,'visible','on');
        set(handles.bytes,'visible','on');
        set(handles.text16,'visible','on');
        set(handles.bytesint,'visible','on');
    else
        set(handles.interrupt,'visible','off');
        set(handles.text9,'visible','off');
        set(handles.text10,'visible','off');
        set(handles.terminator,'visible','off');
        set(handles.StartCollect,'visible','off');
        set(handles.bytes,'visible','off');
        set(handles.text16,'visible','off');
        set(handles.bytesint,'visible','off');
    end
    


% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate figure
% ha=axes('units','normalized','position',[0 0 1 1]);
% uistack(ha,'down')
% II=imread('bb.jpg');
% image(II)
% colormap gray
% set(ha,'handlevisibility','off','visible','off');



% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton9

    val = get(hObject,'value');
    if (val)
        fprintf('接收数据')
    else
        fprintf('不接收数捠')
    end



function J_Callback(hObject, eventdata, handles)
    % hObject    handle to J (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of J as text
    %        str2double(get(hObject,'String')) returns contents of J as a double
    global J
    J = str2num(get(hObject,'String'))

% --- Executes during object creation, after setting all properties.
function J_CreateFcn(hObject, eventdata, handles)
% hObject    handle to J (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function K_Callback(hObject, eventdata, handles)
    % hObject    handle to K (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of K as text
    %        str2double(get(hObject,'String')) returns contents of K as a double
    
    global K
    
    K = str2num(get(hObject,'String'))

% --- Executes during object creation, after setting all properties.
function K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pause.
function pause_Callback(hObject, ~, handles)
    % hObject    handle to pause (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global pause

    set(handles.reStart,'visible','on');
    set(hObject,'visible','off');
    pause = 0;
    set(handles.st,'String','停止绘图,后台还在采集数据哦');
    

% --- Executes on button press in reStart.
function reStart_Callback(hObject, ~, handles)
    % hObject    handle to reStart (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global pause h h2
    
    set(handles.pause,'visible','on');
    set(hObject,'visible','off');
    
    clearpoints(h);
    clearpoints(h2);


    pause = 1;
    set(handles.st,'String','重新开始绘图，数据依旧在采集哦');

% --- Executes on button press in showfigure.
function showfigure_Callback(hObject, eventdata, handles)
% hObject    handle to showfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showfigure

global h2 AAA after

figure(5)

    [x,y] = getpoints(h2);
    loops = size(x,2)
    
    for j = 1:10:loops
        fprintf('frame %d\n',round(j));
        imshow(imresize(after(:,:,j)-AAA,50,'nearest'),[-10 200]); 
        drawnow limitrate         
    end

close figure 5



function showfigure_DeleteFcn(hObject, eventdata, handles)

function st_CreateFcn(hObject, eventdata, handles)

function figure1_CreateFcn(hObject, eventdata, handles)



% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)

    global flag_tell
    val = get(hObject,'Value');
    
    if (val)
        fprintf('开始识别')
        flag_tell = 1;
    else
        fprintf('关闭识别')
        flag_tell = 0;
    end
    
    


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
    global flag_data
    val = get(hObject,'Value');
    
    if (val)
        fprintf('开始识别')
        flag_data = 1;
    else
        fprintf('关闭识别')
        flag_data = 0;
    end
