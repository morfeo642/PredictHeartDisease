bestConfig = geneticoReglasDifusas(infoAtr, tr)


	fuzzyTrain = fuzzify(3, tr, infoAtr);
	fuzzyTest = fuzzify(3, tst, infoAtr);
	reglas = generaReglasDifusas( tr, fuzzyTrain, 3, 1 );
	reglas2 = reglas(bestConfig == 1, :);
	matConfusion= inferencia( reglas2, fuzzyTest, 'uniW',1 ,1); 
	rendimiento(matConfusion, 0)
	
	
	0.481
	bestConfig = geneticoKNN(tr)
	typeKNN = 1
	k = 16
	KF = 21
	typeDist = 1
	
	clasificador = aprendizaje(tr, typeKNN, KF, typeDist);
	matConfusion=clasificar(clasificador, tr, k, typeKNN, 1, typeDist);
	