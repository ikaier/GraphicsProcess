function [result_F,Result_consensus] = RANSAC_F(I1,I2,ls_thresh,consensus_thresh,loop_num,min_pair)
[Left_points,Right_points]=SurfFeaturepoints(I1,I2);
Left_points_ori=[Left_points ones(size(Left_points,1),1)];
Right_points_ori=[Right_points ones(size(Right_points,1),1)];
%%%%%%%%%%%%%%%%%%% Pre-define data %%%%%%%%%%%%%%
threshhold=ls_thresh;
Cmin=consensus_thresh;     %threshhold of consensus size
M=loop_num;     %loop times
min_pair=min_pair;
%draw_line=zeros(1,4);

%   RANSAC 
%   Let anedge be a randon row of edges to be selected, retrive information
%   from it, and loop throuth the rest row to find support line and compute
%   the consensus list.
new_F=0;
for loop_number=1:M
    Left_points=Left_points_ori;
    Right_points=Right_points_ori;
    rando = randi([1 size(Left_points,1)],min_pair,1);
    L_point=zeros(min_pair,3);
    R_point=zeros(min_pair,3);
    for pair_index=1:min_pair
        L_point(pair_index,:)=Left_points(rando(pair_index),:);
        R_point(pair_index,:)=Right_points(rando(pair_index),:);

    end
    Left_points(rando,:)=[];
    Right_points(rando,:)=[];
    F=Find_F(L_point(:,1:2),R_point(:,1:2),true);
    consensus=[L_point R_point];
    for new_pair_index=1:size(Left_points,1)
        anotherL=Left_points(new_pair_index,:);
        anotherR=Right_points(new_pair_index,:);
        fit_sq=anotherL*F*anotherR';
        if abs(fit_sq)<=threshhold
            %Index of selected row will be added to the first column, for
            %purpose of deletion in the end.
            consensus(end+1,:)=[anotherL anotherR];
        end
    end
    %Once the test row is iterated, compute line model by using different
    %method. Then delete each line in consensus list from edges by using
    %their index.
    if size(consensus,1)>=Cmin
        new_F=Find_F(consensus(:,1:2),consensus(:,4:5),true);
        break;
    end
end
    result_F=new_F;
    Result_consensus=consensus;
end