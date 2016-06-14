function [fuzzyRule] = generaReglasDifusas(train, fuzzySet, numEtiquetas, tipoPeso)
%GENERAREGLASDIFUSAS 
%   Esta funcion genera las reglas difusas a partir de unos ejemplos
%   de entrenamiento.

[m,n] = size(train);
nC = length(unique(train(:,end)));

fuzzyRule = zeros(m,(n-1)*numEtiquetas + 2);
aux = zeros(m,1);
logi = zeros(m,numEtiquetas);

for i = 1:n-1   
    s = numEtiquetas*(i-1)+1;
    e = s + numEtiquetas-1;        
    [~,aux(:,:)] = max(fuzzySet(:,s:e),[],2);
    
    for j = 1:m
        logi(j,aux(j)) = 1;
    end
    
    fuzzyRule(:,s:e) = logi;
    logi(:,:) = 0;
    
end

fuzzyRule(:,end-1) = train(:,end);
comRule = zeros(m,m); %nEjem x nRule
confRule = zeros(m,1);
fuzzySet = fuzzySet(:,1:end-1);

for i = 1:m
    aux = repmat(fuzzyRule(i,1:end-2),m,1);
    pos = aux==0;
    aux = fuzzySet.*aux;
    aux(pos) = 1;
    product = prod(aux,2);
    comRule(:,i) = product;
    
    currentClass = fuzzyRule(i,end-1);
    media = 0;
    
    if tipoPeso == 1
        for c = 1:nC
            if c~=currentClass
                media = media + sum(product(train(:,end)==c))/...
                    sum(product);
            end
        end
    end
    
    confRule(i) = sum(product(train(:,end)==currentClass))/...
        sum(product) - media*(1/(nC-1));
end

fuzzyRule(:,end) = confRule;

end

