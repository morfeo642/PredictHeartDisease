function P = poblacionInicial(u, N)
	%% Genera una poblacion inicial de u individuos de forma aleatoria.
	P = rand(u, N)>=0.3;
end
