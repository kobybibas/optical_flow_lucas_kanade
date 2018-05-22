function  [du, dv] = LucasKanadeStep(I1,I2,WindowSize)
% This	function computes optical flow	using a	single iteration of	Lucas-Kanade Algorithm.			
% Input:    I1,I2 - images	(I2 is back-projected to I1)	
%           WindowSize - size of local neighbourhood around	the	pixel
% Output:   [du,dv] – Optical flow warp parameters (velocity fields)	

% Padd the images so the borders will be valid too
w = floor(WindowSize/2);
I1_padded = padarray(I1, [w w], 'replicate');
I2_padded = padarray(I2, [w w], 'replicate');


% Compute gradient
[Ix, Iy] = gradient(I2_padded);
It = I2_padded - I1_padded;

% Initialize flow field
du = zeros(size(I2));
dv = zeros(size(I2));

% For every window calculate the flow of the middle pixel

% %every depth-column of shiftCube contains a pixel and its
% %window-surroundins
% Ix_shiftCube = zeros([size(I1),WindowSize]);
% Iy_shiftCube = zeros([size(I1),WindowSize]);
% It_shiftCube = zeros([size(I1),WindowSize]);
% 
% k = 1;
% for col = -w:w
%     for row = -w:w
%         assert(k <= WindowSize^2, 'unreasonable number of iterations');
%         
%         Ix_shiftCube(:,:,k) = Ix(1+w+col:end-w+col, 1+w+row:end-w+row);
%         Iy_shiftCube(:,:,k) = Iy(1+w+col:end-w+col, 1+w+row:end-w+row);
%         It_shiftCube(:,:,k) = It(1+w+col:end-w+col, 1+w+row:end-w+row);
%         k = k+1;
%     end
% end
% 
% %sorting out for quick computations
% num_of_col = size(du,1);
% num_of_row = size(du,2);
% 
% Ix_rotatedCube = permute(Ix_shiftCube,[3 1 2]);
% Iy_rotatedCube = permute(Iy_shiftCube,[3 1 2]);
% B_cube = zeros(WindowSize^2, 2, num_of_col*num_of_row);
% B_cube(:,1,:) = reshape(Ix_rotatedCube, WindowSize^2, 1, size(I2,1)*size(I2,2));
% B_cube(:,2,:) = reshape(Iy_rotatedCube, WindowSize^2, 1, size(I2,1)*size(I2,2));
% 
% It_rotatedCube = permute(It_shiftCube, [3,1,2]);
% It_flatten_cube = reshape(It_rotatedCube, WindowSize^2, 1, size(I2,1)*size(I2,2));
% 
% %computing
% for col = 1:num_of_col
%     for row = 1:num_of_row
%         
%         depth = (row-1)*num_of_col + col;
%         
%         B = B_cube(:,:, depth);
%         It_in_win = It_flatten_cube(:,1,depth);
%         dP = -inv(B'*B) * B' * It_in_win;
%         du(col,row)=dP(1);
%         dv(col,row)=dP(2);
%         
%     end
% end
row = 1;
for i = w+1:size(Ix,1)-w
    col = 1;
    
    for j = w+1:size(Ix,2)-w
        
        % Extracat window
        Ix_in_win = Ix(i-w:i+w, j-w:j+w);
        Iy_in_win = Iy(i-w:i+w, j-w:j+w);
        It_in_win  = It(i-w:i+w, j-w:j+w);
        Ix_in_win = Ix_in_win(:);
        Iy_in_win = Iy_in_win(:);
        It_in_win = It_in_win(:);
        
        % Calculate the flow
        B = [Ix_in_win Iy_in_win];
        dP = -inv(B'*B) * B' * It_in_win;
        du(row,col)=dP(1);
        dv(row,col)=dP(2);
        
        col = col + 1;
    end
    row = row + 1;
    
end

end

