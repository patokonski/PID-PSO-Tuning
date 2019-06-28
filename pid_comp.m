close all;
clear all;
clc;

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

%% Regulator PID nastrojony metod¹ Zieglera-Nicholsa
T=1;  
Tosc = 16.8;  %(192-24)/10    <-- uœrednione dla 10 okresów
kkr = 3.7;
k_p = 0.6*kkr;
Ti_p = 0.5*Tosc;
Td_p  = 0.125*Tosc;

% Niegasn¹ce oscylacje:
% Ti_p = inf;
% Td_p = 0;
% k_p = kkr;

% Nastawy regulatora PID w wersji dyskretnej
r2=(k_p*Td_p)/T;
r1=k_p*((T/(2*Ti_p))-((2*Td_p)/T)-1);
r0=k_p*(1+(T/(2*Ti_p))+(Td_p/T));

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

display(sprintf('Wskaznik jakosci E = %f',E))
y1 = y;
u1 = u;

disp('Nacisnij spacje aby kontynuowac');
pause;
  
%% Regulator PID nastrojony PSO
% 
%parametry regulatora obliczone w pliku "Zadanie_2_strojenie_PSO"
r0 = 1.2230
r1 = -1.4218
r2 = 0.2628

u       =   zeros(1,k_stop);
y       =   zeros(1,k_stop);
x1      =   zeros(1,k_stop);
x2      =   zeros(1,k_stop);
e       =   zeros(1,k_stop);
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

%%

figure(1) 
clf

subplot(2,1,1)
plot(y);
title('Porownanie przebiegow sygnalow wyjsciowych i wejsciowych regulatora PID nastrojonego dwoma metodami')
hold on
plot(y1,'m')
hold on
plot(y_zad,'r--')
legend('PID PSO','PID Z-N')
ylabel('y(k)')
xlabel('k');
grid on
subplot(2,1,2)
plot(u)
hold on
plot(u1,'m')
grid on
ylabel('u(k)')
xlabel('k');
