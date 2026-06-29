clear all
i=1;
for ind_1=1:11
    if(ind_1==4 )
        a=0;
    else        
    f_n_psnr  = [ 'psnr_',int2str(ind_1),'.txt'] ;% Create Name   
    f_n_ssim  = [ 'ssim_',int2str(ind_1),'.txt'] ;% Create Name  
    fid_psnr =fopen(f_n_psnr,'r');
    fid_ssim =fopen(f_n_ssim,'r');
    psnr(i,:)=fscanf(fid_psnr,'%f',[1,93])';
    ssim(i,:)=fscanf(fid_ssim,'%f',[1,93])';
    i=i+1;
    end

end
psnr=psnr';
ssim=ssim';