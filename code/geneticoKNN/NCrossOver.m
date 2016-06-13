function [S] = NCrossOver(C, n) 
	%% Esta función realiza el método de cruzamiento de N puntos entre dos cromosomas.
	% Toma como paŕametro los cromosomas a cruzar y el número de puntos de cruzamiento y
	% devuelve los hijos que resultan del cruzamiento.
	% El número de puntos de cruzamiento más 1 debe ser múltplo del tamaño del cromosoma.
	m = size(C,2);
	I = mod(floor((0:(m-1)) ./ (m/(n+1))), 2);

	S = [ C(1,:).*I + C(2,:).*(1-I); C(1,:).*(1-I) + C(2,:).*I ];
end;
