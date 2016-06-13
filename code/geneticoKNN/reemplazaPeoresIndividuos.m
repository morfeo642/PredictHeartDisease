function P2 = reemplazaPeoresIndividuos(x, P, fitness)
	%% Esta función reemplaza los x% peores individuos por cromosomas generados aleatoriamente.
	[~, I] = sort(fitness(P), 'descend');
	P2 = [P(I(1:floor(size(P,1)*x)), :); poblacionInicial(size(P,1) - floor(size(P,1)*x), size(P,2))];
end;
