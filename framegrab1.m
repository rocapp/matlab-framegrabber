function [] = FrameGrab( vidObj,name )
%FrameGrab Saves video frames as images
%   input: video object, and name of input folder
%   output: frame saved as VIDEO_frame_#.png

foldername = name;
mkdir('output',foldername);

vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
while hasFrame(vidObj)
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end

for f=1:k-1
    figure(1);imshow(s(f).cdata);
    set(1,'Position',[100 100 1280 720])
    colormap gray;
    set(gca,'LooseInset',get(gca,'TightInset'));
    filename = sprintf('%s_frame_%d',name,f);
    saveas(1,[pwd '/output/',foldername,'/',filename],'png');
end
