# Optical Flow Implementation
Computing optical flow using Lucas-Kanade algorithm in Matlab. The main function consists with 2 part. 

## Part 1
1. Computes the velocity fields (u,v) between images I1 and I2. 
2. Using those values I2 is back-projected to I1 (the result is very similar to I1).
The Optical Flow (velocity field) is computed using the Lucas-Kanade Algorithm.

## Part 2
A video is stablized using Lucas-Kanade Optical Flow:
Given a video sequence, for each frame compute the LK Optic Flow with respect to the previous warped frame and warp the entire image.
For example, suppose you've warped frame k to frame 1:
1. compute the warp from frame k+1 to frame k
2. add the warp you computed from frame k to frame 1
3. use the combined warp to warp frame k+1 to the coordinate system of frame 1.
