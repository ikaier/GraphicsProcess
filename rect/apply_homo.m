function new_image = apply_homo(I,homo)



R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
[wide,long,chan]=size(I);
new_image=zeros(wide,long,chan);
for i=1:long
    for j=1:wide
        newLocation=homo*[i j 1]';
        newLocation=newLocation/newLocation(3);
        new_i=round(newLocation(1));
        new_j=round(newLocation(2));
        if new_i<=long && new_j<=wide && new_i>0 && new_j>0
            new_image(new_j,new_i,1)=R(j,i);
            new_image(new_j,new_i,2)=G(j,i);
            new_image(new_j,new_i,3)=B(j,i);
        end
    end

end
new_image=uint8(new_image);
%end