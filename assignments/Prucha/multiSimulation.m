% vyèistìní prostøedí
clear all
clc
close all

% vstupní parametry
nSteps = 100;         % poèet krokù každého agenta
nActors = 100;        % poèet agentù vypuštìných bìhem každé migrace
nSimulations = 200;   % poèet simulací
e = 10;               % okolí kolem cílového bodu
c = 5;                % parametr škálování (0:inf)
alpha = 1.9;          % parametr šikmosti <0.1:2>
origin = [0,0];       % poèáteèní bod
target = [-300 452];  % cílový bod

% inicializace promenných pro zápis výsledkù
bestLengths = zeros(1,nSimulations);
migrations = zeros(1,nSimulations);
bestPaths = [ ];
for k=1:nSimulations
  % inicializace promìnných pro simulaci
  start = origin;
  bestDistancce = inf;
  pBestDistance = inf;
  finalPath = [ ];
  finalLength = 0;
  migration = 0;
  stop=0;
  
  % stejná simulace jako v singleSimulation.m
  while(stop==0)
    for i=1:nActors
      [path, length] = levyFlight(nSteps, start, c, alpha);
      distance = norm(path(nSteps,:)-target);
      stopDistance = min(sqrt(sum((path-target).^2,2)));
      if(distance<bestDistancce)
        bestDistancce = distance;
        bestPath = path;
        bestLength = length;
      end
      if(stopDistance<e)
        bestDistancce = distance;
        bestPath = path;
        bestLength = length;
        start = bestPath(nSteps,:);
        finalPath = [finalPath ; bestPath];
        finalLength = finalLength+bestLength;
        migration = migration + 1;
        stop=1;
        break;
      end
    end
    if(stop==0 && pBestDistance>bestDistancce)
      pBestDistance=bestDistancce;
      start = bestPath(nSteps,:);
      bestLength = 0;
      migration = migration + 1;
      finalPath = [finalPath ; bestPath];
      finalLength = finalLength+bestLength;
    end    
  end
  bestPaths{k} = finalPath;
  bestLengths(k) = finalLength;
  migrations(k) = migration;
end

% vykreslení prvního grafu (min graf)
figure
hold on
for k=1:nSimulations
  plot(bestPaths{k}(:,1),bestPaths{k}(:,2),'c-')    % vykreslení všech cest
end
% zjištìní a vykreslení vítìze dle nejkratší uražené vzdálenosti
[m,lengthWinner] = min(bestLengths);
plot(bestPaths{lengthWinner}(:,1),bestPaths{lengthWinner}(:,2),'r-')
% zjištìní a vykreslení vítìze dle nejmenšího poètu migrací
[m,migrationWinner] = min(migrations);
plot(bestPaths{migrationWinner}(:,1),bestPaths{migrationWinner}(:,2),'b-')
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* g','linewidth',8)

% vykreslení druhého grafu (max graf)
figure
  hold on
for k=1:nSimulations
  plot(bestPaths{k}(:,1),bestPaths{k}(:,2),'c-')
end
% zjištìní a vykreslení vítìze dle nejdelší uražené vzdálenosti
[m,lengthWinner] = max(bestLengths);
plot(bestPaths{lengthWinner}(:,1),bestPaths{lengthWinner}(:,2),'r-')
% zjištìní a vykreslení vítìze dle nejvìtšího poètu migrací
[m,migrationWinner] = max(migrations);
plot(bestPaths{migrationWinner}(:,1),bestPaths{migrationWinner}(:,2),'b-')
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* g','linewidth',8)

% statistické výsledky (prùmìr, rozptyl, minimum, maximum)
disp('Statistika dle vzdalenosti')
disp(['Prumer: ',num2str(mean(bestLengths))])
disp(['Rozptyl: ',num2str(var(bestLengths))])
disp(['Minimum: ',num2str(min(bestLengths))])
disp(['Maximum: ',num2str(max(bestLengths))])
disp('Statistika dle migrace')
disp(['Prumer: ',num2str(mean(migrations))])
disp(['Rozptyl: ',num2str(var(migrations))])
disp(['Minimum: ',num2str(min(migrations))])
disp(['Maximum: ',num2str(max(migrations))])





