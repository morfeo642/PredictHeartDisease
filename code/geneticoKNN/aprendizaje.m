function [ clasificador ] = aprendizaje( ejemplosTr,  tipoKNN, KF, tipoDist )
%% Esta función obtiene el clasificador knn o un clasificador knn fuzzy a partir
% del conjunto de entrenamiento.
% @param ejemplosTr Es el conjunto de entrenamiento mediante el cual se
% aprenderá el clasificador
% @param tipoKNN Es el tipo de clasificador a aprender.
% Debe tener uno de los siguientes valores: 0 para el
% clasificador KNN y 1 para el clasificador fuzzy knn.
% @param KF Este parámetro debe especificarse si tipoKNN == 1
% Es el parámetro para KNN fuzzy que se usa para calcular los grados de
% pertenencia de los ejemplos a las clases.
% @return Devuelve el clasificador aprendido (una estructura con diferentes campos) 
% Para el caso de KNN, devuelve una matriz con los ejemplos del CE (campo CE)
% Para el KNN fuzzy se devuelve además otra matriz Nejemplos x Nclases que
% indica la pertenencia de cada ejemplo a cada clase (campo U)

    if tipoKNN == 0
        %% KNN Normal, Lazy learning, devolver el CE como clasificador
        clasificador = struct('CE', ejemplosTr);
    else
        %% KNN fuzzy, aprender las pertenencias de los ejemplos a cada clase.
		
		attrs = ejemplosTr(:,1:end-1);
		clases = ejemplosTr(:,end);
		n = size(ejemplosTr, 1); % nº de ejemplos del CE
		nc = length(unique(clases));
		
		%% Calculamos las distancias de cada ejemplo del CE al resto de ejemplos.
		if tipoDist == 0
			dists = sqrt(distEuclidea(attrs, attrs));
		else
			dists = distanciaManhattan(attrs, attrs);
		end;
		% dists(i,j) = Es la distancia del ejemplo i-esimo del CE al ejemplo j-esimo
		% del mismo conjunto.
		
		% Hacemos que dists(i,i) = Infinito, para todo i
		dists = dists + eye(n)*Inf;
		
		% Tomamos, para cada ejemplo, los KF vecinos más cercanos.
		[dists, I] = sort(dists, 2, 'ascend');
		dists = dists(:,1:KF);
		I = I(:,1:KF);
		% dists(i,j) = es la distancia del ejemplo i-esimo del CE al ejemplo j-esimo más
		% cercano a el del propio CE
		
		C = clases(I);
		aux = zeros(1,1,nc);
		aux(1,1,:) = 1:nc;
		%C = (repmat(C, [1, 1, nc]) == repmat(aux, [n, KF, 1]));
		C = bsxfun(@eq, repmat(C, [1, 1, nc]), aux);
		V = zeros(n, nc);
		V(:,:) = sum(C, 2);
		%W = repmat(1:nc, n, 1) == repmat(clases, 1, nc);
		W = bsxfun(@eq, repmat(clases, 1, nc), 1:nc);
		
		
		% Con lo calculado previamente, V(i,k) = Es el nº de ejemplos de la clase k de entre los KF
		% más cercanos al ejemplo i-esimo y
		% W(i,k) = es 1 si el ejemplo i-esimo pertence a la clase k, 0 en caso contrario.
		
		%% Calculamos las pertenencias a las clases.
		U = 0.51 * W  + 0.49 * (1/KF) * V;

		clasificador = struct('CE', ejemplosTr, 'U', U);
    end;
end

