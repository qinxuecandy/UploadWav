function [TP,TP1]= TPI(LEc,LEo)

%timesort
LEc(:,4)=1;
LEo(:,4)=0;
LEco=LEc;
for i=1:size(LEo,1)
    for j=1:size(LEco,1)
        if LEo(i,3)<=LEco(j,3)
            for k=size(LEco,1):-1:j
            LEco(k+1,:)=LEco(k,:);
            end
            LEco(j,:)=LEo(i,:);
            break
        end
    end
end
n_le=1;        
%Alternate
div=2;
k=3;
while(k<size(LEco,1))
    for j=k:size(LEco,1)
        if LEco(k,4)~=LEco(j,4)
            point=LEco(j,2);
            div=j;
            break
        end
    end
    if(j==size(LEco,1))&&(div~=size(LEco,1))
        break
    end
    for m=(div-1):-1:k
        if LEco(m,2)==point
            LEco_alter(n_le,:)=LEco(m,:);
            LEco_alter(n_le+1,:)=LEco(div,:);
            n_le=n_le+2;
    %        point_save=1;
            break
        end
    end
    %if(m==k)&&(point_save==0)
    %k=div;
    %else
         k=div+1;
    %end
    %point_save=0;
end
    
n_EC=0;
n_EO=0;
for i=1:size(LEco_alter,1)
    if LEco_alter(i,4)==1
        n_EC=n_EC+1;
        EC(n_EC,:)=LEco_alter(i,:);
    elseif LEco_alter(i,4)==0
        n_EO=n_EO+1;
        EO(n_EO,:)=LEco_alter(i,:);
    end
end

n_E=length(EC);
sum_inter=0;
for i=1:(n_E-1)
    sum_inter=sum_inter+EC(i+1,3)-EC(i,3);
end
Inave=sum_inter/(n_E-1);
f=1;
for i=2:n_E
    In(i,1)=EC(i,3)-EC(i-1,3);
    if In(i,1)>2*Inave
        TP(f,:)=EC(i,:);
        TP1(f,:)=EC(i-1,:);
        f=f+1;
    end
end