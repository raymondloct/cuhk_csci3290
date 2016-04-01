CSCI 3290 Assignment 3 (Raymond Lo, 1155009121)

Directory:  bayesian_matting
Executable: 
	run.m
	This generates the bayesian matting of the input images and output the results as images
	
Function:
	bayesian_matting.m
	This performs basic bayesian matting given input image and trimap, outputs foreground, background and alpha
	
	bayesian_matting_2.m
	Similar to bayesian_matting.m, except that it implements K-means clustering
	
	getMeanCovar.m
	This generates the weighted average color (mu) and weighted covariance matrix (sigma), given a list of colors (v) and weights (w)
	
	initialAlpha.m
	This initializes alpha values given a trimap, it also outputs the sequence of pixels initialized
	
	solveFB.m
	This solves for the likelihood-maximizing F and B colors, it also outputs the likelihood
	
Directory:  blueScreen_matting
Executable: 
	run.m
	This generates the matting results for the three models of blue screen matting with input images, and output the results as images
	
	run_custom.m
	Similar to run.m, except it uses my own photos as inputs
	
Function:
	getBlueBg.m
	This selects the blue background from image
	
	graymatt.m
	This performs matting under model 2
	
	noblue.m
	This performs matting under model 1
	
	triangulationmatt.m
	This performs matting under model 3
	
Directory:  blueScreen_matting
Executable:
	run_pmating.m
	This generates basic poisson matting of the input images and output the results as images
	
	run_pmating_2.m
	Similar to run_pmating.m, except it implements k-neighbor search
	
	run_pmating_3.m
	Similar to run_pmating2.m, except it generates color images
	
Function:
	find_nearestFB.m 
	This finds the nearest neighbor for F and B
	
	find_nearestFB_2.m 
	Similar to find_nearestFB.m, except it finds the nearest k neighbors and uses the average
	
	poisson_equ.m
	This solves the poisson equation
	
	poissonMatte.m
	This performs the poisson matting