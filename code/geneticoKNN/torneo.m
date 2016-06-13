function C2 = torneo(k, u, C, ps)
	%% Este método selecciona mediante el método del torneo, u progenitores de un conjunto de individuos. Para ello, se seleccionan
	% k individuos de forma aleatoria. Estos se ordenan en función de sus probabilidades y se toma el de mayor probabilidad como progenitor. Este proceso
	% se realiza repetidamente u veces.
	% @param k Determina el número de individuos a seleccionar de forma aleatoria cada vez que se escoge un progenitor.
	% @param u Es el número de progenitores a seleccionar
	% @param C Es el conjunto de individuos 
	% @param ps Son las probabilidades de cada individuo de ser escogidos como progenitores (debe ser proporcional al fitness)
	N = size(C,2);
	C2 = zeros(u, N);
	for i=1:u
		R = randperm(size(C,1), k);
		C2(i,:) = C(R(find(max(ps(R)) == ps(R), 1)), :);
	end;
end;
