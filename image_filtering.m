clear all
close all
I=imread('lena.PNG');
imshow(I);
P=rgb2gray(I);
imshow(P);
nVar=9;

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
  for im1=1:249
     % im1
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
  Mult=nsga2_1(80,100);
  toc;
  
  tic-toc
  for index=1:80    
       area(index)=Mult(index).Cost(1);
            power(index)=Mult(index).Cost(2);
            delay(index)=Mult(index).Cost(3);
            
  end
    area=area';
    power=power';
size_mult_matrix=size(Mult);
    for index=1 : size_mult_matrix
        index
        for im1=1:249
            im1
            for im2=1:249

i=0;
sum1=0;
             for s1=1:5
             for s2=1:5
                 i=i+1;
                 config=Mult(index).Position;
                %    fcn_name = ['mul' int2str(Mult_Set(i))] ;% Create Name      
                   
                    if(config(i)<10)
        fcn_name = ['mul8_00' int2str(config(i))] ;% Create Name    
        elseif(config(i)<100)
        fcn_name = ['mul8_0' int2str(config(i))] ;% Create Name    
        else 
        fcn_name = ['mul8_' int2str(config(i))] ;% Create Name    
        end
                    
                    
                    fh = str2func(fcn_name)    ;
                 %   [m,area,delay,power,mse]= fh(P(im1+s1-1,im2+s2-1),coef(s1,s2));
                    
             sum1=sum1 + m;     
             
             end
             end
         sum1=round(sum1/273);
         
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
            area(index)=Mult(index).Cost(1);
            power(index)=Mult(index).Cost(3);
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
         