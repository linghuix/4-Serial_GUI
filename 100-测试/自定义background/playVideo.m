function hFig1 = playVideo(videoFile)

%     hFig1 ��������ɾ����figure���
%     videoFile  = 'H:\4-mymovies\own\�������Ⱦ.mp4';

    video=vision.VideoFileReader(videoFile);
    
%     hFig1 =  figure(1
    hFig1=figure('name','video','position',[0 0 1200 900]);
    hPanel = uipanel('parent',hFig1,'Position',[0 0 1 1],'Units','Normalized'); 
    axis1=axes('position',[0 0 1 1]);

%     hFig2=figure('pos ition',[700 400 325 245]);
%     hPane2 = uipanel('parent',hFig2,'Position',[0 0 1 1],'Units','Normalized');
%     axis2=axes('position',[0 0 1 1],'Parent',hPane2);

    while ~isDone(video)
        frame=step(video);
        showFrameOnAxis(axis1,frame);
%         showFrameOnAxis(axis2,frame);
    end
    release(video);
%     close(hFig1)  % ����
    close('name','video') 
    
    