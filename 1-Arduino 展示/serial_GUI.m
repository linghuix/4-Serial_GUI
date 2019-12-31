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
    cd 'D:\1-embed\4-Serial_GUI\1-Arduino չʾ'
    % COM���ںţ�rate ������, Stopbitֹͣλ��Databit����λ
    % command�������savename�����ļ���
    % J��K ���������
    global COM rate Stopbit Databit terminator command
    global maxNum J K h h2
    global pause showfigure t
%     h2
    % Ĭ��ֵ
    pause = 1;
    COM = 'COM3';
    rate = 115200;
    Stopbit = 1;
    Databit = 8;
    terminator = 'LF';
    command = 'start';
    maxNum = 256;
    J = 1;K = 1;
    showfigure = 0;

%     t = timer('period',1,'executionmode','fixedrate','busymode','queue');
%     t.TimerFcn  = {@my,handles};
    
    set(handles.popCOM,'value',3);
    set(handles.popRate,'value',4);
    set(handles.popStopbit,'value',1);
    set(handles.popDatabit,'value',4);
    set(handles.terminator,'value',2);
    set(handles.maxNum,'value',6);

    fprintf('*****************************************\n');
    fprintf('��ӭʹ��Arduino Serial_GUI��\n');
    fprintf('Author����Linghui Xu\n');
    fprintf('Product Time����2019.04.02\n');
    fprintf('*****************************************\n');

    %��ʼ������
    %���÷���Ϊ��string���������е��±꣬��1��ʼ
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
    % set(handles.figure, 'XTickLabel' ,{'a','b','c'}) ; %������������̶�ֵ��Ϊa,b,c��
    
    set(handles.st, 'String', '��ʼ���ɹ���')

    % Choose default command line output for serial_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes serial_GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

% function my(mtimer,event,handles)
%         global after J K
% %         J
% %         mtimer
% %         handles
%         set(handles.st,'String',num2str(after(J,K,end)));

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
function OpenSerial_Callback(hObject, eventdata,handles)
    % hObject    handle to OpenSerial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
        set(handles.st, 'String', '�򿪴���')
    
    %%���matlab�Ѿ����˴��ڣ��ر�������ֹռ��
    if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
         fprintf('�ر�matlab�Ѿ����˴���: %s \n',instrfind);
    end

    global COM rate Stopbit terminator
    global s x x1 y1 wcold maxNum
    global wc Ts data after bbb wcmin h h2
    
    data = [];
    after = [];
    
    % h2 ��ɾ���ľ������Ȼɾ���˾��������ָ��Ķ���ı������Ǵ��ڵ�
    % ��ˣ���Ҫ��isvalid�жϣ��Ƿ�����Ч�ľ��
    if (isempty(h2))
        h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
        h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
        fprintf('create h and h2');
    elseif (~isvalid(h2))
        h  = animatedline('MaximumNumPoints',maxNum,'Color',[1 0 0]);
        h2 = animatedline('MaximumNumPoints',maxNum,'Color',[0 0 0]);
        fprintf('create h and h2');
    else
        clearpoints(h);
        clearpoints(h2);
        fprintf('clearpoints \n');
    end
    
    %axis(handles.figure,[0 1500 0 1024]);

    % �����˲���������
    x  = [];
    x1 = zeros(8,8);    %�ͺ�һ�׵�
    y1 = zeros(8,8);    %�ͺ�һ��

    % �����˲����Ĳ�����wcΪ��ֹƵ�ʣ�wcminΪ��ʼ����ֹƵ�ʡ�TsΪ��������
    wcold = 5*2*pi;
    wc = 2*2*pi;wcmin = wc;
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
    
%     if (~isvalid(t))
        
%     end
   
%     start(t);
    

%     file = 'H:\4-mymovies\own\�������Ⱦ.mp4';
%     playVideo(file);
        

function ReceiveCallback( ~, ~,handles)
    global s
    global x x1 y1 wc Ts data after wcmin h h2
    global J K
    global pause
    
    b = fgetl(s);
    b = str2num(b);           %�ú���fget(s)�ӻ�������ȡ�������ݣ���������ֹ�������з���ֹͣ��
                                %������Arduino������Ҫʹ��Serial.println()
                                %����������ֶ��Ǻ��֣����硰����6����������[]
    if( isempty(b) )            %�����Ƿ���[]����Ϊÿ��scanǰ������������֣��ο�arduino�г���
        if(size(x,1) == 8)      %����x�Ƿ���8*8��
                %toc;
%             W = x ��Ϊ֤ʵ����������λΪg
%             x = 1000*(x - 140*ones(8,8))./A;

%                 % ʵ�ʴ��������ݴ洢��
%                 if (size(data,3) >= 200)    %��ʱsize = 200
%                     All_data = cat(3,All_data,data(:,:,end-189:end)); 
%                     size(All_data,3)
%                     %����������ݵĺ�190��������ǰ10��
%                     data = data(:,:,end-9:end);
%                     %������10��������һ�����´α���ͻ��Զ�������50���Ѿ���¼������
%                 else
                data = cat(3,data,x);
%                 end


            % �˲������Ĵ��룬y�˲��������
            y = (wc*(x+x1)-(wc-2/Ts)*y1)/(2/Ts+wc);

%                 if (size(after,3) >= 200)  %��ʱsize = 200
%                     All_data_after = cat(3,All_data_after,after(:,:,end-189:end));  
%                     %����������ݵĺ�150��������ǰ50��
%                     after = after(:,:,end-9:end);
%                     % ������50��������һ�����´α���ͻ��Զ�������50���Ѿ���¼������
%                 else
                after = cat(3,after,y);% �˲����
%                 end

            speed1 = x-x1;               % ԭ�����õ��ǲ�����ǰ����ֵ��Ϊ�ٶ�
            speed2 = abs(x-y);           % �޸�Ϊ����ֵ���˲���õ���ǰһʱ�̵Ĳ�ֵ
            speedmax1 = max(max(speed1)); % �ٶ����200����,һ�������50��wcmin =2*2*pi; ��ֹƵ�ʱ仯��Χ 2-10Hz
            speedmax2 = max(max(speed2));
            speedmax = max(speedmax1,speedmax2);
            beta = 1/6;

            % �����˲���ֹƵ��
            wc = wcmin+speedmax*beta*2*pi;
            if(wc>20*pi) wc = 20*pi;
            end
%             wc/2/pi
            % ����
            y1 = y;x1 = x;
            % clear x
            x = [];

            length_data = size(data(J,K,:),3);
            
            %%plot figure
            if(pause)
                addpoints(h, length_data,[data(J,K,end)]);
                addpoints(h2,length_data,[after(J,K,end)]);
                drawnow limitrate
            end
            
%        %% gait analysis  ����һ�β��Ե�ʱ���ʱ�Ƚϳ����ڶ���֮��ͻ����࣬�ܹ�ʵ��ʵʱ�����߱仯
%        
%             Fs = 30;
%             % ����������鴮����
%             Row = [1 2 3 4 5 3 4 5 2 6 4 5 7 5 7 8];
%             Col = [7 7 7 7 7 6 6 6 5 5 4 4 4 3 3 1];
%             merge_R = [8 7 7];
%             merge_C = [2 1 2];
%         
%             coef = [];  
%             
%         if (mod(length_data,256) == 0)
%             tic;
% %             cd ' D:\1-embed\4-Serial_GUI'
% 
%             % ����������鴮����
%             for row_col = 1:length(Row) 
% 
%                 row = Row(row_col);
%                 col = Col(row_col);
%                 
%                 if row == 8
%                     ser = reshape(after(row,col,end-256+1:end),1,256);% ĳ����������ʱ������
%                     serial = ser/mean(ser);
%                 else
%                     ser = reshape(after(row,col,end-256+1:end),1,256);% ĳ����������ʱ������
%                     for ii = 1:length(merge_R)
%                         ser = ser + reshape(after(merge_R(ii),merge_C(ii),end-256+1:end),1,256);
%                     end
%                     ser = ser/4;
%                     serial = ser/mean(ser);
%                 end
%                 
%                 %%����Ҷϵ������
%                 NFFT = 256;                                                 % Ƶ��ͼ�ĵ���
%                 A = abs(fft(serial,NFFT));                                  % Ƶ���ֵ
%                 f = Fs/2*linspace(0, 1, NFFT/2);                            % ��������������Ƶ�ʷֱ���
%                 A_f = [A(1) 2*A(2:NFFT/2)]./NFFT;
% 
%                 temp = [sum(A_f(f>0 & f<=2)) sum(A_f(f>2 & f<=4)) sum(A_f(f>4 & f<=6)) sum(A_f(f>6 & f<=8)) sum(A_f(f>8 & f<=10))];
%                 coef = [coef temp];                                         % ����������鴮����
%             end
% 
%             result = Model_py(coef,'matlab')                 % �����ַ����
% %             result = Model_py(coef,'python') 
%             fprintf('��ķ�����Ϊ%s',char(result));
%             toc
%             set(handles.st, 'String', result);
%         end

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


    
% --- Executes on selection change in popCOM.
function popCOM_Callback(hObject, ~, handles)
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
            set(handles.st, 'String', '�ɹ����ô���COM1')
        case 2
            COM='COM2';
            set(handles.st, 'String', '�ɹ����ô���COM2')
        case 3
            COM='COM3';
            set(handles.st, 'String', '�ɹ����ô���COM3')
        case 4
            COM='COM4';
            set(handles.st, 'String', '�ɹ����ô���COM4')
        case 5
            COM='COM5';
            set(handles.st, 'String', '�ɹ����ô���COM5')
        case 6
            COM='COM6';
            set(handles.st, 'String', '�ɹ����ô���COM6')
        case 7
            COM='COM7';
            set(handles.st, 'String', '�ɹ����ô���COM7')
        case 8
            COM='COM8';
            set(handles.st, 'String', '�ɹ����ô���COM8')
        case 9
            COM='COM9';
            set(handles.st, 'String', '�ɹ����ô���COM9')
    end

    %fprintf('�ɹ����ô��ں�Ϊ = %s\n',COM);


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
            set(handles.st, 'String', '�ɹ����ò�����Ϊ9600')
        case 2
            rate=19200;
            set(handles.st, 'String', '�ɹ����ò�����Ϊ19200')
        case 3
            rate=38400;
            set(handles.st, 'String', '�ɹ����ò�����Ϊ38400')
        case 4
            rate=115200;
            set(handles.st, 'String', '�ɹ����ò�����Ϊ115200')
    end %�˴���end��switch��
    %fprintf('�ɹ����ò�����Ϊ %d \n',rate);


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
        fprintf('����ԭʼ��������')
%         set(h, 'Color',[1 0 0]);
        set(h,'visible','on')
    else
        fprintf('�رջ���ԭʼ��������')
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
        fprintf('����Filitered��������')
%         set(h2, 'Color',[0 0 0]);
        set(h2,'visible','on')
    else
        fprintf('�رջ���Filitered��������')
%         set(h2, 'Color',[1 1 1],'LineWidth',0,'LineStyle', '.','MarkerSize',0.5);
        set(h2,'visible','off')
    end

% --- Executes on button press in CloseSerial.
function CloseSerial_Callback(hObject, ~, handles)
    % hObject    handle to CloseSerial (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    global s COM t
    fclose(s);
    delete(s);
    
%     stop(t);
%     delete(t);
%     clear(t);

    % clearpoints(h);
    % clearpoints(h2);
    % data = [];
    % after = [];
    % clearpoints(h);
    
    set(handles.st, 'String', 'Close COM')
    %fprintf('Close %s \n',COM);


% --- Executes on button press in sendData.
function sendData_Callback(hObject, eventdata, handles)
    % hObject    handle to sendData (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)



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
        case 6
            maxNum = 256;
    end

    if (~isempty(h2))
        set(h,'MaximumNumPoints',maxNum);
        set(h2,'MaximumNumPoints',maxNum);
    %     fprintf('�ɹ� %d \n',maxNum);
    end

    set(handles.st, 'String','�ɹ���������������')
    %fprintf('�ɹ���������������Ϊ %d \n',maxNum);



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
function SaveData_Callback(hObject, eventdata, handles)
    % hObject    handle to SaveData (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    cd 'F:\1-embed\4-Serial_GUI\fig'
    global savename h 
    global data after 
    time = toc;
    [x,y] = getpoints(h);
    save( strcat([savename '_' datestr(now,30)],'.mat'),'data','after','y');
    set(handles.st,'String','����ɹ���');



function SaveName_Callback(hObject, eventdata, handles)
    % hObject    handle to SaveName (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of SaveName as text
    %        str2double(get(hObject,'String')) returns contents of SaveName as a double

    global savename
    savename = get(hObject,'String')
    set(handles.st,'String','�ļ����Ƴɹ�����');

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
            fprintf('�����˲�')
        else
            fprintf('�ر��˲�')
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

    % ����ȥ��1������ʱ0
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


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton9

    val = get(hObject,'value');
    if (val)
        fprintf('��������')
    else
        fprintf('����������')
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

    global pause t
%     t
%     stop(t)
    set(handles.reStart,'visible','on');
    set(hObject,'visible','off');
    pause = 0;
    set(handles.st,'String','pause');
    

% --- Executes on button press in reStart.
function reStart_Callback(hObject, ~, handles)
    % hObject    handle to reStart (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global pause h h2 t
    
    set(handles.pause,'visible','on');
    set(hObject,'visible','off');

    clearpoints(h);
    clearpoints(h2);
%     start(t);
    pause = 1;
    set(handles.st,'String','reStart');

% --- Executes on button press in showfigure.
function showfigure_Callback(hObject, eventdata, handles)
% hObject    handle to showfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showfigure

    global data h2

    figure(5)
    [x,y] = getpoints(h2);
    loops = size(x,2)
    F(loops) = struct('cdata',[],'colormap',[]);
    for j = 1:loops
        imshow(imresize(data(:,:,j),100,'nearest'),[250 800]); 
        drawnow limitrate%         
        %F(j) = getframe;
    end
    
%     movie(F)
    close figure 5



% --- Executes during object deletion, before destroying properties.
function showfigure_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to showfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function st_CreateFcn(hObject, eventdata, handles)
% hObject    handle to st (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
