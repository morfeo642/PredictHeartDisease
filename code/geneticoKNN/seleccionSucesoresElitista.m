
function [P2, F] = seleccionSucesoresElitista(x, P, S, FP, FS)
	%% Este método selecciona los individuos que pasarán a formar parte de la siguiente generación.

	
	u = size(P,1);
		
	[F1, I1] = sort(FP, 'descend');
	[F2, I2] = sort(FS, 'descend');
	P2 = [ P(I1(1:floor(u*x)), :); S(I2(1:u-floor(u*x)), :)];
	F = [ F1(I1(1:floor(u*x)), :); F2(I2(1:u-floor(u*x)), :)];	
end;

