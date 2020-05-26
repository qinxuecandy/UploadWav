function S = LEVD_s(I,Thr)
T=length(I);
%initialize
n=1;
S(1,1)=I(1,1);
E(1,1)=I(1,1);
E(1,2)=0;

for t=2:T-1
if ((abs(I(t,1))>abs(I(t-1,1)))&&(abs(I(t,1))>abs(I(t+1,1))))
   if (E(n,2)==1)
       if abs(I(t,1))>abs(E(n,1))
           E(n,1)=I(t,1);
       end
   elseif (E(n,2)==0)
       if (abs(I(t,1)-E(n,1))>Thr)
           n=n+1;
           E(n,1)=I(t,1);
           E(n,2)=1;
       end
   end
elseif((abs(I(t,1))<abs(I(t-1,1)))&&(abs(I(t,1))<abs(I(t+1,1))))
   if (E(n,2)==0)
       if abs(I(t,1))<abs(E(n,1))
           E(n,1)=I(t,1);
       end
   elseif(E(n,2)==1)
       if (abs(I(t,1)-E(n,1))>Thr)
           n=n+1;
           E(n,1)=I(t,1);
           E(n,2)=0;
       end
   end
end
if n>1
    S(t,1)=0.9*S(t-1,1)+0.1*((E(n-1,1)+E(n,1))/2);
elseif n==1
    S(t,1)=0.9*S(t-1,1)+0.1*E(n,1);
end
end
S(T,1)=S(T-1,1);