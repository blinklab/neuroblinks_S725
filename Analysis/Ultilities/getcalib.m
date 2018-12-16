function calib=getcalib(trace,varargin)
% function [scale,offset]=getcalib(trace,varargin)
% Return video calibration values for eyelid (scale and offset) in CAL vector. 
% [scale,offset]=getcalib(TRACE,{PRE})
% Scale and offset are returned, which can be used to convert pixel counts to %FEC. 
% Code assumes that eye is fully
% open at beginning for at least PRE frames (default=40) and reaches full
% closure between PRE and POST (default 40 frames).

if nargin > 1
    pre=varargin{1};
    post=varargin{2};
else
    pre=40;
    post=40;
end

if isvector(trace)	% Single dimension of trace means we're using pupil area algorithm
	calib.offset=min(trace(1:pre));
	maxclosure=max(trace(pre:pre+post));
	calib.scale=maxclosure-calib.offset;
else
	%otherwise, assume we're using eyelid position algo and that the upper and lower eyelid traces are stored as row vectors
	calib.offset=[mean(trace(1,1:pre));mean(trace(2,1:pre))];
	calib.scale=-diff(calib.offset);	% have to invert it b/c we want to subtract lower from upper but diff works the other way.
end


% cal=[scale offset];