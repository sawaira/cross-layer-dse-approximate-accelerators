clear all
close all
iter=600;
pop=50;
power_file  = ['power', int2str(iter),'_', int2str(pop),'.txt']
area_file  = ['area', int2str(iter),'_', int2str(pop),'.txt']
%delay_file  = ['delay', int2str(iter),'_', 'int2str(pop)','.txt']
fid_power =fopen(power_file,'rt');
fid_area =fopen(area_file,'rt');
%fid_delay =fopen(delay_file,'rt');
%area1=fread(fid_area,1,'int16');
%power1=fread(fid_power,'int32');

area= fscanf(fid_area,'%d');
power= fscanf(fid_power,'%f');

sum_psnr=0;
sum_ssim=0;
for ind_1=1:10
if(ind_1==4)
    continue;
end
% power_file  = ['power', int2str(iter),'.txt']
%  area_file  = ['area', int2str(iter),'.txt']
%  delay_file  = ['delay', int2str(iter),'.txt']
%  mae_file  = ['mae', int2str(iter),'.txt']
psnr_file  = ['psnr_', int2str(ind_1),'_', int2str(iter),'_',int2str(pop),'.txt']
fid_psnr =fopen(psnr_file,'r');
c=fscanf(fid_psnr,'%f');
sum_psnr=sum_psnr+c(1:pop);

ssim_file  = ['ssim_', int2str(ind_1),'_', int2str(iter),'_',int2str(pop),'.txt']
fid_ssim =fopen(ssim_file,'r');
c=fscanf(fid_ssim,'%f');
sum_ssim=sum_ssim+c(1:pop);
end
average_ssim=sum_ssim/9;
average_psnr=sum_psnr/9;
area_exact=8448*25+3080*48;
power_exact=112575+1004.30*48;
area_saving=((area_exact-area)./area_exact);
power_saving=((power_exact-power)./power_exact);



QUART=max(area_saving(1:pop).*power_saving(1:pop).*average_psnr.*average_psnr)
