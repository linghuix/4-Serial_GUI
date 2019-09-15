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

    cd 'D:\1-embed\4-Serial_GUI\չʾ��\'
    global COM rate
    global vid
    global II

    % Ĭ��ֵ
    COM = 'COM3';
    rate = 115200;


%%��ȡ��������
    vid = VideoReader('1.mp4');
    vid.CurrentTime = 18;
    
    fprintf('*****************************************\n');
    fprintf('��ӭʹ��Serial_GUI��\n');
    fprintf('Author����Xu\n');
    fprintf('Time����2019.04.02\n');
    fprintf('*****************************************\n');

    %��ʼ������
    %���÷���Ϊ��string���������е��±꣬��1��ʼ
    
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
%                         T1 = text(handles.figure,'string','���Ĳ�̬������Ϊ: ' , 'position', [50 100], 'Horizontal', 'left','FontName', '���Ŀ���', 'FontSize', 50, 'FontWeight', 'bold','color',[0 0 0]);
%                         T2 = text(handles.figure,'string','����' , 'position', [690 180], 'Horizontal', 'center','FontName', 'Times New Roman.', 'FontSize', 60, 'FontWeight', 'bold','color',[0 0 0]);
%                         set(handles.figure ,'handlevisibility','off','visible','off');

  
function varargout = serial_GUI_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


    
% --- Executes on button press in OpenSerial.
function OpenSerial_Callback(hObject, eventdata,handles)

    handles.OpenSerial.Visible = 'off';
    %%���matlab�Ѿ����˴��ڣ��ر�������ֹռ��
    if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
         fprintf('�ر�matlab�Ѿ����˴���: %s \n',instrfind);
    end

    global COM rate Stopbit terminator 
    global s x x1 y1 wcold 
    global wc Ts data after bbb wcmin

    data = [];
    after = [];
%%
    % h2 ��ɾ���ľ������Ȼɾ���˾��������ָ��Ķ���ı������Ǵ��ڵ�
    % ��ˣ���Ҫ��isvalid�жϣ��Ƿ�����Ч�ľ��
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
    

% % %     % ������������
% % % %     hfig = figure('position',[100,0,1500,900]);
% % % %     axes(hfig,'Position',[0,0,1,1]);
%%
    
    % �����˲���������
    x  = [];
    x1 = zeros(8,8);    %�ͺ�һ�׵�
    y1 = zeros(8,8);    %�ͺ�һ��

    % �����˲����Ĳ�����wcΪ��ֹƵ�ʣ�wcminΪ��ʼ����ֹƵ�ʡ�TsΪ��������
    wcold = 5*2*pi;
    wc = 4*2*pi;wcmin = wc;
    Ts = 1/30;

    % ���������ݴ洢��
    data = [];
    % �˲���
    after = [];

    bbb=[];

    s = serial(COM);         %���崮�ڶ���
    set(s,'BaudRate',rate);  %���ò�����
    s.parity = 'none';       %����У��λ����żУ�飬Ĭ��none
    s.stopbits = Stopbit;    %����ֹͣλ��Ĭ��1
    s.Terminator = terminator;
    s.inputbuffersize = 512;  %�������뻺����,ȱʡֵΪ512b 
    
    % �����ж���Ӧģʽ���С�byte���͡�Terminator������ģʽ��ѡ����byte���Ǵﵽһ���ֽ��������жϣ���Terminator������������ĳ�������¼��������жϣ�
    s.BytesAvailableFcnMode = 'terminator';
    s.BytesAvailableFcn = {@ReceiveCallback, handles};
    
    
    fopen(s);                  %�򿪴��ڶ���s
    fprintf('�򿪴���: %s \n',s.Port);
        

function ReceiveCallback( ~, ~,handles)
    global s
    global x x1 y1 wc Ts data after wcmin vid II

    
    b = fgetl(s);
    b = str2num(b);           %�ú���fget(s)�ӻ�������ȡ�������ݣ���������ֹ�������з���ֹͣ��
                                %������Arduino������Ҫʹ��Serial.println()
                                %����������ֶ��Ǻ��֣����硰����6����������[]
    if( isempty(b) )            %�����Ƿ���[]����Ϊÿ��scanǰ������������֣��ο�arduino�г���
        if(size(x,1) == 8)      %����x�Ƿ���8*8��
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
%                 cd 'F:\1-embed\4-Serial_GUI\չʾ��\'
              %% gait analysis  ����һ�β��Ե�ʱ���ʱ�Ƚϳ����ڶ���֮��ͻ����࣬�ܹ�ʵ��ʵʱ�����߱仯
                Fs = 30;
                % ����������鴮����
                Row = [1 2 3 4 5 3 4 5 2 6 4 5 7 5 7 8];
                Col = [7 7 7 7 7 6 6 6 5 5 4 4 4 3 3 1];
                merge_R = [8 7 7];
                merge_C = [2 1 2];

                coef = [];  

                    % ����������鴮����
                    for row_col = 1:length(Row) 

                        row = Row(row_col);
                        col = Col(row_col);

                        if row == 8
                            ser = reshape(after(row,col,end-256+1:end),1,256);% ĳ����������ʱ������
                            serial = ser/mean(ser);
                        else
                            ser = reshape(after(row,col,end-256+1:end),1,256);% ĳ����������ʱ������
                            for ii = 1:length(merge_R)
                                ser = ser + reshape(after(merge_R(ii),merge_C(ii),end-256+1:end),1,256);
                            end
                            ser = ser/4;
                            serial = ser/mean(ser);
                        end

                        %%����Ҷϵ������
                        NFFT = 256;                                                 % Ƶ��ͼ�ĵ���
                        A = abs(fft(serial,NFFT));                                  % Ƶ���ֵ
                        f = Fs/2*linspace(0, 1, NFFT/2);                            % ��������������Ƶ�ʷֱ���
                        A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;

                        temp = [sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
                        coef = [coef temp];                                         % ����������鴮����
                    end
                    
                    result = Model_py(coef)                 % �����ַ����
                    
                    II = imread('result.jpg');
                    image(handles.figure,II)

                    T1 = text(handles.figure,'string','���Ĳ�̬������Ϊ: ' , 'position', [50 100], 'Horizontal', 'left','FontName', '���Ŀ���', 'FontSize', 50, 'FontWeight', 'bold','color',[0 0 0]);
                    T2 = text(handles.figure,'string',result , 'position', [690 180], 'Horizontal', 'center','FontName', 'Times New Roman.', 'FontSize', 60, 'FontWeight', 'bold','color',[1 1 1]);
                    set(handles.figure ,'handlevisibility','off','visible','off');

                    % �رմ���
                    fclose(s);
                    delete(s);                  

                    input('again?')

               end
  
            data = cat(3,data,x);

            % �˲������Ĵ��룬y�˲��������
            y = (wc*(x+x1)-(wc-2/Ts)*y1)/(2/Ts+wc);
            after = cat(3,after,y);% �˲����

            speed1 = x-x1;               % ԭ�����õ��ǲ�����ǰ����ֵ��Ϊ�ٶ�
            speed2 = abs(x-y);           % �޸�Ϊ����ֵ���˲���õ���ǰһʱ�̵Ĳ�ֵ
            speedmax1 = max(max(speed1)); % �ٶ����100����,һ�������20��wcmin =2*2*pi; ��ֹƵ�ʱ仯��Χ 6-9Hz
            speedmax2 = max(max(speed2));
            speedmax = max(speedmax1,speedmax2);
            beta = 1/25;

            % �����˲���ֹƵ��
            wc = wcmin+speedmax*beta*2*pi;
            % ����
            y1 = y;x1 = x;
            x = [];
           
        else
            %%warning1 ���ڵõ������ݲ�����8*8��
            disp('warning1');
            x = [];
        end

        
    else
        if size(b,2) == 8
            x = [x;b];          %�洢����
        else
            %  ʵ���з��֣�b�õ����п����ǲ�ȱ�ģ�������8�������������ݡ������޷���ʵ��[x;b]����
            %  �����봮�ڴ���ײ��й�
            % 'warning2 b����8λ������
            fprintf('warning2');
        end
    end

