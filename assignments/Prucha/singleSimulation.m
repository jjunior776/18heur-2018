% vyèistìní prostøedí
clear all
clc
close all

% vstupní parametry
nSteps = 100;         % poèet krokù každého agenta
nActors = 100;        % poèet agentù vypuštìných bìhem každé migrace
e = 10;               % okolí kolem cílového bodu
c = 5;                % parametr škálování (0:inf)
alpha = 1.9;          % parametr šikmosti <0.1:2>
origin = [0,0];       % poèáteèní bod
target = [-300 452];  % cílový bod

% vykreslení poèáteèního a cílového bodu
figure
hold on
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* b','linewidth',8)

% inicializace promìnných
stop = 0;             % parametr zastavení simulace
pBestDistance = inf;  % pøedchozí nejlepší vzdálenost od cíle
start = origin;       % inicializace poèáteèního bodu
bestDistancce = inf;  % dosavadní nejlepší vzdálenost od cíle
finalPath = [ ];      % finální cesta
migrations = 0;       % poèítadlo migrací
finalLength = 0;

% simulaèní smyèka
while(stop==0)
  % vypuštìní nActors agentù
  for i=1:nActors
    % vygenerování Lévyho letu
    [path, length] = levyFlight(nSteps, start, c, alpha);
    % vzdálenost konce letu od cíle
    distance = norm(path(nSteps,:)-target);
    % nejmenší vzdálenost libovolného bodu od cíle
    stopDistance = min(sqrt(sum((path-target).^2,2)));
    % vykreslení cesty
    plot(path(:,1),path(:,2),'c-');
    
    % kontrola dosažení cíle
    if(stopDistance<e)
      bestPath = path;
      bestLength = length;
      finalPath = [finalPath ; bestPath];
      finalLength = finalLength+bestLength;
      migrations = migrations + 1;
      plot(bestPath(:,1),bestPath(:,2),'r-');
      stop=1;
      break;
    end
    
    % v dané migraci nejlepší cesta?
    if(distance<bestDistancce)
      bestDistancce = distance;
      bestPath = path;
      bestLength = length;
    end
  end
  
  % pokud nebyl dosažen cíl a zároveò byla nalezena lepší cesta (než v pøedchozí
  % migraci)
  if(stop==0 && pBestDistance>bestDistancce)
    % vykreslení nejlepší cesty a inicializace pro další migraci
    pBestDistance=bestDistancce;
    start = bestPath(nSteps,:);
    bestLength = 0;
    plot(bestPath(:,1),bestPath(:,2),'r-');
    plot(origin(1,1),origin(1,2),'* r','linewidth',8)
    plot(target(1,1),target(1,2),'* b','linewidth',8)
    finalPath = [finalPath ; bestPath];
    finalLength = finalLength+bestLength;
    migrations = migrations + 1;
    pause
  end
end

% vykreslení výsledné cesty a výpis poètu migrací
plot(finalPath(:,1),finalPath(:,2),'r');
