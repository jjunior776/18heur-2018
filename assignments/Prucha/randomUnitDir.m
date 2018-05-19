function v=randomUnitDir(N)
  % N po�et po�adovan�ch vektor�
  % v v�sledn� vektory v matice Nx2
  v = (2*rand(N,2)-1);
  v2=diag(v*v');
  v(:,:)=v(:,:)./sqrt(v2);
  v(1,:) = 0;
end

