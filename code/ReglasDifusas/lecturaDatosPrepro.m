function [numAtr, nClases, infoAtr, ejemplosTr, ejemplosTst, ejClase] = lecturaDatosPrepro(fTrain, fTest)
     
%lectura de los datos de entrenamiento
inFile = fopen(fTrain);
%se va a crear la base de datos (BD)
line1 = fgetl(inFile);
cont = 0;
k=1;
while (sum(strfind(line1,'@output')) == 0) && (sum(strfind(line1,'@data')) == 0)
    cont = cont + 1; %posicion del atributo
    prevLine = line1;
    line = fgetl(inFile);
    line1 = line;
    if sum(strfind(line, 'real'))==0 && sum(strfind(line, 'integer'))==0
        %el atributo es nominal
        BD(cont).nom = 1; %reflejo que es nominal
        [aux, line] = strtok(line, '{');
        line(line=='{') = [];
        line(line=='}') = [];
        n_val = length(strfind(line, ','))+1;
        BD(cont).numEL = n_val; %numero de valores diferentes del atributo
        BD(cont).maximo = n_val-1;
        BD(cont).minimo = 0;
        for j = 1:n_val
            [a, line] = strtok(line, ',');
            aux = strtok(a);
            aux(aux==' ')=[];
            BD(cont).val(j).val = aux;  %meto los diferentes valores (categorías) del atributo
        end
    else
        BD(cont).nom = 0; %reflejo que es numérico
        %para cuando trabajemos con conjuntos difusos
        BD(cont).numEL = 3; %numero de valores diferentes del atributo (vamos a emplear 3 etiquetas linguisticas para los atributos numericos)
        [aux, line] = strtok(line, '[');
        line(line=='[') = [];
        line(line==']') = [];
        [mini, line] = strtok(line, ',');
        mini = str2double(mini);
        [maxi, line] = strtok(line, ',');
        maxi = strtok(maxi);
        maxi=str2double(maxi);
        BD(cont).maximo = maxi;
        BD(cont).minimo = mini;
        if (maxi==mini)
            %como el intervalo solo tiene un único valor lo convierto a
            %atributo discreto con ese valor
            BD(cont).nom = 1;
            BD(cont).numEL = 1;
            BD(cont).maximo = 0;
            BD(cont).minimo = 0;
            BD(cont).val(1).val = sprintf('%1.1f',mini);
        end
    end
    if sum(strfind(line1, '@data')) > 0
        [aux, out] = strtok(prevLine);
    end
    k = k+1;
end

%elimino toda la información que no corresponde a los atributos del
%problema
BD(cont-1:cont) = []; 
fclose(inFile);
inFile = fopen(fTrain);
line = fgetl(inFile);
while not(strcmp(line,'@data'))
    line = fgetl(inFile);
    if sum(strfind(line, out)) > 0
        [aux, salidas] = strtok(line, '{');
        break;
    end
end
%se procesan las clases del problema
nClases = sum(salidas==',')+1;
salidas(salidas=='{')=[];
salidas(salidas=='}')=[];
for i = 1:nClases
    [aux, salidas] = strtok(salidas, ',');
    aux = strtok(aux);
    %se almacenan los valores de las clases
    Clases.val{i} = aux;
end
%avanzamos hasta la línea en la que comienzan los datos
line = fgetl(inFile);
while not(strcmp(line,'@data'))
    line = fgetl(inFile);
end
line = fgetl(inFile);
nAtributos = sum(line==',');

%creo la tabla con los datos fuzzificados en ejemplos
%creo la tabla de valores numéricos en ejemplosTr
cont = 1; % contador para la posicion en las filas de la tabla de ejemplos
while line ~= -1
    k = 1; %contador para la posicion de columna en la que almacenar el valor en la tabla
    for i=1:nAtributos
        [val, line] = strtok(line, ',');
        val(val==' ') = [];
        if BD(i).nom == 0
            %es numerico, por eso lo paso a double
            val = str2double(val);
            valAux = val;
        else
            %es categórico, por eso le asigno el número correspondiente a
            %su posisción
            for j=1:BD(i).numEL
                %comparo el valor del ejemplo con los valores que puede
                %tomar el atributo
                if (strcmp(val, BD(i).val(j).val)==1)
                    %asigno la posición
                    valAux = j-1;
                end
            end
        end
        ejemplosTr(cont,i) = valAux; 
    end
    for i = 1:nClases
        if sum(strcmp(strtok(strtok(line, ',')),Clases.val{i}))>0
            ejemplosTr(cont, nAtributos+1) = i;%en la ultima columna se almacenan las clases
        end
    end
    cont = cont + 1;
    line = fgetl(inFile);
end
fclose(inFile);

%lectura de los datos de test
inFile = fopen(fTest);
%avanzamos hasta la línea en la que comienzan los datos
line = fgetl(inFile);
while not(strcmp(line,'@data'))
    line = fgetl(inFile);
end
line = fgetl(inFile);

%creo la tabla con los datos reales de test en ejemplosTst
cont = 1; % contador para la posicion en las filas de la tabla de ejemplos
while line ~= -1
    k = 1; %contador para la posicion de columna en la que almacenar el valor en la tabla
    for i=1:nAtributos
        [val, line] = strtok(line, ',');
        val(val==' ') = [];
        if BD(i).nom == 0
            %es numerico, por eso lo paso a double
            val = str2double(val);
            valAux = val;
        else
            %es categórico, por eso le asigno el número correspondiente a
            %su posición
            for j=1:BD(i).numEL
                %comparo el valor del ejemplo con los valores que puede
                %tomar el atributo
                if (strcmp(val, BD(i).val(j).val)==1)
                    %asigno la posición
                    valAux = j-1;
                end
            end
        end
        ejemplosTst(cont,i) = valAux;
    end
    for i = 1:nClases
        if sum(strcmp(strtok(strtok(line, ',')),Clases.val{i}))>0
            ejemplosTst(cont, nAtributos+1) = i;
        end
    end
    cont = cont + 1;
    line = fgetl(inFile);
end
fclose(inFile);

infoAtr = [[BD(:).minimo]', [BD(:).maximo]'];
numAtr = size(BD,2);
nClases;
for i = 1:nClases
    ejClase(i) = sum(ejemplosTr(:,end)==i);
end

        