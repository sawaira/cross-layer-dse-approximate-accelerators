fid_power =fopen('power.txt','wt');
fid_area =fopen('area.txt','wt');
fid_delay =fopen('delay.txt','wt');
fid_mae =fopen('mae.txt','wt');
fid_psnr =fopen('psnr.txt','wt');
fid_ssim =fopen('ssim.txt','wt');
 for index=1:80
      area(index)=Mult(index).Cost(1);
            power(index)=Mult(index).Cost(3);
            delay(index)=Mult(index).Cost(4);
      fprintf(fid_area, '%d',Mult(index).Cost(1)); %
      
      fprintf(fid_power, '%d',Mult(index).Cost(3)); %
      fprintf(fid_mae, '%d',Mult(index).Cost(2)); %
      fprintf(fid_delay, '%d',Mult(index).Cost(4)); %
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
             fprintf(fid_psnr, '%d',peaksnr(index)); %
      fprintf(fid_ssim, '%d',ssimval(index)); %
      fprintf(fid_power,'\n');
      fprintf(fid_area, '\n');
      fprintf(fid_mae,'\n');
      fprintf(fid_delay,'\n');
      fprintf(fid_ssim,'\n');
      fprintf(fid_psnr,'\n');
 end