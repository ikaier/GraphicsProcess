function new_points = transfer_points(point_list,h)
for i=1:size(point_list,1)
    point_list(i,:)=h*point_list(i,:)';
    point_list(i,:)=point_list(i,:)/point_list(i,3);
end
new_points=point_list;
end