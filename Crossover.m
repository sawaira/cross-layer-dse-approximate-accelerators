%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [y1, y2] = CrossoverCrossover(x1, x2,VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarSize_Add,VarMin_Add_zm, VarMax_Add_zm,VarSize_Add_zm,nVar_Mul,nVar_Add,nVar_Add_zm)

    alpha = rand(size(x1));
    
    y1 = round(alpha.*x1+(1-alpha).*x2);
    y2 = round(alpha.*x2+(1-alpha).*x1);
    y_mul=y1(1:nVar_Mul);
     for i=1:nVar_Mul
         if(y_mul(i) >VarMax)
             y_mul(i) =VarMax;
          elseif(y_mul(i) <1)
                y_mul(i) =1;
         end
    end
 y_add=y1(nVar_Mul+1:nVar_Mul+nVar_Add);
for i=1:nVar_Add
         if(y_add(i) >VarMax_Add)
             y_add(i) =VarMax_Add;
          elseif(y_add(i) <VarMin_Add)
                y_add(i) =VarMin_Add;
         end
end

 y_add_zm=y1(nVar_Mul+nVar_Add+1:nVar_Mul+2*nVar_Add);
for i=1:nVar_Add_zm
         if(y_add_zm(i) >VarMax_Add_zm)
             y_add_zm(i) =VarMax_Add_zm;
          elseif(y_add_zm(i) <VarMin_Add_zm)
                y_add_zm(i) =VarMin_Add_zm;
         end
end
   y1=[y_mul,y_add,y_add_zm]; 

     y_mul=y2(1:nVar_Mul);
     for i=1:nVar_Mul
         if(y_mul(i) >VarMax)
             y_mul(i) =VarMax;
          elseif(y_mul(i) <1)
                y_mul(i) =1;
         end
    end
 y_add=y2(nVar_Mul+1:nVar_Mul+nVar_Add);
for i=1:nVar_Add
         if(y_add(i) >VarMax_Add)
             y_add(i) =VarMax_Add;
          elseif(y_add(i) <VarMin_Add)
                y_add(i) =VarMin_Add;
         end
end
y_add_zm=y2(nVar_Mul+nVar_Add+1:nVar_Mul+2*nVar_Add);
for i=1:nVar_Add_zm
         if(y_add_zm(i) >VarMax_Add_zm)
             y_add_zm(i) =VarMax_Add_zm;
          elseif(y_add_zm(i) <VarMin_Add_zm)
                y_add_zm(i) =VarMin_Add_zm;
         end
end
   y2=[y_mul,y_add,y_add_zm]; 
    
    
    
end