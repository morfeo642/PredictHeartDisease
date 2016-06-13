function [ dists ] = distEuclidea( attrsClasificador, attrsEjemplos )
%% Calcula las distancias euclideas de cada ejemplo al nuevo ejemplo a clasificar.
% @param attrsClasificador Es una matriz con los atributos de los ejemplos del CE (una
% fila por cada ejemplo)
% @param attrsNuevoEjemplos Es una matriz con los atributos de los ejemplos a clasificar.
% @return Devuelve un matriz con las distancias euclideas (AL CUADRADO) del
% clasificador a los nuevo ejemplos.
% El elemento en la fila i-esima y en la columna j-ésima es la distancia eucilidea del 
% ejemplo a clasificar i-ésimo a el ejemplo j-esimo del clasificador.
    [n, na] = size(attrsClasificador);
    m = size(attrsEjemplos, 1);


	A = zeros(1, n, na);
	A(1,:,:) = attrsClasificador;
	A = repmat(A, [m, 1, 1]);
	% A(i, j, k) = es el atributo k-esimo del ejemplo j-ésimo del clasificador.
	
	B = zeros(m, 1, na);
	B(:,1,:) = attrsEjemplos;
	%B(i, j, k) = es el atributo k-esimo del ejemplo i-ésimo a clasificar
	%B = repmat(B, [1, n, 1]);
	%dists = sqrt(sum((A - B) .^ 2, 3));
	%dists = sqrt(sum(bsxfun(@minus, A, B).^ 2, 3));
	dists = sum(bsxfun(@minus, A, B).^ 2, 3); % Distancias euclideas al cuadrado.
end

