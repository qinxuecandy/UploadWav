function E = LEVD(I,Thr)
T=length(I);
%initialize
n=1;
E(1,1)=I(1,1);
E(1,2)=0;
E(1,3)=1;
Time_interval=0;

for t=2:T-1
    Thi=2*Time_interval/(n-1);
if ((abs(I(t,1))>abs(I(t-1,1)))&&(abs(I(t,1))>abs(I(t+1,1))))
   if (E(n,2)==1)&&((abs(t-E(n,3))<=Thi)||(Thi==0))
       if abs(I(t,1))>abs(E(n,1))
           E(n,1)=I(t,1);
           E(n,3)=t;
       end
   elseif (E(n,2)==0)||((abs(t-E(n,3))>Thi)&&(Thi~=0))
       if (abs(I(t,1)-E(n,1))>Thr)||((abs(t-E(n,3))>Thi)&&(Thi~=0))
           n=n+1;
           E(n,1)=I(t,1);
           E(n,2)=1;
           E(n,3)=t;
           Time_interval=Time_interval+E(n,3)-E(n-1,3);
       end
   end
elseif((abs(I(t,1))<abs(I(t-1,1)))&&(abs(I(t,1))<abs(I(t+1,1))))
   if (E(n,2)==0)&&((abs(t-E(n,3))<=Thi)||(Thi==0))
       if abs(I(t,1))<abs(E(n,1))
           E(n,1)=I(t,1);
           E(n,3)=t;
       end
   elseif(E(n,2)==1)||((abs(t-E(n,3))>Thi)&&(Thi~=0)) 
       if (abs(I(t,1)-E(n,1))>Thr)||((abs(t-E(n,3))>Thi)&&(Thi~=0)) 
           n=n+1;
           E(n,1)=I(t,1);
           E(n,2)=0;
           E(n,3)=t;
           Time_interval=Time_interval+E(n,3)-E(n-1,3);
       end
   end
end
end
