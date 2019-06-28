function  E = costFunctionPID(r)

%parametry symulacji
k_start     =   4;
k_stop      =   800;

%parametry modelu
alfa1 = -1.645679;
alfa2 = 0.675125;
beta1 = 0.01098;
beta2 = 0.009632;

%wartosci poczatkowe zmiennych 
u       =   zeros(1,k_stop);
y       =   zeros(1,k_stop);
x1      =   zeros(1,k_stop);
x2      =   zeros(1,k_stop);
e       =   zeros(1,k_stop);
y_zad   =   [0.5*ones(1,k_stop/4) -0.35*ones(1,k_stop/4) 0.4*ones(1,k_stop/4) -1.2*ones(1,k_stop/4)];

r0 = r(1);
r1 = r(2);
r2 = r(3);

E = 0;

for k = k_start:k_stop    
    %model nieliniowy
    g1      = (exp(5*u(k-3))-1)/(exp(5*u(k-3))+1); 
    x1(k)   = -alfa1*x1(k-1) + x2(k-1) + beta1*g1;
    x2(k)   = -alfa2*x1(k-1) + beta2*g1;
    g2      = 1-exp(-1.5*x1(k)); 
    y(k)    = g2;
   
    e(k)=y_zad(k) - y(k);
    u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k) + u(k-1);

    if (u(k)>1)
        u(k)=1;
    end
    if (u(k)<-1)
        u(k)=-1;
    end
   
   E = E + (y_zad(k) - y(k))^2;
end

end