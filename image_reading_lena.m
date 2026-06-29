clear all
close all
  Mult=nsga2(80,300);
%I=imread('optic_nerve.JPEG');
I=imread('lena.PNG');
imshow(I);
P=rgb2gray(I);
%P = imnoise( P,'speckle') 
imshow(P);
nVar=9;
fid_power =fopen('power.txt','wt');
fid_area =fopen('area.txt','wt');
fid_delay =fopen('delay.txt','wt');
fid_mae =fopen('mae.txt','wt');
fid_psnr =fopen('psnr.txt','wt');
fid_ssim =fopen('ssim.txt','wt');
%Mult={1:7 1:7 1:7 1:4};
 %Mult = randi(7,1,25);
coef=[1 4 7 4 1;4 16 26 16 4;7 26 41 26 7;4 16 26 16 4;1 4 7 4 1]
% for number=1:nVar
%        % f_number=mod(round(rand*1000),7)+1; 
%     config(number)=f_number(number);  
%     
%     end
   % area_calc(index)=0;
   % mse_calc(index)=0;
  % size_mult_matrix=1;
  filter_exact=zeros(249,249);
  mul_end=25;
  tier1_add=12;
  tier2_add=6;
  tier3_add=3;
  tier4_add=2;
  tier5_add=1;
  for im1=1:249
      im1
            for im2=1:249

i=0;
sum1=0;
             for s1=1:5
             for s2=1:5
                 i=i+1;
                
                  m= (double(P(im1+s1-1,im2+s2-1)).*coef(s1,s2));
                    
             sum1=sum1 + double(m);     
             
             end
             end
         sum1=round(sum1/273);
         
         filter_exact(im1,im2)=sum1;
         
           
    
            end
        end
    
filter_exact=uint8(filter_exact);
imshow(filter_exact);
tic;

  toc;
  
  tic-toc
  for index=1:80    
       area(index)=Mult(index).Cost(1);
            power(index)=Mult(index).Cost(3);
            delay(index)=Mult(index).Cost(4);
            
  end
    area=area';
    power=power';
size_mult_matrix=size(Mult,1);
area1=zeros(size_mult_matrix);
power1=zeros(size_mult_matrix);
function_1=zeros(49+24,8);

    for index=1 : size_mult_matrix
        index
        for im1=1:249
           im1
            for im2=1:249

i=0;
sum1=0;
function_1=Mult(index).Function;
             for s1=1:5
             for s2=1:5
                 i=i+1;
                 config=Mult(index).Position;
                 
                %    fcn_name = ['mul' int2str(Mult_Set(i))] ;% Create Name      
     %  for x_config=1:mul_end   
           
%                     if(config(x_config)<10)
%         fcn_name = ['mul8_00' int2str(config(x_config))] ;% Create Name    
%         elseif(config(x_config)<100)
%         fcn_name = ['mul8_0' int2str(config(x_config))] ;% Create Name    
%         else 
%         fcn_name = ['mul8_' int2str(config(x_config))] ;% Create Name    
%                     end
         fh = str2func(char(function_1(i,:)))    ;
                     [m(i),area,delay,power,mse]= fh(P(im1+s1-1,im2+s2-1),coef(s1,s2));
                     %m(i)=uint8(m(i));
%                      if(m(i)>255)
%                          m(i)=255;
%                      end
    %   end
      %  sum1=sum1 + m(i);     
             
             end
             end
            
       i=1;
       x_tier1=0;
      i=1;
x_tier1=0;
m1_1=zeros(1,tier1_add);
m1_2=zeros(1,tier1_add);
for tier1=mul_end+1:mul_end+tier1_add
   % x_tier1
    %tier1
                   x_tier1=x_tier1+1;
%                    if(config(tier1)<10)
%                     fcn_name = ['add8_00' int2str(config(tier1))] ;% Create Name    
%                     elseif(config(tier1)<100)
%                     fcn_name = ['add8_0' int2str(config(tier1))] ;% Create Name    
%                     else 
%                     fcn_name = ['add8_' int2str(config(tier1))] ;% Create Name    
%                    end
              %      fh = str2func(fcn_name)    ;
                      fh = str2func(char(function_1(tier1,:)))    ;
                       fh2 = str2func(char(function_1(tier1+24,:)))    ;
                      
                          m1_1(i)=bitand(m(i),255);
                          m1_2(i)=floor(m(i)/256);
                           m1_1(i+1)=bitand(m(i+1),255);
                          m1_2(i+1)=floor(m(i+1)/256);
                    [m1_t11(x_tier1),area,delay,power,mse]= fh(m1_1(i),m1_1(i+1));
                    
                     [m1_t12(x_tier1),area,delay,power,mse]= fh2(m1_2(i),m1_2(i+1));
                     if(m1_t11(x_tier1)>255)
                         m1_t11(x_tier1)=bitand(m1_t11(x_tier1),255);
                         m1_t12(x_tier1)=m1_t12(x_tier1)+1;                         
                     end
                %    m1(x_tier1)= uint8(m1(x_tier1));
                   i=i+2;
       end
           
        x_tier2=0;
        i=1;
       for tier2=tier1+1:tier1+tier2_add
           fh = str2func(char(function_1(tier2,:)))    ;
            fh2 = str2func(char(function_1(tier2+24,:)))    ;
                   x_tier2=x_tier2+1;
%                    if(config(tier2)<10)
%                     fcn_name = ['add8_00' int2str(config(tier2))] ;% Create Name    
%                     elseif(config(tier2)<100)
%                     fcn_name = ['add8_0' int2str(config(tier2))] ;% Create Name    
%                     else 
%                     fcn_name = ['add8_' int2str(config(tier2))] ;% Create Name    
%                    end
                %    fh = str2func(fcn_name)    ;
                    %[m2(x_tier2),area,delay,power,mse]= fh(m1(i),m1(i+1));
                     
                    [m2_t21(x_tier2),area,delay,power,mse]= fh(m1_t11(i),m1_t11(i+1));
                    
                     [m2_t22(x_tier2),area,delay,power,mse]= fh2(m1_t12(i),m1_t12(i+1));
                     if(m2_t21(x_tier2)>255)
                         m2_t21(x_tier2)=bitand(m2_t21(x_tier2),255);
                         m2_t22(x_tier2)=m2_t22(x_tier2)+1;                         
                     end
               %     m1(x_tier1)= uint8(m1(x_tier1));
                  % m2(x_tier2)= uint8(m2(x_tier2));
                   i=i+2;
           end
                    
              x_tier3=0;
        i=1;
       for tier3=tier2+1:tier2+tier3_add
                   x_tier3=x_tier3+1;
                    fh = str2func(char(function_1(tier3,:)))    ;
                     fh2 = str2func(char(function_1(tier3+24,:)))    ;
%                    if(config(tier3)<10)
%                     fcn_name = ['add8_00' int2str(config(tier3))] ;% Create Name    
%                     elseif(config(tier3)<100)
%                     fcn_name = ['add8_0' int2str(config(tier3))] ;% Create Name    
%                     else 
%                     fcn_name = ['add8_' int2str(config(tier3))] ;% Create Name    
%                    end
               %     fh = str2func(fcn_name)    ;
                      [m3_t31(x_tier3),area,delay,power,mse]= fh(m2_t21(i),m2_t21(i+1));
                    
                     [m3_t32(x_tier3),area,delay,power,mse]= fh2(m2_t22(i),m2_t22(i+1));
                     if(m3_t31(x_tier3)>255)
                         m3_t31(x_tier3)=bitand(m3_t31(x_tier3),255);
                         m3_t32(x_tier3)=m3_t32(x_tier3)+1;                         
                     end
                    %m3(x_tier3)= uint8(m3(x_tier3));
                   i=i+2;
           end     
              
           
              i=1;    
              x_tier4=0;
           for tier4=tier3+1:tier3+tier4_add
                   x_tier4=x_tier4+1;
                    fh = str2func(char(function_1(tier4,:)))    ;
                     fh2 = str2func(char(function_1(tier4+24,:)))    ;
%                    if(config(tier4)<10)
%                     fcn_name = ['add8_00' int2str(config(tier4))] ;% Create Name    
%                     elseif(config(tier4)<100)
%                     fcn_name = ['add8_0' int2str(config(tier4))] ;% Create Name    
%                     else 
%                     fcn_name = ['add8_' int2str(config(tier4))] ;% Create Name    
%                    end
                %    fh = str2func(fcn_name)    ;
                
                  if((i+1)>3)
                   m3_t31(i+1)=m(25);
                   m3_t32(i+1)=0;                   
                    end
                
                      [m4_t41(x_tier4),area,delay,power,mse]= fh(m3_t31(i),m3_t31(i+1));
                    
                     [m4_t42(x_tier4),area,delay,power,mse]= fh2(m3_t32(i),m3_t32(i+1));
                     if(m4_t41(x_tier4)>255)
                         m4_t41(x_tier4)=bitand(m4_t41(x_tier4),255);
                         m4_t42(x_tier4)=m4_t42(x_tier4)+1;                         
                     end
                  
                   %  m4(x_tier4)= uint8(m4(x_tier4));   
                   i=i+2;
           end              
           
            i=1;  
            x_tier5=0;
           for tier5=tier4+1:tier4+tier5_add
                   x_tier5=x_tier5+1;
                    fh = str2func(char(function_1(tier5,:)))    ;
                      fh2 = str2func(char(function_1(tier5+24,:)))    ;
%                    if(config(tier5)<10)
%                     fcn_name = ['add8_00' int2str(config(tier5))] ;% Create Name    
%                     elseif(config(tier5)<100)
%                     fcn_name = ['add8_0' int2str(config(tier5))] ;% Create Name    
%                     else 
%                     fcn_name = ['add8_' int2str(config(tier5))] ;% Create Name    
%                    end
                   % fh = str2func(fcn_name)    ;
                    
     
                %    [m5(x_tier5),area,delay,power,mse]= fh(m4(i),m4(i+1));
                    
                   [m5_t51(x_tier5),area,delay,power,mse]= fh(m4_t41(i),m4_t41(i+1));
                    
                     [m5_t52(x_tier5),area,delay,power,mse]= fh2(m4_t42(i),m4_t42(i+1));
                     if(m5_t51(x_tier5)>255)
                         m5_t51(x_tier5)=bitand(m5_t51(x_tier5),255);
                         m5_t52(x_tier5)=m5_t52(x_tier5)+1;                         
                     end
                  
             %    m5(x_tier5)= uint8(m5(x_tier5));
                        
                   i=i+2;
           end    
           m5= m5_t52*256+m5_t51;
         sum1=round(m5/273);
         % sum1=round(sum1/273);
         filter(index,im1,im2)=sum1;
        
           
    
            end
        end
        
        
        
        
        filter=uint8(filter);
        filter3=zeros(249,249);
            for i=1:249
            for j=1:249
            filter3(i,j)=filter(index,i,j);
            end
            end
            filter3=uint8(filter3);
            [peaksnr(index), snr(index)] = psnr(filter3,filter_exact);
            [ssimval(index), ssimmap(:,:,index)] = ssim(filter3,filter_exact);
            area1(index)=Mult(index).Cost(1);
            power1(index)=Mult(index).Cost(3);
            
             fprintf(fid_area, '%d',Mult(index).Cost(1)); %
      
              fprintf(fid_power, '%d',Mult(index).Cost(3)); %
              fprintf(fid_mae, '%d',Mult(index).Cost(2)); %
              fprintf(fid_delay, '%d',Mult(index).Cost(4)); %
            fprintf(fid_psnr, '%d',peaksnr(index)); %
              fprintf(fid_ssim, '%d',ssimval(index)); %
              fprintf(fid_power,'\n');
              fprintf(fid_area, '\n');
              fprintf(fid_mae,'\n');
              fprintf(fid_delay,'\n');
              fprintf(fid_ssim,'\n');
              fprintf(fid_psnr,'\n');
    end
% filter=uint8(filter);
% filter3=zeros(249,249);
% for i=1:249
% for j=1:249
% filter3(i,j)=filter(1,i,j);
% end
% end
% filter3=uint8(filter3);
% [peaksnr(index), snr(index)] = psnr(filter3,filter_exact);
% % for index=1:size_mult_matrix
% %     for i=1:249
% %     for j=1:249
% %     filter3(i,j)=filter(index,i,j);
% %     end
% %     end
% %     figure(index)
% %     title(['area=']);
% %     filter4=uint8(filter3);
% %     imshow(filter4);
% % end
% %          figure(1)
% %          imshow(filter1);
% %           figure(2)
% %          imshow(filter2);
% %           figure(3)
% %          imshow(filter3);
% %            figure(4)
% %          imshow(filter4);
%          
         