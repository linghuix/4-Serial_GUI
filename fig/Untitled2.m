cd 'C:\Users\xlh\Desktop'

%% д�룬����֮ǰд������� 
%����������д
g = fopen('a.txt','w');
fwrite(g,[1 2]);    % д��ʱû�лس���.д�����ASCII���1,2��SOH��STX
fwrite(g,'hrd hh','char'); % �Զ�������ʽ��objд������A

%% ֻ��
%���������ݶ�
g = fopen('a.txt','r');
a = fread(g,'char')
% a = fread(g)
% A = fread(obj,size); �Ӵ��ڶ�ȡsize�ֽڳ��̵Ķ��������ݣ���������ʽ����A
% ��ASCII�洢���ļ���S��ȡ������83,t��16,FF-255

%% ����ȥд��
%ASCII����ʽд
g = fopen('a.txt','a');
fprintf(g,'S')      %����д���ֽ���
fprintf(g,'%s','Start')   %���ַ�(ASCII��)��ʽ�򴮿�д����str(�ַ����ַ���)
fprintf(g,'%s','S')

fprintf(g,['ch:%d scale:%d'],[1 20e-3],'sync')
%% ����ȥд��reading and writing; discard ,existing contents
%ASCII����ʽ��,�س�����
g = fopen('a.txt','r+');
z = fscanf(g,'%s')      %����д���ֽ����������������ַ���,���Է��ַ����Ϳո�
%�Ӵ��ڶ�ȡ�ַ����ַ���(ASCII��)��ʽ���ݣ����ַ�������ʽ����str
fclose(g)