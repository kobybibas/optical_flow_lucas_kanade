%%%%%%%%%%%%%%%%%%%%%%%%HW2_MAIN%%%%%%%%%%%%%%%%%%%%%

close all
clearvars
clc


%%%%%%%%%PART 1: Lucas-Kanade Optical Flow%%%%%%%%%%%

% Load images I1,I2
load('PART1_IMAGES.mat');

% Choose parameters
WindowSize  =   11;
MaxIter     =   3;
NumLevels   =   3;

%Compute optical flow using LK algorithm
[u,v] = LucasKanadeOpticalFlow(I1, I2, WindowSize, MaxIter, NumLevels);

% Warp I2
I2_warp = WarpImage(I2,u,v);

%Plot I1,I2,I2_warp
figure; imshow(I2); title('I2')
figure; imshow(I2_warp); title('I2\_warp')
figure; imshow(I1); title('I1')

%%%%%%%%%%%PART 2: Video Stabilization%%%%%%%%%%%%%%%

% Choose parameters
WindowSize  =   49;
MaxIter     =   3;
NumLevels   =   3;
NumOfFrames = 80; %Number of video frames

% Load video file
InputVidName='inputVid.avi';
InputVid = vision.VideoFileReader(InputVidName);

%Stabilize video
StabilizedVid = LucasKanadeVideoStabilization(InputVid, WindowSize, MaxIter, NumLevels, NumOfFrames);
