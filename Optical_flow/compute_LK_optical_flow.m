
function [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2)
% You have to implement the Lucas Kanade algorithm to compute the
% frame to frame motion field estimates. 
% frame_1 and frame_2 are two gray frames where you are given as inputs to 
% this function and you are required to compute the motion field (Vx,Vy)
% based upon them. 
% -----------------------------------------------------------------------%
% YOU MUST SUBMIT ORIGINAL WORK! Any suspected cases of plagiarism or 
% cheating will be reported to the office of the Dean.  
% You CAN NOT use packages that are publicly available on the WEB.
% -----------------------------------------------------------------------%

%Set parameters
im1 = single(rgb2gray(frame_1));
im2 = single(rgb2gray(frame_2));
sigma = 0.1;
sigma_1d=1;
w=15;                               %window size=2w+1

%%%%%%%%%%%%  Smooth function that copied from part of smooth_frames.m  %%
%smooth every two frame that inputed
stack(:,:,:)=zeros(size(im1,1),size(im1,2),2);
% Now populate each slice in the stack
stack(:,:,1)=im1;
stack(:,:,2)=im2;
% Now smooth the stack in the 'Z' (3rd dimension) using a Gaussian
smoothstack = smoothdata(stack,3,'gaussian','SmoothingFactor',sigma);
% Retrive two frames from smoothed stack
sim1=smoothstack(:,:,1);
sim2=smoothstack(:,:,2);
%%%%%%%%%%%%  Smooth function ends here

% I(x,y)-I2(x,y)
simt=sim1-sim2;
% I/Ix, I/Iy
[Ix, Iy] = gradient(sim1);
% Initialize Vx,Vy
Vx=zeros(size(Ix));
Vy=zeros(size(Ix));
len_col = size(Ix,1);
len_row = size(Ix,2);
% Loop through each pixel of the frame
for i=w+1:len_row-w
    for j=w+1:len_col-w
        % For each pixel, find its neighbor pixel and calulate Vx,Vy
        dx=Ix(j-w:j+w,i-w:i+w);
        dy=Iy(j-w:j+w,i-w:i+w);
        dt=simt(j-w:j+w,i-w:i+w);
        % Use Au=-B => u=A'-B to calculate u
        A=[sum(sum(dx.^2)) sum(sum(dx.*dy));sum(sum(dx.*dy)) sum(sum(dy.^2))];
        B=[sum(sum(dx.*dt));sum(sum(dy.*dt))];
        B=smoothdata(B,1,'gaussian','SmoothingFactor',sigma_1d);
        B=-B;
        u= linsolve(A,B);
        % Inverse vector
        Vx(j,i)=-u(1);
        Vy(j,i)=-u(2);
    end
end

end


