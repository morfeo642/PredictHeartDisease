function [bestConfig] = geneticoReglasDifusas(infoAtr, data)
	%% Este método pone en ejecución un algoritmo genético para obtener la mejor configuración de
	% el algoritmo de clasificación basado en reglas difusas chi para obtener una configuración de los parámetros óptima.
	% La función de fitness que se usará en el genético, es proporcional al acuraccy rate obtenido
	% al clasificar el conjunto de train pasado como parámetro.
	% @param infoAtr Debe indicarse información de los atributos del problema (es una matriz con dos columnas)
	% La primera indica los mínimos de los atributos y la segunda los máximos.
	% @param data Es una matriz con los ejemplos (tanto de train como de test). La última fila debe indicar
	% las clases de los ejemplos.
	% @return Devuelve la mejor solución obtenida por el genético.
	
	% Cada cromosoma va a indicar que reglas van a seleccionarse (que reglas van a usarse para llevar a cabo la clasificación
	% de conjunto de entrenamiento). La base de reglas se calcula previamente a ejecutar el genético.
	
	% Aprendemos la base de reglas, con el algoritmo de chi.
	numLabels = 3;
	typeP = 1; 
	fuzzyData = fuzzify(numLabels, data, infoAtr);
	reglas = generaReglasDifusas( data, fuzzyData, numLabels, typeP );
	numReglas = size(reglas,1);
	
	% Neceesitamos tantos bits como reglas para representar el cromosoma.
	N = numReglas;
	
	
	% Debemos definir la función de fitness que MAXIMIZARÁ el genético.
	fitness = @(C) evaluaFitness(reglas, fuzzyData, C);
	
	
	% Ejecutamos el genético
	disp('Pulse enter para iniciar la ejecucion del genetico...');
	pause;
	disp('Ejecutando el algoritmo genetico...');
	tic;
	M = ejecutaGenetico(N, fitness);
	elapsedTime = toc;
	disp(sprintf('Ejecucion finalizada en %.3f segundos', elapsedTime));
	disp(sprintf('Mejor solucion obtenida (con fitness = %.3f):\n', fitness(M.bestSolution)));
	bestConfig = M.bestSolution;
end


function F =  evaluaFitness(reglas, fuzzyData, C)
	F = zeros(size(C,1),1);
	for i=1:size(C,1)
		% Seleccionamos un subconjunto de reglas, tal y como indica el cromosoma.
		reglas2 = reglas(find(C(i,:) == 1), :);
		
		% Clasificamos los ejemplos del conjunto de entrenamiento con ese subconjunto 
		% de reglas.
		typeT = 1;
		typeA = 1;
		matConfusion = inferencia( reglas2, fuzzyData, 'uniW',typeT ,typeA); 
		F(i) = rendimiento(matConfusion, 0);
	end;
end; 

