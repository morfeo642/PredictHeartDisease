function fuzzyData = fuzzify (NUM_LABELS,data,atts)
% This function fuzzifies the input data.
% - data: the original data to be fuzzified.
% - atts: it is a (numAtts x 2) matrix, where the first and the second 
% column are the minimum and the maximum values of each attribute respectively, 
% such that atts(i,1) is the minimum value of the i-th attribute and atts(i,2) the maximum.
% - fuzzyData: it is a (NumExamples x (numAtts*NUM_LABELS+1)) matrix, where
% fuzzyData(i,k+NUM_LABELS*(j-1)) is the membership degree of the k-th linguistic label of
% the j-th attribute of the i-th example. The last column has the class of the example

[numExamples,~] = size(data);
[numAtts,~] = size(atts);

% Crea tantas etiquetas linguisticas para cada atributo como numero de
% clases tenemos para los ejemplos.

fuzzyData = ones(numExamples,numAtts*NUM_LABELS+1).*(-1); % Pre-allocate for speed reasons

% Obtain attributes intervals
min = atts(:,1)';
max = atts(:,2)';

% Para cada atributo se genera su funcion de pertenencia triangular
% Es decir para el primer atributo los puntos x que definen su funcion de
% pertenencia para la etiqueta linguistica bajo seria triPoint(1,1,:), para
% medio triPoint(1,2,:) y para alto triPoint(1,3,:)

% Obtain the parameters of the triangular membership functions
triPoint = generateFS(min,max,NUM_LABELS);
 
% Fuzzify data
for att = 1:numAtts
   
   for label = 1:NUM_LABELS
       
       minBase = triPoint(att,label,1);
       midBase = triPoint(att,label,2);
       maxBase = triPoint(att,label,3);
        
       %Usage of trimf to fuzzify the data acording to the (a, m, b) points defining the fuzzy set
       fuzzyData(:,label+NUM_LABELS*(att-1)) = trimf2(data(:,att),[minBase midBase maxBase]);
   end

end

% Store the class of each example
fuzzyData(:,numAtts*NUM_LABELS+1) = data(:,end);
end



function Y = trimf2(X, PARAMS) 
	a = PARAMS(1);
	b = PARAMS(2);
	c = PARAMS(3);
	
	Y = (((a <= X) .* (X <= b)) .* ((X-a)/(b-a))) + (((b <= X) .* (X <= c)) .* ((c-X) / (c-b)));
end;

