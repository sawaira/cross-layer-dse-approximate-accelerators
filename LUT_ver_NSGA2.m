clear all
close all
clc

tic;
iter = 100;

power_file = ['power', int2str(iter), '.txt'];
area_file  = ['area', int2str(iter), '.txt'];
delay_file = ['delay', int2str(iter), '.txt'];
mae_file   = ['mae', int2str(iter), '.txt'];

Mult = nsga2(50, iter);
save('mult_file', 'Mult');

fid_power = fopen(power_file, 'wt');
fid_area  = fopen(area_file, 'wt');
fid_delay = fopen(delay_file, 'wt');
fid_mae   = fopen(mae_file, 'wt');

size_mult_matrix = size(Mult,1);

%% -------------------------------------------------
%  STEP 1: WRITE HARDWARE COSTS
%  -------------------------------------------------
for index = 1:size_mult_matrix
    fprintf(fid_area,  '%f\n', Mult(index).Cost(1));
    fprintf(fid_mae,   '%f\n', Mult(index).Cost(2));
    fprintf(fid_power, '%f\n', Mult(index).Cost(3));

    if length(Mult(index).Cost) >= 4
        fprintf(fid_delay, '%f\n', Mult(index).Cost(4));
    else
        fprintf(fid_delay, '0\n');
    end
end

%% -------------------------------------------------
%  STEP 2: BUILD LUTs FOR ENTIRE POPULATION
%  Each candidate has 25 multipliers in 5x5 filter
%  LUT input range:
%     image pixel  = 0:255
%     Gaussian coef = [1 4 7 16 26 41]
%  To keep indexing easy, LUT size = 256 x 42
%  -------------------------------------------------

coef = [1 4 7 4 1;
        4 16 26 16 4;
        7 26 41 26 7;
        4 16 26 16 4;
        1 4 7 4 1];

unique_coef_vals = unique(coef(:));   % [1 4 7 16 26 41]
maxCoef = max(unique_coef_vals);      % 41

% LUTs{population_index, multiplier_index}
LUTs = cell(size_mult_matrix, 25);

for index = 1:size_mult_matrix
    disp(['Building LUTs for population member: ', num2str(index)])

    function_1 = Mult(index).Function;

    % Replace this with your actual "second attribute" field if needed
    % Example:
    % lut_config = Mult(index).Cost(2);
    % lut_config = Mult(index).SecondAttribute;
    lut_config = Mult(index).Position;

    for k = 1:25
        func_name = strtrim(char(function_1(k,:)));

        % Build one LUT for this multiplier
        current_lut = zeros(256, maxCoef+1);

        fh = str2func(func_name);

        for a = 0:255
            for b = unique_coef_vals'
                [prod_val, ~, ~, ~, ~] = fh(a, b);
                current_lut(a+1, b+1) = prod_val;
            end
        end


        LUTs{index, k} = current_lut;
    end
end

toc;

%% -------------------------------------------------
%  IMAGE LOOP
%  -------------------------------------------------
for ind_1 = 3:3

    if(ind_1 == 4)
        continue;
    end

    f_n = [int2str(ind_1), '.jpg'];
    figure(ind_1);

    I = imread(f_n);
    J = imnoise(I, 'speckle');

    P = rgb2gray(J);
    imshow(P);

    f_n_psnr = ['psnr_', int2str(ind_1), '_', int2str(iter), '.txt'];
    f_n_ssim = ['ssim_', int2str(ind_1), '_', int2str(iter), '.txt'];

    fid_psnr = fopen(f_n_psnr, 'w');
    fid_ssim = fopen(f_n_ssim, 'w');

    filter_exact = zeros(222,222);

    %% Exact filtering
    for im1 = 1:222
        disp(['Exact filtering row: ', num2str(im1)])
        for im2 = 1:222
            sum1 = 0;
            for s1 = 1:5
                for s2 = 1:5
                    m = double(P(im1+s1-1, im2+s2-1)) * coef(s1,s2);
                    sum1 = sum1 + m;
                end
            end
            sum1 = round(sum1/273);
            filter_exact(im1,im2) = sum1;
        end
    end

    filter_exact = uint8(filter_exact);
    figure;
    imshow(filter_exact);
    title('Exact Filter Output');

    %% Store hardware metrics
    area  = zeros(size_mult_matrix,1);
    power = zeros(size_mult_matrix,1);
    delay = zeros(size_mult_matrix,1);
    mae   = zeros(size_mult_matrix,1);

    for index = 1:size_mult_matrix
        area(index)  = Mult(index).Cost(1);
        mae(index)   = Mult(index).Cost(2);
        power(index) = Mult(index).Cost(3);

        if length(Mult(index).Cost) >= 4
            delay(index) = Mult(index).Cost(4);
        else
            delay(index) = 0;
        end
    end

    %% Preallocate outputs
    peaksnr = zeros(size_mult_matrix,1);
    ssimval = zeros(size_mult_matrix,1);

    filter_all = zeros(size_mult_matrix, 222, 222, 'uint8');

    %% Approximate filtering using LUTs
    for index = 1:size_mult_matrix
        disp(['Processing population member: ', num2str(index)])

        for im1 = 1:222
            disp(['Row: ', num2str(im1)])
            for im2 = 1:222

                sum1 = 0;
                k = 0;

                for s1 = 1:5
                    for s2 = 1:5
                        k = k + 1;

                        pixel_val = double(P(im1+s1-1, im2+s2-1));
                        coef_val  = coef(s1,s2);

                        current_lut = LUTs{index, k};
                        prod_val = current_lut(pixel_val+1, coef_val+1);

                        sum1 = sum1 + prod_val;
                    end
                end

                sum1 = (sum1/273);

                if sum1 < 0
                    sum1 = 0;
                elseif sum1 > 255
                    sum1 = 255;
                end

                filter_all(index, im1, im2) = uint8(sum1);
            end
        end

        filter3 = squeeze(filter_all(index,:,:));
        filter3 = uint8(filter3);

        [peaksnr(index), ~] = psnr(filter3, filter_exact);
        [ssimval(index), ~] = ssim(filter3, filter_exact);

        fprintf(fid_psnr, '%f\n', peaksnr(index));
        fprintf(fid_ssim, '%f\n', ssimval(index));
    end

    fclose(fid_psnr);
    fclose(fid_ssim);
end

fclose(fid_area);
fclose(fid_power);
fclose(fid_delay);
fclose(fid_mae);

%% =========================
%  PLOTS
%  =========================

figure;
scatter(area, peaksnr, 50, 'filled');
xlabel('Area');
ylabel('PSNR (dB)');
title('Area vs PSNR');
grid on;

figure;
scatter(power, peaksnr, 50, 'filled');
xlabel('Power');
ylabel('PSNR (dB)');
title('Power vs PSNR');
grid on;

[area_sorted, idx_area] = sort(area);
psnr_area_sorted = peaksnr(idx_area);

figure;
plot(area_sorted, psnr_area_sorted, '-o', 'LineWidth', 1.5);
xlabel('Area');
ylabel('PSNR (dB)');
title('Area vs PSNR Trend');
grid on;

[power_sorted, idx_power] = sort(power);
psnr_power_sorted = peaksnr(idx_power);

figure;
plot(power_sorted, psnr_power_sorted, '-o', 'LineWidth', 1.5);
xlabel('Power');
ylabel('PSNR (dB)');
title('Power vs PSNR Trend');
grid on;