function [ dists ] = distEuclidea( attrsClasificador, attrsEjemplos )
%% Calcula la distancia manhattan de cada ejemplo al nuevo ejemplo a clasificar.
% @param attrsClasificador Es una matriz con los atributos de los ejemplos del CE (una
% fila por cada ejemplo)
% @param attrsNuevoEjemplos Es una matriz con los atributos de los ejemplos a clasificar.
% @return Devuelve un matriz con las distancias euclideas del
% clasificador a los nuevo ejemplos.
% El elemento en la fila i-esima y en la columna j-�sima es la distancia eucilidea del 
% ejemplo a clasificar i-�simo a el ejemplo j-esimo del clasificador.
    [n, na] = size(attrsClasificador);
    m = size(attrsEjemplos, 1);


	A = zeros(1, n, na);
	A(1,:,:) = attrsClasificador;
	A = repmat(A, [m, 1, 1]);
	% A(i, j, k) = es el atributo k-esimo del ejemplo j-�simo del clasificador.
	
	B = zeros(m, 1, na);
	B(:,1,:) = attrsEjemplos;
	%B(i, j, k) = es el atributo k-esimo del ejemplo i-�simo a clasificar

	dists = sum(abs(bsxfun(@minus, A, B)), 3);
end

