function output_object =LucasKanadeVideoStabilization(InputVid,WindowSize,MaxIter,NumLevels, NumOfFrames)

% Create the output file and VideoWriter object
output_object = VideoWriter('StabilizedVid.avi');
open(output_object);

% Initialize first frame
fprintf('Start processing frames \n')
I1 = rgb2gray(step(InputVid));
u = zeros(size(I1));
v = zeros(size(I1));
writeVideo(output_object,I1);

% Iterate over the video's frames
for k = 2:NumOfFrames
    tic;
    
    % Protection against too short video
    if (isDone(InputVid))
        break
    end
    I2 = rgb2gray(step(InputVid));
    
    % Compute flow
    [du, dv] = LucasKanadeOpticalFlow(I1,I2,WindowSize,MaxIter,NumLevels);
    u = u + du;
    v = v + dv;
    
    % Preform avg to smoother result
    u = imboxfilt(u, 5);
    v = imboxfilt(v, 5);
    
    % Apply transformation to stablize with respect to the first frame
    I2_warp = WarpImage(I2,u,v);
    
    % Save to file
    writeVideo(output_object,I2_warp);
    I1 = I2;
       
    fprintf('finished frame number = %d/%d, time %f \n', k, NumOfFrames, toc);
end
close(output_object);

end

