function [ matConfusion ] = clasificar( clasificador, ejemplos, k, tipoKNN, tipoEj, tipoDist )
%% Esta función clasifica un conjunto de ejemplos usando un clasificador previamente
%% aprendido.
%% @param clasificador Es el clasificador
%% @param ejemplos Son los ejemplos a clasificar
%% @param k Es el parámetro para la clasificación del KNN (número de vecinos a tomar 
%% más cercanos
%% @param tipoKNN Es el tipo de KNN (0 para KNN normal y 1 para fuzzy)
%% @param tipoEj Es el tipo de ejemplos (1 si son ejemplos de CE o 0 si lo son de CT)
%% @param tipoDist 0 para distancia euclidea, y 1 para distancia manhattan
	attrsClasificador = clasificador.CE(:,1:end-1);  % Atributos de los ejemplos del clasificador
	clasesClasificador = clasificador.CE(:,end); % Clases de los ejemplos del clasificador
	
	attrsEjemplos = ejemplos(:,1:end-1); % Atributos de los ejemplos a clasificar.
	clasesEjemplos = ejemplos(:,end);
	
	n = size(clasificador.CE,1); % nº ejemplos del clasificador.
	m = size(ejemplos,1); % nº ejemplos a clasificar.
	nc = length(unique(clasesClasificador)); % nº clases
	matConfusion = zeros(nc, nc);

	%% Calculamos las distancias de cada ejemplo a los ejemplos del clasificador.
	if tipoDist == 0
		dists = distEuclidea(attrsClasificador, attrsEjemplos);
	else
		dists = distManhattan(attrsClasificador, attrsEjemplos).^2;
		dists
	end;   
	%% Si estamos clasificando ejemplos del CE, las distancias de los ejemplos a clasificar
	%% a estos mismos (porque está en el CE), serán infinitas para que no sean tomados como
	%% vecinos más cercanos.
	if tipoEj == 1
		% Nuestra matriz de distancias será cuadrada, ya que el clasificador es el CE
		dists = dists + eye(n)*Inf;
	end;
	% dists(i,j) = Es la distancia al cuadrado del ejemplo j-esimo del clasificador al ejemplo i-esimo
	% a clasificar.
	
	%% Seleccionar los k-ejemplos más cercanos.
	[dists, I] = sort(dists, 2, 'ascend');
	dists = dists(:, 1:k);
	I = I(:, 1:k);
	D = repmat(1./dists, [1, 1, nc]);
	
	% Ahora dists es una matriz Nejemplos a clasificar x k, de manera que
	% dists(i,j) = Es la distancia del ejemplo i-ésimo a clasificar al ejemplo j-esimo más cercano
	% a este de entre los ejemplos del clasificador.
	% D(i,j,k) = 1/dists(i,j)^2 para todo k
	
	% Calculamos los votos de cada clase para cada ejemplo a clasificar ponderados por las distancias.
	if tipoKNN == 0
		%% KNN Normal.
		
		C = clasesClasificador(I);

		% C(i,j) = clase del ejemplo j-ésimo (del clasificador) más cercano al ejemplo i-esimo a clasificar.
		aux = zeros(1,1,nc);
		aux(1,1,:) = 1:nc;
		
		% C = (repmat(C, [1, 1, nc]) == repmat(aux, [m, k, 1]));
		C = bsxfun(@eq, repmat(C, [1, 1, nc]), aux);
		
		% Ahora, C(i,j,k) = 1 si la clase del ejemplo j-ésimo (del clasificador) más cercano al ejemplo i-ésimo a clasificar
		% es k, 0 en caso contrario.  
		V = zeros(m, nc);
		V(:,:) = sum(D .* C, 2);
		
		%% Puede ocurrir que haya ejemplos en el conjunto de test que sean iguales a algunos ejemplos del clasificador. La distancia
		% entre estos es cero, luego el inverso del cuadrado de la distancia entre estos es infinito. 
		% Ocurre que, si existe un ejemplo a clasificar i y el ejemplo j-esimo del clasificador más cercano a este, tal que dists(i,j) == 0, es decir,
		% D(i,j,k) == Inf para todo k, entonces ocurre que, V(i,k) == Inf si k es la clase del ejemplo j-esimo, o V(i,k) == NaN en 
		% caso contrario. Para arreglar esto, hacemos que si V(i,k) == NaN -> V(i,k) = 0. Se seguirá escogiendo la clase con más votos
		V(isnan(V)) = 0;
	else
		%% KNN fuzzy
		U = clasificador.U; % Funciones de pertenencia a las clases de los ejemplos del clasificador
		% U(j,k) = Pertenencia del ejemplo j-esimo del clasificador para la clase k-esima
		
	
		aux = U(reshape(I', [], 1), :);
		U2 = permute(reshape(aux, [k, m, nc]), [2 1 3]);	
		% U2(i,j,k) = Pertenencia del ejemplo j-ésimo del clasificador más cercano al ejemplo a clasficar i-esimo, 
		% para la clase k-esima.
		
		V = zeros(m, nc);
		V(:,:) = sum(D .* U2, 2);
		V(isnan(V)) = 0;
	end;
	
	% V(i,k) = Es el nº votos de la clase k-esima en la clasificación del ejemplo i-esimo.	

	W = zeros(1,m);
	for i=1:m
		W(i) = find(max(V(i,:)) == V(i,:), 1);
	end;	
	% W(i) = Es la clase que predecimos para el ejemplo i-ésimo. Si hay un empate de
	% votos (muy improbable), se escoge una clase arbitraria entre las clases que empatan.
	
	%% Comparar la clases obtenidas mediante el clasificador con las clases reales de los nuevos ejemplos y actualizar
	%% la matriz de confusión.
	for k=1:m 
		i = clasesEjemplos(k);
		j = W(k);
		
		% La clase real del ejemplo es la clase i-ésima
		% El ejemplo se clasifica como de la clase j-ésima
		matConfusion(i,j) = matConfusion(i,j) + 1;
	end;
end

