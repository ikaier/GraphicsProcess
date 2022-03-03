

%Creating frames for videos
%Too achieve the best reault, I made some translations in negative
%diection.
frame_num=9;
rotation_step=0.05;
trans_step=1000;

for i=0:frame_num
    [projectedDepthImage,projectedRGBImage]=compute_2D_projection(3,i*rotation_step,'x',[0,0,-i*trans_step]);
    figure;
    imshow(projectedRGBImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('XZ_RGB_',num2str(i),'.png'));
    figure;
    imshow(projectedDepthImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('XZ_depth_',num2str(i),'.png'));
end

for i=0:frame_num
    [projectedDepthImage,projectedRGBImage]=compute_2D_projection(3,i*rotation_step,'y',[-i*trans_step,0,0]);
    figure;
    imshow(projectedRGBImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('YX_RGB_',num2str(i),'.png'));
    figure;
    imshow(projectedDepthImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('YX_depth_',num2str(i),'.png'));
end

for i=0:frame_num
    [projectedDepthImage,projectedRGBImage]=compute_2D_projection(3,i*rotation_step,'z',[0,i*trans_step,0]);
    figure;
    imshow(projectedRGBImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('ZY_RGB_',num2str(i),'.png'));
    figure;
    imshow(projectedDepthImage);
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('ZY_depth_',num2str(i),'.png'));
end