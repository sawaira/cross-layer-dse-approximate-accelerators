result =zeros(7,4);
for (i=1:1000)
for number=1:7;    
    f_number=mod(round(rand*1000),7)+1;  
    config(i,number)=f_number;
    fcn_name = ['mul' int2str(f_number)] % Create Name      
    fh = str2func(fcn_name)
   [m,area,delay,power]= fh(1,1)
   result(number,:)=[m,area,delay,power];
end
end