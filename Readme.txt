########################################################################
########################################################################
IFT Toolbox 
Demonstration - Heterogeneous Data Fusion in Raw Data Level



GUI for STTR Phase I - Linear Subspace Tracking

########################################################################
########################################################################
Control Panel: 
    		Sensors 	
			- explain the heterogeneous sensors in use
		
		Scenario Input  
			- Select the scenario to study : 3 cases, sim 1, sim 5, sim9 (Simulated Data sets from AFRL)
			- Preview the selected scenario (in Video Display window)
			- Talbe shows the scenario setting

		Heterogeneous Data Fusion
			- Select data fusion schemes: Joint sparsity Support Recovery Scheme & Joint Manifold Learning
			- Run the algorithm and Real Time to shows the estimated result (video Display window show & Error window show real time result)
			- Calculate MSE result 
			
		Rest Button	
			- Reset the Toolbox


#########################################################################
#########################################################################
How to update the estimation result to show in GUI

1 -  vehicle_est_1 & vehicle_est_2 in folder case 1/case 2/case 3

     Theses data record the estimated vehicle positions from two approaches, respectively.

     Please update this mat file based on the example data format

2 -  MSE_1 & MSE_2 in folder case 1/case 2/case 3
     
     These data record the error between the estimated position and ground truth

     Please update this mat file based on the example data format