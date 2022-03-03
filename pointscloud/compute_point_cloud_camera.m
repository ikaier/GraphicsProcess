
function camera_point_cloud=compute_point_cloud_camera(imageNumber)

%{
    This function is a modified version of Compute_point_cloud. Since we
    need to compute the 3D points cloud in camera coordinates, instead of
    returning points(x,y,z) in world coordinates like Compute_point_cloud.m does,
    this function returns points(x,y,z) in camera coordinates for Q2.3 and
    Q2.4
%}


% add the corresponding folder name to the path 
addpath(num2str(imageNumber));

% You can remove any inputs you think you might not need for this part:
rgbImageFileName = strcat('rgbImage_',num2str(imageNumber),'.jpg');
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');

rgbImage = imread(rgbImageFileName);
depthImage = imread(depthImageFileName);
intrinsics_matrix = load(intrinsicsFileName);

%Retrive useful information from matrix K since K=
%       fmx     s       px
%       0       fmy     py
%       0       0       1
ax=intrinsics_matrix(1,1);
ay=intrinsics_matrix(2,2);
px=intrinsics_matrix(1,3);
py=intrinsics_matrix(2,3);

%%%%%% points data preprocessing, copy from compute_point_cloud.m %%%%%%%

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


%Retrive 2D coordinate (x,y) of each pixels in graph and its corresponding depth.
%Store (x,y) in a matrix with an extra dummy 1 column.
col_len=size(rgbImage,1);
row_len=size(rgbImage,2);
x=meshgrid(1:col_len,1:row_len);
x=x(:);
y=meshgrid(1:row_len,1:col_len);
y=y.';
y=y(:);

% retrive a list of projected point coordinates and its correspoing depth
coord=[x y];
z=depthImage.';
z=double(z);    % convert it to double for calculation later
z=z(:);


%{
    Calculate 3D coordinates of each pixel point in camera frame.

    First, (x,y)=(x,y)-(px,py) 
    Then (x,y)=(x,y)*Z/(ax,ay) to map (x,y) in pixel coordinates to (X,Y) in
    camera frame.
    Concatenate (X,Y), Z and RGB to retrive 3d coordinates and color in camera coordinates
%}
result=zeros(size(x,1),6);
for i=1:size(x,1)
    b=coord(i,:);
    gx=(b(1)-px)*z(i)/ax;
    gy=(b(2)-py)*z(i)/ay;
    result(i,:)=[gx gy z(i) R(i) G(i) B(i)];
end


camera_point_cloud=result;
end
