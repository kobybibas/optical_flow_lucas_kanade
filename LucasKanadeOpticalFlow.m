function [u,v] = LucasKanadeOpticalFlow(I1,I2,WindowSize,MaxIter,NumLevels)
% This	function computes optical flow using Iterative Pyramid Lucas-Kanade Algorithm	
% Input:    I1,I2 - images (I2 is back-projected to I1)	
%           WindowSize - size of local	neighbourhood	around	the	pixel
%           MaxIter - maximum iterations that we allow (for	each level of the pyramid)	
%           NumLevels - number of levels in	the	image	pyramid	
% Output:	[u,v] – Optical	flow warp parameters (velocity	fields)	


I1=im2double(I1);
I2=im2double(I2);


% Decompose the image to gaussian pyramid
P1 = cell(NumLevels,1);
P2 = cell(NumLevels,1);
P1{1}= I1;
P2{1}= I2;
for lvl=2:NumLevels
    P1{lvl}=impyramid(P1{lvl-1},'reduce');
    P2{lvl}=impyramid(P2{lvl-1},'reduce');
end

% Initiazlie optical flow array
u=zeros(size(P1{NumLevels}));
v=zeros(size(P1{NumLevels}));

% Compute optical flow for each lvl pyramid,
% use the lower level as initial guess for the higer one.
for lvl=NumLevels:-1:1
    for j=1:MaxIter

        % Apply initial guess
        P2_wrapped = WarpImage(P2{lvl},u,v);
        
        % Compute flow field
        [du, dv] = LucasKanadeStep(P1{lvl},P2_wrapped, WindowSize);
        u = u + du; 
        v = v + dv;
    end
    
    % Upscale flow field
    if (lvl~=1)
        u = u * size(P1{lvl-1},1) / size(P1{lvl},1);
        v = v * size(P1{lvl-1},2) / size(P1{lvl},2);
        u = imresize(u,size(P1{lvl-1})); 
        v = imresize(v,size(P1{lvl-1}));
    end
end
end