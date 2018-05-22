function [ I_warp ] = WarpImage( I,u,v )
% This function back projects image I using u and v.
% Inputs:   I - image to be wrapped
%           u - flow filed in x axis
%           v - flow field in y axis
% Ouputs:   I_wrap - wrapped I image baswd on the flow field u and v.
 
[X,Y] = meshgrid(1:size(I,2),1:size(I,1));

% Interpolate
I_warp = interp2(X,Y,I,X+u,Y+v);

% Replace NAN values with velues from the original image
I_warp(isnan(I_warp))=I(isnan(I_warp));
end

