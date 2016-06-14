function results = genetico(P, fitness, probSeleccion, progenitores, cruzamiento, mutacion, sucesores, newblood, itersForConvergence, maxIter)
	%% Esta función simula la mecánica de un algoritmo genético. Los parámetros son la configuración del propio algoritmo,
	% poblacion inicial, función de fitness, métodos de cruzamiento, mutación, ...
	% El algoritmo parará cuando se haya alcanzado el número máximo de iteraciones.
	% Devuelve los siguientes valor: "lastPopulation", que espoblación de individuos de la última generación, 
	% un vector "fitnessMean" con tantos valores como iteraciones, donde el elemento i-ésimo,
	% indica el fitness medio de los inviduos de la generación i-ésima. Y otros tres vectores "fitnessMax", "fitnessMin", "fitnessVar" que indican
	% los valores de fitness máximo, mínimo y la varianza en cada iteración.
	% Un vector "mutations" indica el número de mutaciones que se han producido en cada iteración (número de individuos mutados en total en la población)
	% Estos vectores se encapsulan se devuelven en una estructura cuyo nombre es results
	% Por último, un vector "bestSolution", que almacenará el cromosoma que es la mejor solución al problema que se haya podido obtener en 
	% la ejecución del genético.
	iter = 1;
	Fmean = zeros(1,maxIter);
	Fmin = zeros(1,maxIter);
	Fmax = zeros(1,maxIter);
	Fvar = zeros(1,maxIter);
	Mn = zeros(1, maxIter);
	count = 1; 
	
	% Evaluamos la función de fitness sobre los individuos de la población.
	F = fitness(P);
	Fmean(1) = mean(F);
	Fmax(1) = max(F);
	Fmin(1) = min(F);
	Fvar(1) = var(F);
	best = P(find(F == max(F), 1), :);

	while iter <= maxIter
		fprintf('Iteracion %d...\n', iter);
		
		% Seleccionamos los progenitores. 
		C = progenitores(P, probSeleccion(F));
		
		% Cruzamos los progenitores y obtenemos descendientes.
		S = zeros(size(C));
		% Aqui suponemos que el número de progenitores seleccionados es par..
		for i=1:2:size(C,1)
			S(i:i+1,:) = cruzamiento(C(i:i+1,:)); 
		end;
		
		% Mutamos los genes de los descendientes.
		S2 = mutacion(S);
		Mn(iter) = sum(reshape(S2~=S, 1, []));
		S = S2;
		
		% Seleccionamos sucesores. Inviduos que formarán parte de la nueva generación.
		[P,F]=sucesores(P,S,F,fitness(S));
		
		% Comprobamos si el algoritmo a convergido a una solución. En tal caso, mantenemos los mejores
		% individuos (los más adaptados) en la siguiente generación, y reemplazamos los peores por cromosomas
		% tomados al azar.
		if (iter > 1) && (Fmax(iter-1) == Fmax(iter))
			count = count + 1;
			if count >= itersForConvergence
				P = newblood(P);
				count = 1;
			end;
		else
			count = 1;
		end;

		iter = iter +1;
		
		
		Fmean(iter) = mean(F);
		Fmax(iter) = max(F);
		Fmin(iter) = min(F);
		Fvar(iter) = var(F);
		
		if max(F) > fitness(best) 
			best = P(find(F == max(F), 1), :);
		end;
	end;
	
	Fmean = Fmean(1:min(iter, maxIter));
	Fmax  = Fmax(1:min(iter, maxIter));
	Fmin  = Fmin(1:min(iter, maxIter));
	Fvar = Fvar(1:min(iter, maxIter));
	Mn = Mn(1:min(iter, maxIter));

	results = struct('fitnessMean', Fmean, 'fitnessMax', Fmax, 'fitnessMin', Fmin, 'fitnessVar', Fvar, 'mutations', Mn, ...
		'lastPopulation', P, 'bestSolution', best);
end

