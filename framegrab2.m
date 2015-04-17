function [inputnameout] = FrameGrab2(inname)
%FrameGrab2 Saves video frames as images
%   input: name of input folder, inname; optional input: number of frames
%   to bypass, frametotal. Default is 3.
%   output: saves each video as an MAT in the output folder, also outputs
%   intputnameout: the names of all videos

% p = inputParser;
% frametotal = 3;
% addRequired(p,'inname');
% addOptional(p,'frametotal',frametotal);
% 
% parse(p,inname,varargin{:});
% if nargin(FrameGrab2) <2
%     frametotal = 3;
% end

n=1; % number of videos processed (1 is none)

% list the contents we want from input folder
infolder = inname;
input = dir(infolder);
inputname = ({input.name}');
inputnameout = char(inputname(3:end,:));

for fileno=30:length(inputname);
sprintf('Currently working on file no. %d, %s', fileno-2,char(inputname(fileno)))


% video object
vidObj = VideoReader(fullfile(inname, char(inputname(fileno))));

% folder to output
% foldername = char(inputname(fileno+2));
% mkdir('output',foldername);

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
%     filename = sprintf('%s_frame_%d',foldername,f);
%     saveas(1,[pwd '/output/',foldername,'/',filename,'.png'],'png');
end


% save each set of frames in a cell struct .MAT file
finalname= sprintf('%s.mat',char(inputname(fileno)));
save(fullfile('output', finalname),'VideoNFrames','-v7.3');


n=n+1;



% varargout{n} = VideoNFrames;

% prealocate for all videos
% FRAMEOUT = zeros(vidHeight,vidWidth,k-1,length(inputname));
% for im=1:k-1
%     imagename = sprintf('%s_frame_%d.png',foldername,im);
%     FRAMEOUT(:,:,im,n) = rgb2gray((imread(fullfile('output/',foldername,'/',imagename))));
% end
%outputold: frame saved as VIDEO_frame_#.png
%outputold2: stores all frames as grayscale in struct varargout, n is the
%number of videos... access different videos as varargout{n}, where
%n is the number the video falls in the sequence



end
