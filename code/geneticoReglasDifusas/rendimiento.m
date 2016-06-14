function [ acc ] = rendimiento( matConfusion, medidaRendimiento )
%% Calcula el accurazy rate a partir de la matriz de confusión
%% @param matConfusion Es la matriz de confusion
%% @param medidaRendimiento Es el tipo de medida de rendimiento a utilizar. 0 para acurracy rate o 1
%% para medía geométrica. 
	m = medidaRendimiento; % 0 para acurracy rate y 1 para medía geométrica
    %acc = (1-m) * (sum(diag(matConfusion)) / sum(sum(matConfusion))) + m * (prod(diag(matConfusion) ./ sum(matConfusion,2));
	acc = (1-m) * (sum(diag(matConfusion)) / sum(sum(matConfusion))) + m * (prod(diag(matConfusion)) / prod(sum(matConfusion,2)));
end
