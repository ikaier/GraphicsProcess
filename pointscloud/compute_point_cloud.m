
function compute_point_cloud(imageNumber)



% This function provides the coordinates of the associated 3D scene point 
% (X; Y;Z) and the associated color channel values for any pixel in the 
% depth image. You should save your output in the output_file in the 
% format of a N x 6 matrix where N is the number of 3D points with 3 
% coordinates and 3 color channel values:
% 
% X_1,Y_1,Z_1,R_1,G_1,B_1
% X_2,Y_2,Z_2,R_2,G_2,B_2
% X_3,Y_3,Z_3,R_3,G_3,B_3
% X_4,Y_4,Z_4,R_4,G_4,B_4
% X_5,Y_5,Z_5,R_5,G_5,B_5
% X_6,Y_6,Z_6,R_6,G_6,B_6
% .
% .
% .
% .
%
% IMPORTANT:
% "Your output should be saved in MATLAB binary format (.mat)"
% You may use any of the four following inputs for this part:
% For example, if imageNumber is 1 then possible inputs you might need
% can have the following values:
% rgbImageFileName = 'rgbImage_1.jpg';
% depthImageFileName = 'depthImage_1.png';
% extrinsicFileName = 'extrinsic_1.txt
% intrinsicsFileName = 'intrinsics_1.txt'
%
% Output file name = 'pointCloudImage_1.mat'


% add the corresponding folder name to the path 
addpath(num2str(imageNumber));

% You can remove any inputs you think you might not need for this part:
rgbImageFileName = strcat('rgbImage_',num2str(imageNumber),'.jpg');
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
extrinsicFileName = strcat('extrinsic_',num2str(imageNumber),'.txt');
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');

rgbImage = imread(rgbImageFileName);
depthImage = imread(depthImageFileName);
extrinsic_matrix = load(extrinsicFileName);
intrinsics_matrix = load(intrinsicsFileName);


%%% YOUR IMPLEMENTATION GOES HERE:

%Separete RGB color channel, and convert their matrices to 1D arrays in line order
rgbImage=double(rgbImage);
R=rgbImage(:,:,1);
R=R.';
R=R(:);
G=rgbImage(:,:,2);
G=G.';
G=G(:);
B=rgbImage(:,:,3);
B=B.';
B=B(:);

%Calculate P=K*R[I|-C]
p=intrinsics_matrix*extrinsic_matrix;

%Retrive 2D coordinate (x,y) of each pixels in graph and its corresponding depth.
%Store (x,y) in a matrix with an extra dummy 1 column.
col_len=size(rgbImage,1);
row_len=size(rgbImage,2);
x=meshgrid(1:col_len,1:row_len);
x=x(:);
y=meshgrid(1:row_len,1:col_len);
y=y.';
y=y(:);
oone=ones(size(x,1),1);
coord=[x y oone];
%Store corresponding depth in 1D array in line order
z=depthImage.';
z=z(:);

% For each pixel,
% Solve for its world coordinates using p and depth map
% using formula (wx,wy,w)=p(X,Y,Z).
% In the end, concatenate coordinates with RGB value.
result=zeros(size(x,1),6);
for i=1:size(coord,1)
    b=coord(i,:).';
    xyz=linsolve(p,double(b));
    xyz=xyz(1:3).';
    xyz=xyz/xyz(3)*double(z(i));
    result(i,:)=[xyz(:,1) xyz(:,2) -xyz(:,3) R(i) G(i) B(i)];
end

%Plot 3D graph
plot_title = strcat('3D point cloud in world coordinates for image ',num2str(imageNumber));
figure;
pcshow([result(:,2) result(:,1) result(:,3)],result(:,4:6)/255);  %Since matlab using (y,x) to plot, we switched position of x and y
title(plot_title);
xlabel('X');
ylabel('Y');
zlabel('Z');

%To save your ouptut use the following file name:
outputFileName = strcat('pointCloudImage_',num2str(imageNumber),'.mat');
save(outputFileName,'result');
end
