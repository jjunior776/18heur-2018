% vy�ist�n� prost�ed�
clear all
clc
close all

% vstupn� parametry
nSteps = 100;         % po�et krok� ka�d�ho agenta
nActors = 100;        % po�et agent� vypu�t�n�ch b�hem ka�d� migrace
nSimulations = 200;   % po�et simulac�
e = 10;               % okol� kolem c�lov�ho bodu
c = 5;                % parametr �k�lov�n� (0:inf)
alpha = 1.9;          % parametr �ikmosti <0.1:2>
origin = [0,0];       % po��te�n� bod
target = [-300 452];  % c�lov� bod

% inicializace promenn�ch pro z�pis v�sledk�
bestLengths = zeros(1,nSimulations);
migrations = zeros(1,nSimulations);
bestPaths = [ ];
for k=1:nSimulations
  % inicializace prom�nn�ch pro simulaci
  start = origin;
  bestDistancce = inf;
  pBestDistance = inf;
  finalPath = [ ];
  finalLength = 0;
  migration = 0;
  stop=0;
  
  % stejn� simulace jako v singleSimulation.m
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

% vykreslen� prvn�ho grafu (min graf)
figure
hold on
for k=1:nSimulations
  plot(bestPaths{k}(:,1),bestPaths{k}(:,2),'c-')    % vykreslen� v�ech cest
end
% zji�t�n� a vykreslen� v�t�ze dle nejkrat�� ura�en� vzd�lenosti
[m,lengthWinner] = min(bestLengths);
plot(bestPaths{lengthWinner}(:,1),bestPaths{lengthWinner}(:,2),'r-')
% zji�t�n� a vykreslen� v�t�ze dle nejmen��ho po�tu migrac�
[m,migrationWinner] = min(migrations);
plot(bestPaths{migrationWinner}(:,1),bestPaths{migrationWinner}(:,2),'b-')
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* g','linewidth',8)

% vykreslen� druh�ho grafu (max graf)
figure
  hold on
for k=1:nSimulations
  plot(bestPaths{k}(:,1),bestPaths{k}(:,2),'c-')
end
% zji�t�n� a vykreslen� v�t�ze dle nejdel�� ura�en� vzd�lenosti
[m,lengthWinner] = max(bestLengths);
plot(bestPaths{lengthWinner}(:,1),bestPaths{lengthWinner}(:,2),'r-')
% zji�t�n� a vykreslen� v�t�ze dle nejv�t��ho po�tu migrac�
[m,migrationWinner] = max(migrations);
plot(bestPaths{migrationWinner}(:,1),bestPaths{migrationWinner}(:,2),'b-')
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* g','linewidth',8)

% statistick� v�sledky (pr�m�r, rozptyl, minimum, maximum)
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





