% vy�ist�n� prost�ed�
clear all
clc
close all

% vstupn� parametry
nSteps = 100;         % po�et krok� ka�d�ho agenta
nActors = 100;        % po�et agent� vypu�t�n�ch b�hem ka�d� migrace
e = 10;               % okol� kolem c�lov�ho bodu
c = 5;                % parametr �k�lov�n� (0:inf)
alpha = 1.9;          % parametr �ikmosti <0.1:2>
origin = [0,0];       % po��te�n� bod
target = [-300 452];  % c�lov� bod

% vykreslen� po��te�n�ho a c�lov�ho bodu
figure
hold on
plot(origin(1,1),origin(1,2),'* r','linewidth',8)
plot(target(1,1),target(1,2),'* b','linewidth',8)

% inicializace prom�nn�ch
stop = 0;             % parametr zastaven� simulace
pBestDistance = inf;  % p�edchoz� nejlep�� vzd�lenost od c�le
start = origin;       % inicializace po��te�n�ho bodu
bestDistancce = inf;  % dosavadn� nejlep�� vzd�lenost od c�le
finalPath = [ ];      % fin�ln� cesta
migrations = 0;       % po��tadlo migrac�
finalLength = 0;

% simula�n� smy�ka
while(stop==0)
  % vypu�t�n� nActors agent�
  for i=1:nActors
    % vygenerov�n� L�vyho letu
    [path, length] = levyFlight(nSteps, start, c, alpha);
    % vzd�lenost konce letu od c�le
    distance = norm(path(nSteps,:)-target);
    % nejmen�� vzd�lenost libovoln�ho bodu od c�le
    stopDistance = min(sqrt(sum((path-target).^2,2)));
    % vykreslen� cesty
    plot(path(:,1),path(:,2),'c-');
    
    % kontrola dosa�en� c�le
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
    
    % v dan� migraci nejlep�� cesta?
    if(distance<bestDistancce)
      bestDistancce = distance;
      bestPath = path;
      bestLength = length;
    end
  end
  
  % pokud nebyl dosa�en c�l a z�rove� byla nalezena lep�� cesta (ne� v p�edchoz�
  % migraci)
  if(stop==0 && pBestDistance>bestDistancce)
    % vykreslen� nejlep�� cesty a inicializace pro dal�� migraci
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

% vykreslen� v�sledn� cesty a v�pis po�tu migrac�
plot(finalPath(:,1),finalPath(:,2),'r');
