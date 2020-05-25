function x_process =signal_process(W)
T_change=1;
for i=1:round(0.965*length(W))
    W1(T_change,1)=W(i,1);
    T_change=T_change+1;
end
T_change=1;
for i=round(0.035*length(W1)):length(W1)
   x_process(T_change,1)=W1(i,1);
   T_change=T_change+1;
end
  


        
        