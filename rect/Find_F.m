%Data normalization and build A
function Fun_matrix=Find_F(L,R,bool_norm)
num_points=size(L,1);
if bool_norm
    L_normed=find_norm(L);
    R_normed=find_norm(R);
    M1=find_normatrix(L); %For denomarlize
    M2=find_normatrix(R); %For denomarlize
else
    L_normed=L;
    R_normed=R;
end
A=ones(num_points,9);
for i=1:num_points
    lx=L_normed(i,1);
    ly=L_normed(i,2);
    rx=R_normed(i,1);
    ry=R_normed(i,2);
    A(i,:)=[lx*rx ly*rx rx lx*ry ly*ry ry lx ly 1];
end

%Estimate F
[U,D,V]=svd(A);
F=V(:,end);
F=reshape(F,3,3);
%Denormalization
if bool_norm
    F=M2'*F*M1;
end
%Forcing Rank 2
[U,D,V]=svd(F);
D_modified=D;
D_modified(3,3)=0;
F=U*D_modified*V';
Fun_matrix=F;
end