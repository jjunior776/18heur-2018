function [path, length]=levyFlight(n, start, c, alpha)
  % n po�et po�adovan�ch krok�
  % start sou�adnice startovn� pozice
  % c �k�lovac� parametr
  % alpha parametr �pi�atosti
  % path v�sledn� cesta (vektor sou�adnic)
  % length v�sledn� d�lka cesty
  u = pi*(rand(n,1)-0.5);
  v = -log(rand(n,1));
  t = sin(alpha*u)./(cos(u).^(1/alpha));
  s = (cos((1-alpha)*u)./v).^((1-alpha)/alpha);
  steps= t.*s.*c;
  directions = randomUnitDir(n).*steps;
  directions(1,:) = start;
  path = cumsum(directions);
  length = sum(abs(steps));
end


