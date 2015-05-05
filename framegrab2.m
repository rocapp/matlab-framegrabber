function [inputnameout] = FrameGrab2(inname)
%FrameGrab2 Saves video frames as images
%   input: name of input folder, inname;

%   output: saves each video as an MAT in the output folder, also outputs
%   intputnameout: the names of all videos


n=1; % number of videos processed (1 is none)

% list the contents we want from input folder
infolder = inname;
input = dir(infolder);
inputname = ({input.name}');
inputnameout = char(inputname(3:end,:));

for fileno=3:length(inputname);

    sprintf('Currently working on file no. %d, %s', fileno-2,char(inputname(fileno)))
    
    
    % video object
    vidObj = VideoReader(fullfile(inname, char(inputname(fileno))));
    
    % height, width of video
    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    
    % structure for image
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    
    % store the frame data in s
    k = 1;
    while hasFrame(vidObj)
        s(k).cdata = readFrame(vidObj);
        k = k+1;
    end
    
    % preallocate for current video (nth video)
    VideoNFrames=zeros(vidHeight,vidWidth,k-1);
    
    % % grab each frame, display, and save to memory
    for f=1:k-1
        figure(1);imshow(s(f).cdata);
        set(1,'Position',[100 100 vidWidth vidHeight])
        colormap gray;
        set(gca,'LooseInset',get(gca,'TightInset'));
        VideoNFrames(:,:,f) = rgb2gray(im2double(s(f).cdata)); % current video in memory
    end
    
    
    % save each set of frames in a cell struct .MAT file
    finalname= sprintf('%s.mat',char(inputname(fileno)));
    save(fullfile('output', finalname),'VideoNFrames','-v7.3');
    
    
    n=n+1;


end
