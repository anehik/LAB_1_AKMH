%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ALGORITMO DE TRADING USANDO UN PROMEDIO MOVIL %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%% Obteniendo los datos que seran usandos para simular el algoritmo de trading
hoy=datestr(date,23);
inicio=datestr(datenum(date)-365,23);
data = downloadValues('GRUMAB.MX',inicio,hoy,'d','history');
precios = data.AdjClose; %Seleccionar los precios de cierre

%% Algoritmo de trading basado en un promedio movil
npm = 9; %Numero de dias usados para calcular el promedio m?vil
cap = 10000*ones(size(precios)); %Capital inicial a invertir
nac = 0*ones(size(precios)); %N?mero de acciones disponibles al inicio de la simulaci?n
com = 0.0029; %Comisi?n por operaci?n

% Simulacion del algoritmo
for t = 0:size(precios,1)-npm
    pm(npm+t,1) = mean(precios(t+1:npm+t,1)); %Calculando el promedio movil
    
    if pm(npm+t,1)<precios(npm+t,1)
        % Comprar, si el promedio movil es mas grande que el precio actual
        u = floor((cap(npm+t,1))/((1+com)*precios(npm+t,1)));
    else
        % Vender, si el promedio movil es mas pequeao que el precio actual
        u = -nac(npm+t,1);
    end
    nac(npm+t+1,1) = nac(npm+t,1)+u;
    cap(npm+t+1,1) = cap(npm+t,1)-precios(npm+t,1)*u-com*precios(npm+t,1)*abs(u);
end

%% Visualizacion de los resultados
T = (1:size(precios,1))';
figure(1);
subplot(4,1,1);
plot(T,precios,'b-',T(npm:end),pm(npm:end),'r--');
title(sprintf('Promedio Movil a %d d?as',npm)),xlabel('# dias'), ylabel('precio');
legend('precio','promedio','Location','NorthEastOutside');
grid;
subplot(4,1,2);
plot(T,nac(1:end-1,1),'b-');
xlabel('# dias'), ylabel('# acciones');
legend('# acciones','Location','NorthEastOutside');
grid;
subplot(4,1,3);
plot(T,cap(1:end-1,1),'b-');
xlabel('# dias'), ylabel('$');
legend('capital','Location','NorthEastOutside');
grid;
subplot(4,1,4);
plot(T,100*(cap(1:end-1,1)+precios.*nac(1:end-1,1)-cap(1,1))/cap(1,1),'b-');
xlabel('# dias'), ylabel('rendimiento (%)');
legend('Total','Location','NorthEastOutside');
grid;