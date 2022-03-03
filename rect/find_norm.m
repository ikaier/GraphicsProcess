%Fucntion to find normalized points:
function Normalized_points= find_norm(m)
    m_mean=mean(m);
    mx_mean=m_mean(1);
    my_mean=m_mean(2);
    m_temp=[m(:,1)-mx_mean,m(:,2)-my_mean];
    m_temp=m_temp.^2;
    m_sigma=sqrt(sum(sum(m_temp))/16);
    Normalized_points=[m(:,1)-mx_mean,m(:,2)-my_mean]/m_sigma;
end