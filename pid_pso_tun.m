close all;
clear all;
clc;

%costFunctionPID

b_lo    = -5;
b_up    = 5;

% populacja
S   = 25;

% liczba iteracji
l   = 2000;

% parametry do wyznaczania predkosci
omega   = 0.1;
fi_p    = 2.5;
fi_g    = 0.2;

% inicjalizacja
x   = zeros(S,3);   % pozycja
p   = zeros(S,3);   % najlepsza pozycja
g   = zeros(1,3);   % najlepsza pozycja dla calej populacji
v   = zeros(S,3);   % predkosc
for i = 1:S
    x(i,:)  = (b_up-b_lo).*rand(1,3)+b_lo;
    p(i,:)  = x(i,:);         
    if costFunctionPID(p(i,:)) < costFunctionPID(g)
        g   = p(i,:);
    end
    v(i,:)  = (abs(b_up-b_lo)+abs(b_up-b_lo)).*rand(1,3)-abs(b_up-b_lo);
end

% petla
for iter = 1:l
    for i = 1:S
        for d = 1:3
            r_p     = rand;
            r_g     = rand;
            v(i,d)  = omega*v(i,d)+fi_p*r_p*(p(i,d)-x(i,d))+fi_g*r_g*(g(d)-x(i,d));
        end
        x(i,:)  = x(i,:)+v(i,:);
        if costFunctionPID(x(i,:)) < costFunctionPID(p(i,:))
            p(i,:)  = x(i,:);
            if costFunctionPID(p(i,:)) < costFunctionPID(g)
                g   = p(i,:);
            end
        end
    end
    if costFunctionPID(g) <= 0.01
        break
    end
end
iter
g
E = costFunctionPID(g)