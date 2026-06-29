% close all
% clear all
% clc
% fs= 48e3;
% f1= 50000;
% f2=20000;
% coef=[-0.129464184586819,0.120008228473597,0.369480641534013,0.498182401953369,0.369480641534013,0.120008228473597,-0.129464184586819];
% coef =round(coef*2^8);
function F1 = nsga3(nPop, MaxIt)
Positions_F1_i=zeros(50000,7);
nCyl=1;
% t=0:1/fs:.01;
% m=length(t);
%t=t.*rand(1,m);
% x1=sin(2*pi*f1*t);
% x2=sin(2*pi*f2*t);
% x=x1+x2;
% x =round(x*2^8);
% y= conv(x,coef);
% k=length(x)+2*length(coef);
% %coef=coef(7:-1:1);
%  lc=length(coef);
% y1=zeros(1,k);
% y_approx=zeros(100,k);
% y_gold=zeros(1,k);
% %xm=zeros(1,length(x)+2*length(coef));
% xm=[x zeros(1,2*lc)];

iter_i=1;
nVar_Mul = 25;             % Number of Decision Variables

VarSize_Mul = [1 nVar_Mul];   % Size of Decision Variables Matrix

nVar_Add = 24;             % Number of Decision Variables

VarSize_Add = [1 nVar_Add];   % Size of Decision Variables Matrix

VarMin = 0;          % Lower Bound of Variables
VarMax = 498;          % Upper Bound of Variables
VarMin_Add = 0;          % Lower Bound of Variables
VarMax_Add = 472;          % Upper Bound of Variables

%MaxIt = 100;      % Maximum Number of Iterations

%nPop = 50;        % Population Size

pCrossover = 0.7;                         % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation = 0.4;                          % Mutation Percentage
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = .1;                    % Mutation Rate

sigma_mul = 0.1*(VarMax-VarMin);  % Mutation Step Size
sigma_add = 0.1*(VarMax_Add-VarMin_Add);  % Mutation Step Size
% Number of Objective Functions, we are taking Area and MSE as the
% objective functions
nObj =4;
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];

pop = repmat(empty_individual, nPop, 1);
%VarSize_mul=25;
%VarSize_Add=24;


for index=1:nPop
    %index
    pop(index).Position=[ round(unifrnd(VarMin, VarMax, VarSize_Mul)),round(unifrnd(VarMin_Add, VarMax_Add, VarSize_Add))];
    
    
    
    [area_calc(index),mse_calc(index),power_calc(index),mae_calc(index), delay_calc(index)] = calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add,pop(index).Position);
        %pop(index).Position=f_number_f;
end
for index=1:nPop
MA(index,:)=[area_calc(index)   mae_calc(index) power_calc(index) delay_calc(index)];
pop(index).Cost=MA(index,:);
end
[pop, F] = NonDominatedSorting(pop);

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);
% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop

for it = 1:MaxIt
    it
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position,VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add);
       [area_calc(k,1),mse_calc(k,1),power_calc(k,1),mae_calc(k,1) delay_calc(k,1)] = calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add,popc(k,1).Position);
         popc(k, 1).Cost =[area_calc(k,1)  mae_calc(k,1) power_calc(k,1) delay_calc(k,1)]  ;
[area_calc(k,2),mse_calc(k,2),power_calc(k,2),mae_calc(k,2) delay_calc(k,2)] = calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add,popc(k,2).Position);
  popc(k, 2).Cost =[area_calc(k,2)   mae_calc(k,2) power_calc(k,2) delay_calc(k,2)]  ;    

        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        
        i = randi([1 nPop]);
        p = pop(i);
        %mu=1;
        popm(k).Position = round(Mutate(p.Position, mu, sigma_mul,sigma_add,VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add));
        [area_calc(k),mse_calc(k),power_calc(k),mae_calc(k), delay_calc(k)] = calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,nVar_Mul,nVar_Add,popm(k).Position);
        popm(k).Cost = [area_calc(k) mae_calc(k) power_calc(k) delay_calc(k)];%CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1});
    
    Costs = [F1.Cost];
    Positions_F1=[F1.Position];
        m=length(Costs);
  k_ind=1
  iter_i=1;
    for i=1:4:m
     %   if(Costs(i+1)<500 && Costs(i)<8.8e4 && Costs(i+2)< 4.08e4 )
        Costs_disp(iter_i,1)=Costs(i);
        Costs_disp(iter_i,2)=Costs(i+1);
        Costs_disp(iter_i,3)=Costs(i+2);
        Positions_F1_i(iter_i,:)=Positions_F1((k_ind-1)*7+1:(k_ind-1)*7+7);
        
        iter_i=iter_i+1;
      %  end
        k_ind=k_ind+1;
        
    end
     iter_i=iter_i-1;
    Costs_disp1=Costs_disp';
       plot3(Costs_disp1(1,:), Costs_disp1(2, :),Costs_disp1(3, :), 'r*', 'MarkerSize', 4);
  % pause(0.01);
 %   hold on
end
  Costs_disp=Costs_disp';
%plot3(Costs_disp(1,:),Costs_disp(2,:),Costs_disp(3,:))
 plot3(Costs_disp(1, :), Costs_disp(2, :),Costs_disp(3, :), 'r*', 'MarkerSize', 4);
    xlabel('Area');
    ylabel('MAE');
    zlabel('Power');
end
%% Results



    
    






    