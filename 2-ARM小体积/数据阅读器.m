clear all

%% 静态数据图像化阅读器
AAA = [
  660+300 570+300 1050 1160 1180 1180 895-100 730+50;
  650+300 570+300 1080 1150-200 1180 1180 890-100 723+50;
  650+50 570+200 1080 795 1180-200 1180 890-100 730+50;
  645+50 570 780 1150 1137-200 1180 890-100 730+50;
  660+50 570 1080 1111 1180 850 890-100 730-0;
  715+300 820+50 1145 1157 850 1183 850-100 727-50;
  725+300 870+50 1147 1160 1185 1100 890-500 650-400;
  715+300 860+50 1145 1160 1185 1185-200 780-400 730-500;]


%%数据加载
% load('D:\1-embed\4-Serial_GUI\fig_arm\Toeout-3.mat')%[50 500]
load('D:\1-embed\4-Serial_GUI\fig_arm\Toein-2.mat')
% load('D:\1-embed\4-Serial_GUI\fig_arm\normal-111.mat')%[80 400]


for i = [600:800]   % normal.index 选择需要播放的帧区间
    
    imshow(imresize(normal.after(:,:,i)-AAA+30*rand(8,8),20,'box'),[50 400]); 
    %bilinear/bicubic/nearest/box/lanczos2/lanczos3
    
    drawnow limitrate
    i
end


%% 手工阈值的确定
plot(sample(:,1:9:28))
hold on
plot(sample(:,end)*100)