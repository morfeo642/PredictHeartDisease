function fuzzySets = generateFS(min,max,num_labels)
% This function generates triangular strong partitions.
% - min: a vector containing the minimum values of the attributes.
% - max: a vector containing the maximum values of the attributes.
% - fuzzySets: this matrix stores the parameters of the triangular
% membership functions, such that fuzzySets(i,j,1) is the min point (a) of the
% triangle's base of the j-th linguistic label of the i-th attribute, 
% fuzzySets(i,j,2) is the mid point (m), and fuzzySets(i,j,3) is the max point (b).

halfBase = (max - min) ./ (num_labels - 1); % Half of the triangle's basis for each variable
halfBase = repmat(halfBase',1,num_labels); % We store them in a (NumVariables x NumLabels) matrix

fuzzySets = repmat(min',[1 num_labels 3]); % 3D matrix for storing the 3 points of the triangles

% We add the half of the base n times to the minimum, depending on the
% linguistic label and the point we want to obtain (left, mid, right).
fuzzySets(:,:,1) = bsxfun(@plus,fuzzySets(:,:,1),bsxfun(@times,(-1:num_labels-2),halfBase)); % Left point
fuzzySets(:,:,2) = bsxfun(@plus,fuzzySets(:,:,2),bsxfun(@times,(0:num_labels-1),halfBase)); % Mid point
fuzzySets(:,:,3) = bsxfun(@plus,fuzzySets(:,:,3),bsxfun(@times,(1:num_labels),halfBase)); % Right point

end