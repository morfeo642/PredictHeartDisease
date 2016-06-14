function [ mC ] = inferencia(rulesMat, fuzzyTst, modeW)
%% Realiza la inferencia del conjunto test con las reglas
% modeW indica si tenemos un único peso por regla, o un peso por cada
% clase para una regla.

[m,n] = size(fuzzyTst);
nC = length(unique(fuzzyTst(:,end)));

if strcmp(modeW, 'uniW')
    W = rulesMat(:,end);    
    rules = rulesMat(:,1:end-2);
    C = rulesMat(:,end-1);
else
    W = rulesMat(:,end-(nC-1):end);    
    rules = rulesMat(:,1:end-(nC+1));
    C = rulesMat(:,end-nC);
end

tst = permute(fuzzyTst(:,1:end-1),[3 2 1]);
CTst = fuzzyTst(:,end);

fun = @(rules,tst) rules.*tst;
aux = bsxfun(fun,rules,tst);
aux(aux==0) = 1;

% tenemos el grado de compatibilidad de cada ejemplo con todas la reglas.
% cada dimension de la matriz mu indica el grado de compatibilidad de un
% ejemplo con las n reglas
mu = prod(aux,2);

mu = bsxfun(fun,mu,W); 

% Poderación
mu(find(mu<0.5)) = mu(mu<0.5).^2;
mu(find(mu>=0.5)) = sqrt(mu(mu>=0.5));

c = zeros(1,nC,size(mu,3));

if strcmp(modeW,'uniW')    
    for i = 1:nC
        c(1,i,:) =  sum(mu(find(C==i),1,:));
    end
else    
    c(:,:,:) = sum(mu);
end

% Tomamos los valores de la clase 1 y 2
%c1 = mu(find(C==1),1,:);
%c2 = mu(find(C==2),1,:);

%m1 = sum(c1);
%m2 = sum(c2);
c
[v,p] = max(c,[],2);

% M�ximo por columnas y despu�s m�ximo por filas
%[v0,p0] = max(mu);
%[v1,p1] = max(v0,[],2);

%p = p0(p1);
p = reshape(p,size(p,3),1);

mC = zeros(nC,nC);

for k = 1:m
    i=CTst(k);
    j=p(k);
    mC(i,j)=mC(i,j)+1;
end

end

