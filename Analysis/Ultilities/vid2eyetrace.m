function [y,t]=vid2eyetrace(data,metadata,varargin)
% [y,t]=vid2eyetrace(data,metadata,{thresh,winsize,calib}) - Convert video frames storeed in DATA to
% eyelid trace based on mask and threshold in METADATA.
%
% Optional arguments are (set as empty array [] if you want to set a later argument):
% 3. THRESH to override value in metadata
% 4. WINDOW SIZE (in pixels) for median filter of frame before converting to binary image. 
% 5. CALIB struct with fields of SCALE and OFFSET if you want the data to be returned normalized by full eyelid closure.
% 6. Algorithm to use for measuring eyelid as string, either 'area' (default) or 'pos'. Position mode will return a 2xn matrix
% corresponding to upper and lower eyelid position traces. Note that
% uncalibrated upper and lower traces for 'pos' mode come out inverted
% (upper on bottom) because they are in pixel units and vertical pixels
% start at the top. This is corrected for in the calibration routine using
% the GETCALIB function.


if nargin > 2 && ~isempty(varargin{1})
    thresh=varargin{1};
else
    thresh=metadata.cam.thresh;
end

if nargin > 3 && ~isempty(varargin{2})
	w=varargin{2};
else
	w=1;
end

if nargin > 4 && ~isempty(varargin{3})
	calib=varargin{3};
else
	calib.scale=1;
	calib.offset=[0; 0];
end

if nargin > 5 && ~isempty(varargin{4})
    algo=varargin{4};
else
    algo='area';   
end

[m,n,c,f]=size(data);

if nargout>1    % Only compute these if user asks for time as output
    sr=metadata.cam.fps;
    sint=1./sr;
    st=-metadata.cam.time(1)/1e3;
    t=st:sint:f*sint+st-sint;
end

if strcmp(algo,'area')
    y=zeros(1,length(f));
    for i=1:f
        wholeframe=data(:,:,1,i);   % make it a grayscale image in case it's not (this assumes all color channels have roughtly the same value)
        % binimage=im2bw(medfilt2(wholeframe,[w w]),thresh);
        binimage=medfilt2(wholeframe,[w w]) > thresh*256;
        % binimage=im2bw(wholeframe,thresh);
        eyeimage=binimage.*metadata.cam.mask;
        tr=sum(eyeimage(:)); 
        % tr=sum(sum(eyeimage)); 
        y(i)=(tr-calib.offset(1))./calib.scale;
    end
elseif strcmp(algo,'pos')
    y=NaN(2,length(f));
    for i=1:f
        frame=data(:,:,1,i);
        % xoff=metadata.cam.winpos(1)+round(metadata.cam.winpos(3)/2);
        y(:,i)=CalcLidPosition(frame,metadata.cam.winpos,thresh*256,10);
%         y(:,i)=CalcLidPosition(frame,metadata.cam.winpos,thresh*256-3:thresh*256+3,1);
        if isnan(y(1,i))
            y(1,i)=y(1,i-1);
        end
        if isnan(y(2,i))
            y(2,i)=y(2,i-1);
        end
    end
    y=bsxfun(@minus,y,calib.offset)./calib.scale;
else
    error('Please specify a valid eyelid measurement algorithm.')
end