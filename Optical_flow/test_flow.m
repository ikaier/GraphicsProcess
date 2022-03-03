
%{
for i=7:13
    demo_optical_flow('Backyard',i,i+1);
    pause(.01);
    fprintf('Frame: %d\n',i)
end
%}



for i=7:13
    demo_optical_flow('Backyard',i,i+1); %i+1 for subsequent frames
    frame = getframe(gcf);
    imwrite(frame.cdata, strcat('frame',num2str(i),'.png'));
    fprintf('Frame #: %d\n',i)
end

