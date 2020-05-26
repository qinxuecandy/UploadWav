function [delta_length_1,delta_length_2]=phase_change(C,O)
x_complex=smooth(C+1i*O,500);


length_p=size(x_complex,1);
for k=1:length_p
    angle_real(k,1)=angle(x_complex(k,1));
end

num_c=0;
for k=2:length(angle_real)
    if (angle_real(k,1)<(4*num_c-1)/2*pi)&&(angle_real(k-1,1)>(4*num_c+1)/2*pi)
        num_c=num_c+1;
    
    for j=k:length_p
        angle_real(j,1)=angle_real(j,1)+2*pi;
    end
    
    elseif (angle_real(k,1)>(4*num_c+1)/2*pi)&&(angle_real(k-1,1)<(4*num_c-1)/2*pi)
        num_c=num_c-1;
    for j=k:length_p
        angle_real(j,1)=angle_real(j,1)-2*pi;
    end
    
    end
    
end

for k=2:length_p
    urd(k-1,1)=angle_real(k,1)-angle_real(k-1,1);
end



%判断角度变化趋势

%判断角度变化趋势

start_point=1;
end_point=length(urd);
bihua=1;

if (mean(urd(round(0.3*end_point):round(0.4*end_point),1))>0)&&(mean(urd(round(0.6*end_point):round(0.65*end_point),1))>0)
    bihua=0;


elseif (mean(urd(round(0.05*end_point):round(0.1*end_point),1))>0)&&(mean(urd(round(0.6*end_point):round(0.65*end_point),1))<0)
    bihua=1;


elseif (mean(urd(round(0.05*end_point):round(0.1*end_point),1))<0)&&(mean(urd(round(0.6*end_point):round(0.65*end_point),1))<0)
    bihua=2;
    
end

%先减后增
if(bihua==1)
for i=start_point:(end_point-1)
    if urd(i,1)>0
       for k=i:round(0.1*end_point)
           if mean(urd(k:k+100,1))<0
               break
           end
       end
       if k==round(0.1*end_point)
           start_point=i;
           break
       end
    end
end

for i=end_point:-1:start_point
    if urd(i,1)<0
       for k=i:-1:round(0.5*end_point)
           if mean(urd(k-100:k,1))>0
               break
           end
       end
       if k==round(0.5*end_point)
           end_point=i;
           break
       end
    end
end

for i=start_point:(end_point-1)
    if urd(i,1)*urd(i+1,1)<0
        change_point=i;
        break
    end
end
delta_length_1=-1.7/(2*pi)*(angle_real(2020+1,1)-angle_real(start_point,1));
%delta_length_1=-1.7/(2*pi)*(angle_real(change_point+1,1)-angle_real(start_point,1));
delta_length_2=-1.7/(2*pi)*(angle_real(end_point,1)-angle_real(change_point+1,1));
end

%一直减少
if (bihua==0)
for i=start_point:(end_point-1)
    if urd(i,1)>0
       for k=i:round(0.3*end_point)
           if urd(k,1)<0
               break
           end
       end
       if k==round(0.3*end_point)
           start_point=i;
           break
       end
    end
end

for i=end_point:-1:start_point
    if urd(i,1)>0
       for k=i:-1:round(0.6*end_point)
           if urd(k,1)<0
               break
           end
       end
       if k==round(0.6*end_point)
           end_point=i;
           break
       end
    end
end

delta_length_1=-1.7/(2*pi)*(angle_real(end_point+1,1)-angle_real(start_point,1));
delta_length_2=0;
end

%一直增加
if (bihua==2)
for i=start_point:(end_point-1)
    if urd(i,1)<0
       for k=i:0.3*end_point
           if urd(k,1)>0
               break
           end
       end
       if k==0.3*end_point
           start_point=i;
           break
       end
    end
end

for i=end_point:-1:start_point
    if urd(i,1)<0
       for k=i:-1:0.7*end_point
           if urd(k,1)>0
               break
           end
       end
       if k==0.7*end_point
           end_point=i;
           break
       end
    end
end

delta_length_1=0;
delta_length_2=-1.7/(2*pi)*(angle_real(end_point,1)-angle_real(start_point+1,1));
end
