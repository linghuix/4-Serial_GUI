% % ����˳���ͼ�λ�չʾ

load('D:\1-embed\4-Serial_GUI\0-��������ѹ���\sensors_press_test_20200101T230746.mat')
loops = size(y,2)

%     for j = 1:1:loops
%         % fprintf('frame %d\n',round(j));
%         imshow(imresize(after(:,:,j)-AAA,50,'nearest'),[100 300]); 
%         drawnow limitrate         
%     end
for j = 1:10:loops
%         fprintf('frame %d\n',round(j));
    imshow(imresize(after(:,:,j),50,'nearest'),[100 200]); 
    drawnow limitrate         
end