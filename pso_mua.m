%% ALGORYTM PSO

function [y iter g] = pso_mua(l_i, S, omega, phi_p, phi_g, rysowanie)
% l_i - liczba iteracji
% S - liczebnosc populacji
% omega, phi_p, phi_g parametry do obliczania predkosci

% Funkcja Himmelblau'a
h = @(x)(x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2;

% Ograniczenia
ogr_d = -5;
ogr_g = 5;

% Liczba wymiarow
D = 2;

% Alokacja wektorow zwiazanych z pozycja i predkoscia
% x - pozycja; v - predkosc; p - pozycja; g - najlepsza pozycja
x = zeros(S,D);
v = zeros(S,D);
p = zeros(S,D);
g = zeros(S,D);

%% ALGORYTM PSO
% Wstepna inicjalizacja pozycji i predkosci
for i = 1:S
    % inicjalizacja losowego polozenia kazdego osobnika w roju
    x(i,:) = (ogr_g - ogr_d).*rand(1,2) + ogr_d;
    % przepisanie pozycji jako najlepszych dla osobnikow
    p(i,:) = x(i,:);
    % jezeli dana pozycja jest globolnie najlepsza(wartosc f jest najmniejsza), zapisz ja
    if (h(p(i,:)) < h(g))
        g = p(i,:);
    end
    % inicjalizacja losowej predkosci
    v(i,:) = (abs(ogr_g - ogr_d) + abs(ogr_g - ogr_d)).*rand(1,2) - abs(ogr_g - ogr_d);
end

% WLASCIWY ALGORYTM
%dla kazdej iteracji
for i = 1:l_i
    %dla kazdego osobnika
    for s = 1:S
        %dla kazdego wymiaru
        for d = 1:D
            %losuj wartosci parametrow rp i rg z zakresu 0-1
            rp = rand;
            rg = rand;
            %oblicz nowe predkosci
            v(s,d) = omega*v(s,d) + phi_p*rp*(p(s,d) - x(s,d)) + phi_g*rg*(g(d) - x(s,d));
        end
        %aktualizuj pozycje
        x(s,:) = x(s,:) + v(s,:);
        %jezeli pozycja osobnika jest lepsza aktualizuj p
        if (h(x(s,:)) < h(p(s,:)))
            p(s,:) = x(s,:);
            %jezeli pozycja jest najlepsza dla calego roju aktualizuj
            if (h(p(s,:)) < h(g))
                g = p(s,:);
            end
        end
    end
    %przerwanie poszukiwania jezeli wartosc < 1e-10
    if (h(g) < 1e-10)
        break
    end
end

y = h(g);
iter = i;

if (rysowanie == 1)
    x1p = p(:,1);
    x2p = p(:,2);
    yp = zeros(S,1);

    for k = 1:S
        yp(k) = h(p(k,:));
    end

    figure(1)
    plot3(x1p,x2p,yp,'ro');
end

end