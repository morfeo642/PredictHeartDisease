function attrsNorm = normalizar ( attrs, infoAtr )
%% Esta función normaliza un conjunto de datos mediante min-max 
% @param attrs Es una matriz con los atributos de los ejemplos a normalizar
% @param infoAtr Es una matriz con dos columnas y tantas filas como atributos.
% La primera columna indica el mínimo por cada atributo, mientras que la segunda
% indica su máximo valor.
% @return Devuelve los atributos normalizados.
	m = size(attrs, 1); % nº ejemplos.
	%attrsNorm = (attrs - repmat(infoAtr(:,1)', m, 1)) ./ repmat((infoAtr(:,2) - infoAtr(:,1))',m,1);
	attrsNorm = bsxfun(@rdivide, bsxfun(@minus, attrs, infoAtr(:,1)'), (infoAtr(:,2) - infoAtr(:,1))');
	
