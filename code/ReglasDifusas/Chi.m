clear; close all; clc;

%% ================ Lectura de Datos ======================
fdatasets = dir('datasetsImb');
nDS = size(fdatasets,1) - 2;

% Numero de conjuntos train y test
nConj = 5;

% Vamos a guardar los datos en una celda tridimensional, donde cada capa
% indica el dataset que estamos considerando, cada fila el conjunto de ese
% dataset (son 5 en total) y por ultimo cada columna los valores que
% estamos guardando nA, nC, infoAtr, tr, tst, numEjClase.
dataCell = cell(nConj, 6, nDS);

for i = 3:nDS+2
    
    s = fdatasets(i).name;
    fprintf('==============Leyendo datos de %s===============\n',s);
    
    for j = 1:nConj        
        
        [nA,nC,infoAtr,tr,tst,numEjClase] = lecturaDatos(...
            strcat('datasetsImb','/',s,'/',s,'-5-',num2str(j),'tra.dat'),...
            strcat('datasetsImb','/',s,'/',s,'-5-',num2str(j),'tst.dat'));
        
        dataCell{j,1,i-2} = nA;        
        dataCell{j,2,i-2} = nC;
        dataCell{j,3,i-2} = infoAtr;
        dataCell{j,4,i-2} = tr;
        dataCell{j,5,i-2} = tst;
        dataCell{j,6,i-2} = numEjClase;
    end
end
save('datacell.mat','dataCell');
%load('datacell.mat');

%% ================= Fuzzify ====================
% A cada conjunto (son 5) de todos los data sets, hacemos la fuzzify
% creamos una matriz fuzzyCell [nº de datasets x nº de conjuntos].
% Cada celda nos indica los valores de pertenencia para cada atributo, es
% decir tendre una matriz [nEjm x nAtr*numLabels +1], en la que la posicion
% (1,1:3) nos indica los grados de pertenencia para el ejemplo 1 con el
% primer atributo y con la etiqueta linguistica bajo, (1,4:6) para medio y
% (1,7:9) para alto. La ultima columna nos indica la clase a la que pertenece 

fuzzyCell = cell(nDS,nConj);
fuzzyTest = cell(nDS,nConj);
numLabels = 3;

for i = 1:nDS
    for j = 1:nConj
        [~, ~, infoAtr, tr, ts, ~] = dataCell{j,:,i};
        fuzzyCell{i,j} = fuzzify(numLabels,tr,infoAtr);
        fuzzyTest{i,j} = fuzzify(numLabels,ts,infoAtr);
    end
end

save('fuzzycell.mat', 'fuzzyCell');
save('fuzzytest.mat','fuzzyTest');
%load('fuzzycell.mat');
%load('fuzzytest.mat');

%% ================== Genera las reglas fuzzy ==================
fuzzyRule  = cell(nDS,nConj);

for i = 1:nDS
    for j = 1:nConj
        fuzzyRule{i,j} = generaReglasDifusas(dataCell{j,4,i},...
            fuzzyCell{i,j}, numLabels, 'penalizar');        
    end
end

save('fuzzyrule.mat', 'fuzzyRule');
%load('fuzzyrule.mat');
%% ================== Clasificacion de Test ====================

infe = cell(nDS,nConj);
% Cuando tenemos para cada regla nC pesos, es decir, un peso para cada
% clase, ponemos modeW a multiW. En otro caso, uniW.
modeW = 'uniW'; % (uniW,multiW)

for i = 1:nDS
    for j = 1:nConj
        infe{i,j} = inferencia(fuzzyRule{i,j},fuzzyTest{i,j},modeW);
    end
end

save('infe.mat', 'infe');
%load('infe.mat');