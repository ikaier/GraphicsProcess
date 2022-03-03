%Function to find nomalization matrix
function Normalized_matrix= find_normatrix(m)
    m_mean=mean(m);
    mx_mean=m_mean(1);
    my_mean=m_mean(2);
    m_temp=[m(:,1)-mx_mean,m(:,2)-my_mean];
    m_temp=m_temp.^2;
    m_sigma=sqrt(sum(sum(m_temp))/16);
    temp_sigma=1/m_sigma;
    mm1=diag([temp_sigma,temp_sigma,1]);
    mm2=[1 0 -mx_mean;0 1 -my_mean;0 0 1];
    Normalized_matrix=mm1*mm2;
end