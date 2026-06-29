function [function_number,area_calc,mse_calc,power_calc,mae_calc,delay_calc] = calculate_positions(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add,VarSize_Add, VarMin_Add_zm, VarMax_Add_zm,VarSize_Add_zm,nVar_Mul,nVar_Add,nVar_Add_zm,f_number) 
%(VarMin, VarMax, VarSize_Mul,VarMin_Add, VarMax_Add, VarMin_Add_zm, VarMax_Add_zm,,,,,)
function_number=zeros(35,8);

    for number=1:nVar_Mul
       % f_number=mod(round(rand*1000),7)+1; 
    config(number)=f_number(number);  
    
    end
    area_calc=0;
    mse_calc=0;
    mae_calc=0;
    power_calc=0;
    delay_calc=0;
    
    for i= 1 : nVar_Mul
        
        if(config(i)<10)
        fcn_name = ['mul8_00' int2str(config(i))] ;% Create Name    
        elseif(config(i)<100)
        fcn_name = ['mul8_0' int2str(config(i))] ;% Create Name    
        else 
        fcn_name = ['mul8_' int2str(config(i))] ;% Create Name    
        end
    fh = str2func(fcn_name)    ;
    function_number(i,:)=fcn_name;
    [m,area,delay,power,mae,mse]= fh(1,2);
    mae_calc=mae_calc+mae;
    area_calc=area_calc+area;
    mse_calc=mse_calc+mse;
    power_calc=power_calc+power;
     if(delay>delay_calc)
    delay_calc=delay;
     end
        end
    
     i=1;   
         for number=nVar_Mul+1:nVar_Add+nVar_Mul
       % f_number=mod(round(rand*1000),7)+1; 
    config_1(i)=f_number(number);  
    i=i+1;
    
         end
         i=1;
     for number=nVar_Add+nVar_Mul+1:2*nVar_Add+nVar_Mul
       % f_number=mod(round(rand*1000),7)+1; 
    config_2(i)=f_number(number);  
    i=i+1;
    
         end
         
         
         
          for i= 1 : nVar_Add
        
        if(config_1(i)<10)
        fcn_name = ['add8_00' int2str(config_1(i))] ;% Create Name    
        elseif(config_1(i)<100)
        fcn_name = ['add8_0' int2str(config_1(i))] ;% Create Name    
        else 
        fcn_name = ['add8_' int2str(config_1(i))] ;% Create Name    
        end
    fh = str2func(fcn_name)    ;
    function_number(i+25,:)=fcn_name;
    if(i==1)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=12*power;
    area=12*area;
    elseif(i==2)
    [m,area,delay,power,mae,mse]=fh(1,2);
    power=6*power;
    area=6*area;
    elseif(i==3)
    [m,area,delay,power,mae,mse]=fh(1,2);
    power=3*power;
    area=3*area;
    elseif(i==4)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=2*power;
    area=2*area;
    elseif(i==5)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=1*power;
    area=1*area;
    end
            
    mae_calc=mae_calc+ mae;
    area_calc=area_calc+ area;
    mse_calc=mse_calc+ mse;
    power_calc=power_calc+ power;
        if(delay>delay_calc)
   delay_calc=delay;
        end
          end
        
          
                   for i= 1 : nVar_Add_zm
        
        if(config_2(i)<10)
        fcn_name = ['add8_00' int2str(config_2(i))] ;% Create Name    
        elseif(config_2(i)<100)
        fcn_name = ['add8_0' int2str(config_2(i))] ;% Create Name    
        else 
        fcn_name = ['add8_' int2str(config_2(i))] ;% Create Name    
        end
    fh = str2func(fcn_name)    ;
    
    function_number(i+30,:)=fcn_name;
    if(i==1)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=12*power;
    area=12*area;
    elseif(i==2)
    [m,area,delay,power,mae,mse]=fh(1,2);
    power=6*power;
    area=6*area;
    elseif(i==3)
    [m,area,delay,power,mae,mse]=fh(1,2);
    power=3*power;
    area=3*area;
    elseif(i==4)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=2*power;
    area=2*area;
    elseif(i==5)
    [m,area,delay,power,mae,mse]= fh(1,2);
    power=1*power;
    area=1*area;
    end
    mae_calc=mae_calc+ mae;
    area_calc=area_calc+ area;
    mse_calc=mse_calc+ mse;
    power_calc=power_calc+ power;
        if(delay>delay_calc)
   delay_calc=delay;
        end
        end
end