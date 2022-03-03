
function [projectedDepthImage,projectedRGBImage]=compute_2D_projection(imageNumber,omegaT,rotationAxis,translationVector)


% This function create two images: 1) an image that contains the projected 
% depth value  (greyscale) and 2) an image that contains the projected 
% color of the 3D scene point.
%  
% INPUTS: 
% imageNumber: you may check the previous function and see how it has been
% used.
%
% omegaT is a value between 0 to pi/2 make sure not to use degrees!
%
% rotationAxis is either 'x' or 'y' or 'z' (you can use strcmp function
% to find which axis the rotation is about. 
%
% translationVector is a 3x1 vector that indicates the translation
% direction. For this assignment, it should have only 1 non-zero element,
% which defines the translation direction implicitly (i.e unlike what you 
% will do for rotation, you do not have to explicitly set a translation
% direction, the nonzero element will take care of direction and the
% translation amount).
%
% You can read the saved point cloud from the previous function and use
% that information here. You may also use any other inputs that are
% provided in the assignment description.
% 
% OUTPUTS:
% projectedDepthImage: an image that contains the projected depth
% value (greyscale)
% 
% projectedRGBImage: an image that contains the projected color of the 3D 
% scene point.





%%% YOUR IMPLEMENTATION GOES HERE:

%load one depth Image to retrive the dimension of image.
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
depthImage = imread(depthImageFileName);
len_col=size(depthImage,1);
len_row=size(depthImage,2);

%Initilize the points array with corresponding dimension
temp_projectedDepthImage=zeros(len_col*len_row,6);

%Retrive K
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');
intrinsics_matrix = load(intrinsicsFileName);

%Calculate new 3D clouds after rotation and translation in Camera frame.
new_3dpoints=compute_new_3dpoints(imageNumber,omegaT,rotationAxis,translationVector);

%To store depth of every pixel
camera_depth=zeros(len_col*len_row,1);

% Calculate (wx,xy,w) by using formula K*(X,Y,Z) where (X,Y,Z) is in camera
% coordinates. Then (x,y)=(wx,xy)/w to obtain the pixel coordinate of each
% point
ho_3dpoints=new_3dpoints(:,1:3);
for i=1:size(ho_3dpoints,1)
    temp=intrinsics_matrix*ho_3dpoints(i,:).';
    camera_depth(i)=temp(3);
    % ignore where w=0 to avoid dividing a number by 0
    % pixel corresponding (0,0,0) in 3D cordinates will be removed since it cannot be projected 
    if not(temp(3)==0)
        temp=temp/temp(3);
    end
    temp_projectedDepthImage(i,1:2)=temp(1:2);
end


% concatenate pixel coordinate(x,y), depth z and RGB
% Format will be
% X_1,Y_1,Z_1,R_1,G_1,B_1
% X_2,Y_2,Z_2,R_2,G_2,B_2
% X_3,Y_3,Z_3,R_3,G_3,B_3
% X_4,Y_4,Z_4,R_4,G_4,B_4
% X_5,Y_5,Z_5,R_5,G_5,B_5
% X_6,Y_6,Z_6,R_6,G_6,B_6
% ......
temp_projectedDepthImage=[round(temp_projectedDepthImage(:,1:2)) camera_depth new_3dpoints(:,4:6)];

%print 2d frame in 3d
%pcshow(temp_projectedDepthImage(:,1:3),temp_projectedDepthImage(:,5:7)/255);

projectedDepthImage=zeros(size(depthImage));
projectedRGBImage=zeros(len_col,len_row,3);

%%% clean up
% Since we only need to display a limited range of pixels, we need to
% remove all pixel that is out of the image dimensions.
temp_projectedDepthImage(temp_projectedDepthImage(:,1)>len_col, :)= [];
temp_projectedDepthImage(temp_projectedDepthImage(:,1)<=0, :)= [];
temp_projectedDepthImage(temp_projectedDepthImage(:,2)>len_row, :)= [];
temp_projectedDepthImage(temp_projectedDepthImage(:,2)<=0, :)= [];

% Create RGB image and Depth image
for i=1:size(temp_projectedDepthImage,1)
    temp_row=temp_projectedDepthImage(i,:);
    projectedDepthImage(temp_row(1),temp_row(2))=temp_row(3);
    projectedRGBImage(temp_row(1),temp_row(2),1)=temp_row(4);
    projectedRGBImage(temp_row(1),temp_row(2),2)=temp_row(5);
    projectedRGBImage(temp_row(1),temp_row(2),3)=temp_row(6);
end
projectedDepthImage=mat2gray(projectedDepthImage);
projectedRGBImage=uint8(projectedRGBImage);

%
%figure;
%imshow(projectedRGBImage);

end


%{
Calculate 3D points in Camera coordinates after a rotation and translation.

First, compute original 3D points in Camera coordinates using
compute_point_cloud_camera.mat
Then apply rotaion using rotaion matrix then apply transition.
%}

function points3d = compute_new_3dpoints(imageNumber,omegaT,rotationAxis,translationVector)

point_cloud=compute_point_cloud_camera(imageNumber);
%pcshow(point_cloud(:,1:3),point_cloud(:,4:6)/255);

% Calculate Rotation 
result_cloud=point_cloud;
%%%%%%%%%%%%%%%%%%%%%%%%%%  z   %%%%%%%%%%%%%%%
if rotationAxis=='z'
    for i=1:size(point_cloud,1)
        temp_rm=[ cos(omegaT) -sin(omegaT) 0; sin(omegaT) cos(omegaT) 0; 0 0 1];
        result_cloud(i,1:3)=(temp_rm*result_cloud(i,1:3).').';
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%  y   %%%%%%%%%%%%%%%
if rotationAxis=='y'
    for i=1:size(point_cloud,1)
        temp_rm=[cos(omegaT) 0 sin(omegaT); 0 1 0; -sin(omegaT) 0 cos(omegaT)];
        result_cloud(i,1:3)=(temp_rm*result_cloud(i,1:3).').';
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%  x   %%%%%%%%%%%%%%%
if rotationAxis=='x'
    for i=1:size(point_cloud,1)
        temp_rm=[ 1 0 0; 0 cos(omegaT) -sin(omegaT); 0 sin(omegaT) cos(omegaT)];
        result_cloud(i,1:3)=(temp_rm*result_cloud(i,1:3).').';
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% translation %%%%%%%%%%

trans_v=repmat(translationVector,size(result_cloud(:,1:3),1),1);

result_cloud(:,1:3)=result_cloud(:,1:3)+trans_v;

%plot
%{
plot_title = strcat('3D point cloud in camera coordinates for image ',num2str(imageNumber),'with rotation: ',num2str(omegaT),' and translation: ',mat2str(translationVector));
figure;
pcshow(result_cloud(:,1:3),result_cloud(:,4:6)/255);
title(plot_title);
xlabel('X');
ylabel('Y');
zlabel('Z');
%}

points3d=result_cloud;
end
