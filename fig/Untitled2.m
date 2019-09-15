cd 'C:\Users\xlh\Desktop'

%% 写入，抛弃之前写入的内容 
%二进制数据写
g = fopen('a.txt','w');
fwrite(g,[1 2]);    % 写入时没有回车的.写入的是ASCII表的1,2。SOH，STX
fwrite(g,'hrd hh','char'); % 以二进制形式向obj写入数据A

%% 只读
%二进制数据读
g = fopen('a.txt','r');
a = fread(g,'char')
% a = fread(g)
% A = fread(obj,size); 从串口读取size字节长短的二进制数据，以数组形式存于A
% 以ASCII存储的文件，S读取出来是83,t是16,FF-255

%% 接下去写入
%ASCII码形式写
g = fopen('a.txt','a');
fprintf(g,'S')      %返回写入字节数
fprintf(g,'%s','Start')   %以字符(ASCII码)形式向串口写数据str(字符或字符串)
fprintf(g,'%s','S')

fprintf(g,['ch:%d scale:%d'],[1 20e-3],'sync')
%% 接下去写入reading and writing; discard ,existing contents
%ASCII码形式读,回车结束
g = fopen('a.txt','r+');
z = fscanf(g,'%s')      %返回写入字节数，读出来的是字符串,忽略非字符串和空格
%从串口读取字符或字符串(ASCII码)形式数据，以字符数组形式存于str
fclose(g)