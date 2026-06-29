
nVar_Mul = 25;             % Number of Decision Variables

VarSize_Mul = [1 nVar_Mul];   % Size of Decision Variables Matrix

nVar_Add = 24;             % Number of Decision Variables

VarSize_Add = [1 nVar_Add];   % Size of Decision Variables Matrix

VarMin = 0;          % Lower Bound of Variables
VarMax = 498;          % Upper Bound of Variables
VarMin_Add = 0;          % Lower Bound of Variables
VarMax_Add = 472;          % Upper Bound of Variables

f_number=[1:49];
[function_number,area_calc,mse_calc,power_calc,mae_calc,delay_calc]=calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add,f_number) 