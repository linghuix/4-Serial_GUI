function varargout = serial_GUI(varargin)


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
    [varargout{1:nargout}] = gu_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function figure_CreateFcn(hObject, ~, handles, varargin)

% --- Executes just before serial_GUI is made visible.
function serial_GUI_OpeningFcn(hObject, ~, handles, varargin)

    cd 'D:\1-embed\4-Serial_GUI\展示用\'
    global COM rate
    global vid
    global II

    % 默认值
    COM = 'COM3';
    rate = 115200;


%%读取过场动画
    vid = VideoReader('1.mp4');
    vid.CurrentTime = 18;
    
    fprintf('*****************************************\n');
    fprintf('欢迎使用Serial_GUI！\n');
    fprintf('Author——Xu\n');
    fprintf('Time——2019.04.02\n');
    fprintf('*****************************************\n');

    %初始化界面
    %设置方法为，string属性数组中的下标，从1开始
    
    II = imread('pic.jpg');
    image(handles.figure,II)
    handles.figure
    handles.figure.Visible = 'off'
    
%     handles.OpenSerial.Visible = 'off'

    I = imread('start1.jpg');
    set(handles.OpenSerial,'CData',I);

    % Choose default command line output for serial_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    set(handles.figure ,'handlevisibility','off','visible','off');
    
%                         handles.OpenSerial.Visible = 'off';
%                         II = imread('result.jpg');
%                         image(handles.figure,II)
% 
%                         T1 = text(handles.figure,'string','您的步态分类结果为: ' , 'position', [50 100], 'Horizontal', 'left','FontName', '华文楷体', 'FontSize', 50, 'FontWeight', 'bold','color',[0 0 0]);
%                         T2 = text(handles.figure,'string','正常' , 'position', [690 180], 'Horizontal', 'center','FontName', 'Times New Roman.', 'FontSize', 60, 'FontWeight', 'bold','color',[0 0 0]);
%                         set(handles.figure ,'handlevisibility','off','visible','off');

  
function varargout = serial_GUI_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


    
% --- Executes on button press in OpenSerial.
function OpenSerial_Callback(hObject, eventdata,handles)

    handles.OpenSerial.Visible = 'off';
    %%如果matlab已经打开了串口，关闭它，防止占用
    if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
         fprintf('关闭matlab已经打开了串口: %s \n',instrfind);
    end

    global COM rate Stopbit terminator 
    global s x x1 y1 wcold 
    global wc Ts data after bbb wcmin

    data = [];
    after = [];
%%
    % h2 是删除的句柄，虽然删除了句柄，但是指向的对象的变量还是存在的
    % 因此，需要用isvalid判断，是否是有效的句柄
%     if (isempty(h2))
%         h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
%         h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
%         fprintf('create h and h2');
%     elseif (~isvalid(h2))
%         h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
%         h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
%         fprintf('create h and h2');
%     else
%         clearpoints(h);
%         clearpoints(h2);
%         fprintf('clearpoints \n');
%     end
    

% % %     % 过场动画启动
% % % %     hfig = figure('position',[100,0,1500,900]);
% % % %     axes(hfig,'Position',[0,0,1,1]);
%%
    
    % 数字滤波器缓存区
    x  = [];
    x1 = zeros(8,8);    %滞后一阶的
    y1 = zeros(8,8);    %滞后一阶

    % 数字滤波器的参数，wc为截止频率，wcmin为初始化截止频率。Ts为采样周期
    wcold = 5*2*pi;
    wc = 4*2*pi;wcmin = wc;
    Ts = 1/30;

    % 传感器数据存储区
    data = [];
    % 滤波后
    after = [];

    bbb=[];

    s = serial(COM);         %定义串口对象
    set(s,'BaudRate',rate);  %设置波特率
    s.parity = 'none';       %设置校验位无奇偶校验，默认none
    s.stopbits = Stopbit;    %设置停止位，默认1
    s.Terminator = terminator;
    s.inputbuffersize = 512;  %设置输入缓冲区,缺省值为512b 
    
    % 设置中断响应模式（有“byte”和“Terminator”两种模式可选，“byte”是达到一定字节数产生中断，“Terminator”可用作键盘某个按键事件来产生中断）
    s.BytesAvailableFcnMode = 'terminator';
    s.BytesAvailableFcn = {@ReceiveCallback, handles};
    
    
    fopen(s);                  %打开串口对象s
    fprintf('打开串口: %s \n',s.Port);
        

function ReceiveCallback( ~, ~,handles)
    global s
    global x x1 y1 wc Ts data after wcmin vid II

    
    b = fgetl(s);
    b = str2num(b);           %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止。
                                %所以在Arduino程序里要使用Serial.println()
                                %如果不是数字而是汉字，比如“这是6”，将返回[]
    if( isempty(b) )            %检验是否是[]，因为每次scan前，都会输出汉字，参考arduino中程序
        if(size(x,1) == 8)      %经验x是否是8*8的
                %toc;
               currAxes = handles.figure;
%                vid.CurrentTime
               if hasFrame(vid)&& vid.CurrentTime <30 %46
                    drawnow limitrate
                    vidFrame = readFrame(vid);
                    image(vidFrame, 'Parent', currAxes);
                    currAxes.Visible = 'off';

               else 
%                 close(hfig)
%                 cd 'F:\1-embed\4-Serial_GUI\展示用\'
              %% gait analysis  ，第一次测试的时候耗时比较长，第二次之后就会快许多，能够实现实时的曲线变化
                Fs = 30;
                % 多个传感器块串起来
                Row = [1 2 3 4 5 3 4 5 2 6 4 5 7 5 7 8];
                Col = [7 7 7 7 7 6 6 6 5 5 4 4 4 3 3 1];
                merge_R = [8 7 7];
                merge_C = [2 1 2];

                coef = [];  

                    % 多个传感器块串起来
                    for row_col = 1:length(Row) 

                        row = Row(row_col);
                        col = Col(row_col);

                        if row == 8
                            ser = reshape(after(row,col,end-256+1:end),1,256);% 某个传感器的时间序列
                            serial = ser/mean(ser);
                        else
                            ser = reshape(after(row,col,end-256+1:end),1,256);% 某个传感器的时间序列
                            for ii = 1:length(merge_R)
                                ser = ser + reshape(after(merge_R(ii),merge_C(ii),end-256+1:end),1,256);
                            end
                            ser = ser/4;
                            serial = ser/mean(ser);
                        end

                        %%傅里叶系数计算
                        NFFT = 256;                                                 % 频率图的点数
                        A = abs(fft(serial,NFFT));                                  % 频域幅值
                        f = Fs/2*linspace(0, 1, NFFT/2);                            % 采样点数决定了频率分辨力
                        A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;

                        temp = [sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
                        coef = [coef temp];                                         % 多个传感器块串起来
                    end
                    
                    result = Model_py(coef)                 % 返回字符结果
                    
                    II = imread('result.jpg');
                    image(handles.figure,II)

                    T1 = text(handles.figure,'string','您的步态分类结果为: ' , 'position', [50 100], 'Horizontal', 'left','FontName', '华文楷体', 'FontSize', 50, 'FontWeight', 'bold','color',[0 0 0]);
                    T2 = text(handles.figure,'string',result , 'position', [690 180], 'Horizontal', 'center','FontName', 'Times New Roman.', 'FontSize', 60, 'FontWeight', 'bold','color',[1 1 1]);
                    set(handles.figure ,'handlevisibility','off','visible','off');

                    % 关闭串口
                    fclose(s);
                    delete(s);                  

                    input('again?')

               end
  
            data = cat(3,data,x);

            % 滤波器核心代码，y滤波后的数据
            y = (wc*(x+x1)-(wc-2/Ts)*y1)/(2/Ts+wc);
            after = cat(3,after,y);% 滤波输出

            speed1 = x-x1;               % 原本采用的是采样的前后差差值作为速度
            speed2 = abs(x-y);           % 修改为采样值与滤波后得到的前一时刻的差值
            speedmax1 = max(max(speed1)); % 速度最快100左右,一般情况下20，wcmin =2*2*pi; 截止频率变化范围 6-9Hz
            speedmax2 = max(max(speed2));
            speedmax = max(speedmax1,speedmax2);
            beta = 1/25;

            % 更新滤波截止频率
            wc = wcmin+speedmax*beta*2*pi;
            % 更新
            y1 = y;x1 = x;
            x = [];
           
        else
            %%warning1 串口得到的数据并不是8*8的
            disp('warning1');
            x = [];
        end

        
    else
        if size(b,2) == 8
            x = [x;b];          %存储数据
        else
            %  实验中发现，b得到的有可能是残缺的，即不是8个传感器的数据。导致无法试实现[x;b]运算
            %  可能与串口传输底层有关
            % 'warning2 b不是8位的向量
            fprintf('warning2');
        end
    end

