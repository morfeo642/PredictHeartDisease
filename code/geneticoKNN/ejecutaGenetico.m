function M = ejecutaGenetico(N, fitness)
	%% Ejecuta un genético, donde la represenación de los cromosomas es binaria (los genes pueden tomar valores entre 0 y 1)
	% N es el número de genes por cromosoma. Y fitness, es la función de fitness a utilizar.
	% Este método devuelve los resultados de la ejecución del genético.
	
	% Tamaño de la población inicial
	M = 12;

	%% Inicializamos la población de individuos de forma aleatoria
	P = poblacionInicial(M, N);

	%% Necesitamos un método de asignación de probabilidades para los individuos de la población (probabilidad de ser escogido
	% como progenitor)
	probSeleccion = @(F) bsxfun(@rdivide, F, sum(F)); % Prob. selección proporcional al ajuste

	%% También estableceremos la forma en la que seleccionamos a los progenitores en base a las probabilidades calculadas..

	%progenitores = @(C, ps) ruleta(size(C,1), C, ps); % Selección de progenitores basado en la ruleta.
	progenitores = @(C, ps) torneo(3, size(C,1), C, ps); % Selección basada en el método del torneo


	%% El siguiente método determinará como generamos hijos a partir de los progenitores seleccionados (método de cruzamiento)
	cruzamiento = @(C) NCrossOver(C, 2);

	%% Método para mutar individuos de la población.
	mutacion = @(C) mutacionSimple(0.05, C);
	%mutacion = @(C) C; % Sin mutación

	%% Por último, de que manera seleccionaremos los individuos de la población para formar la siguiente generación.
	sucesores = @(P, S, FP, FS) seleccionSucesoresElitista(0.4, P, S, FP, FS); % Método para seleccionar hijos pero mantener individuos mejores adaptados.
	%sucesores = @(P, S) S; % Reemplazamiento generacional, la nueva generación de individuos estará compuesta solo por los hijos generados

	%% Numero de iteraciones máximo a realizar por el genético.
	maxIter = 40;

	%% Esta parámetro determina el nº iteraciones necesario para que, si no se ha obtenido un mejor resultado (cromosoma con mayor fitness), 
	% durante esas iteracinoes, el algoritmo finalize
	itersForConvergence = 10;

	%% El siguiente método será usado para reemplazar una proporción de individuos peor adaptados por cromosomas creados
	% aleatoriamente (se usa cuando el algoritmo converge, para añadir más diversidad)
	newblood = @(P) reemplazaPeoresIndividuos(0.3, P, fitness);

	%% Lanzamos el genético con la configuración indicada.
	[M] = genetico(P, fitness, probSeleccion, progenitores, ... 
	cruzamiento, mutacion, sucesores, newblood, itersForConvergence, maxIter );




end;
