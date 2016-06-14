function [bestConfig] = geneticoKNN(data)
	%% Este método pone en ejecución un algoritmo genético para obtener la mejor configuración de
	% el algoritmo de clasificación KNN para obtener una configuración de los parámetros óptima.
	% La función de fitness que se usará en el genético, es proporcional al acuraccy rate obtenido
	% al clasificar el conjunto de test pasado como parámetro (pero aplicando validación cruzada)
	% @param infoAtr Debe indicarse información de los atributos del problema (es una matriz con dos columnas)
	% La primera indica los mínimos de los atributos y la segunda los máximos.
	% @param data Es una matriz con los ejemplos (tanto de train como de test). La última fila debe indicar
	% las clases de los ejemplos.
	% @return Devuelve la mejor solución obtenida por el genético.
	
	% Necesitamos un método para codificar y decodificar un cromosoma, a una configuración del algoritmo de clasificación
	% KNN. Tendremos en consideración, varios parámetros del KNN:
	% - Usar KNN normal vs KNN difuso 
	% - Parámetro k; k € [1, 32];
	% - Parámetro KF para KNN difuso; KF € [1, 32];
	% - Calculo de distancias euclidea vs manhattan.
	% En total, son 2x32x32x2=4096 posibles configuraciones
	
	% Posibles valores que pueden tomar los parámetros del KNN
	rangeParams = struct('typeKNN', [0, 1], 'k', [1, 32], 'KF',  [1, 32], 'typeDist', [0, 1]);

	% Codificamos las configuraciones del algoritmo como cromosomas binarios de tamaño N
	N = encode(rangeParams);
	
	
	% Dividimos el dataset en M particiones de igual tamaño. Cada vez que evaluemos un cromosoma, haremos una validación
	% cruzada del algoritmo KNN con la configuración indicada por el mismo.
	m = 4;
	data = data(randperm(size(data,1),size(data,1)), :);
	particiones = cell(1,m);
	for i=1:m-1
		particiones{i} = struct( ...
			'test', data((i-1)*floor(size(data,1)/m)+1:i*floor(size(data,1)/m), :), ...
			'train', [data(1:(i-1)*floor(size(data,1)/m), :); data(i*floor(size(data,1)/m)+1:end, :)]);
	end;
	particiones{m} = struct( ...
		    'test', data((m-1)*floor(size(data,1)/m)+1:end,:), ...
			'train', data(1:(m-1)*floor(size(data,1)/m),:));
	
	% Debemos definir la función de fitness que MAXIMIZARÁ el genético.
	fitness = @(C) mean(validacionCruzada(particiones, decode(rangeParams, C)), 2);
	
	
	
	% Ejecutamos el genético
	disp('Pulse enter para iniciar la ejecucion del genetico...');
	pause;
	disp('Ejecutando el algoritmo genetico...');
	tic;
	M = ejecutaGenetico(N, fitness);
	elapsedTime = toc;
	disp(sprintf('Ejecucion finalizada en %.3f segundos', elapsedTime));
	disp(sprintf('Mejor solucion obtenida (con fitness = %.3f):\n', fitness(M.bestSolution)));
	
	bestConfig = decode(rangeParams, M.bestSolution);
    bestConfig = bestConfig{1};
end

function acc = validacionCruzada(particiones, params)
	m = length(particiones);
	acc = zeros(size(params,1), m);
	% Por cada configuración del KNN
	for j=1:size(params,1)
		% Obtenemos los parámetros de la configuración del KNN
		typeKNN = params{j}.typeKNN;
		k = params{j}.k;
		KF = params{j}.KF;
		typeDist = params{j}.typeDist;

		% Ejecutamos el algoritmo por cada partición; Aprendemos y clasificamos.
		acc = zeros(1,m);
		for k=1:m
			train = particiones{k}.train;
			test = particiones{k}.test;
			
			
			% Aprendemos el clasificador
			
			clasificador = aprendizaje( train, typeKNN, KF, typeDist );
			
			% Clasificamos los ejemplos de test.
			matConfusion = clasificar( clasificador, test, k, typeKNN, 0, typeDist);
			
			% Obtenemos el accuracy rate
			acc(j,k) = rendimiento(matConfusion, 0);
		end;
	end;
end


function N = encode(rangeParams)
	labels = fieldnames(rangeParams);
	R = zeros(length(labels),2);
	for i=1:length(labels)
		R(i,:)=rangeParams.(labels{i});
	end;
	N = sum(ceil(log2(R(:,2)-R(:,1)+1)));
end

function params = decode(rangeParams, C)
	params=cell(size(C,1),1);

	labels = fieldnames(rangeParams);

	R = zeros(length(labels),2);
	for i=1:length(labels)
		R(i,:)=rangeParams.(labels{i});
	end;

	S = ceil(log2(R(:,2)-R(:,1)+1));
	b=cumsum(S)+1;
	b=[1; b(1:end-1)];
	b=[b b+S-1];
	
	for j=1:size(C,1)		
		params{j} = struct();
		for i=1:length(labels)
			params{j}.(labels{i}) = bin2dec(int2str(C(j,b(i,1):1:b(i,2)))) + R(i,1);
		end;
	end;
end

