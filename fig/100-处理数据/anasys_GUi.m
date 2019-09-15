function varargout = anasys_GUi(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @anasys_GUi_OpeningFcn, ...
                   'gui_OutputFcn',  @anasys_GUi_OutputFcn, ...
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


function anasys_GUi_OpeningFcn(hObject, ~, handles, varargin)
    cd 'C:\Users\pc\Desktop\fig'
    
    % 4,2  4,1  4,3  4,4  4,5
    
    global row col normal toe_out
    normal = load('1.mat');
    toe_out = load('tin girl_2.mat');
    
    normal = normal.normal;
    toe_out = toe_out.normal;
    
    row = 1;
    col = 1;
    
    handles.output = hObject;
    guidata(hObject, handles);


function row_Callback(hObject, eventdata, handles)
    global row
        val=get(hObject,'value');
    switch val
        case 1
            row= 1;
        case 2
            row= 2;
        case 3
            row= 3;
        case 4
            row= 4;
        case 5
            row= 5;
        case 6
            row= 6;
        case 7
            row= 7;
        case 8
            row= 8;
    end
    row

function col_Callback(hObject, eventdata, handles)
    global col
        val=get(hObject,'value');
    switch val
        case 1
            col= 1;
        case 2
            col= 2;
        case 3
            col= 3;
        case 4
            col= 4;
        case 5
            col= 5;
        case 6
            col= 6;
            
        case 7
            col= 7;
        case 8
            col= 8;
    end
    col
    
function curve_Callback(hObject, eventdata, handles)
    global row col normal toe_out
    figure(1)
    subplot 211
    plot(reshape(normal.data(row,col,:),1,size(normal.data,3)))
    subplot 212
    plot(reshape(toe_out.data(row,col,:),1,size(toe_out.data,3)))
function curve_length_Callback(hObject, eventdata, handles)
    global row col normal toe_out
    figure(1)
    plot(log10(abs(fft(reshape(normal.data(row,col,normal.index),1,length(normal.index))))))
    hold on
    plot((1:length(toe_out.index))/length(toe_out.index)*length(normal.index),log10(abs(fft(reshape(toe_out.data(row,col,toe_out.index),1,length(toe_out.index))))))
    axis([1 inf 0 Inf])
    legend('normal','other')

function filter_Callback(hObject, eventdata, handles)
    global row col normal toe_out
    figure(1)
    subplot 211
    plot(reshape(normal.after(row,col,:),1,size(normal.after,3)))
    subplot 212
    plot(reshape(toe_out.after(row,col,:),1,size(toe_out.after,3)))
function filter_length_Callback(hObject, eventdata, handles)
    global row col normal toe_out
    figure(1)
    plot(log10(abs(fft(reshape(normal.after(row,col,normal.index),1,length(normal.index))))))
    hold on
    plot((1:length(toe_out.index))/length(toe_out.index)*length(normal.index),log10(abs(fft(reshape(toe_out.after(row,col,toe_out.index),1,length(toe_out.index))))))
    axis([1 inf 0 Inf])
    legend('normal','other')
    
function movie_Callback(hObject, eventdata, handles)
    

function varargout = anasys_GUi_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output;
function col_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function row_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in curve_length.

% hObject    handle to curve_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filter_length.

% hObject    handle to filter_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
