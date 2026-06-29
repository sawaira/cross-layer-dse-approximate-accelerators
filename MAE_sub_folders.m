% Create MAE-based buckets and copy mul8_*.m files into separate folders
% Buckets requested:
%  1) MAE 0..10
%  2) MAE 0..100
%  3) MAE 0..200
%  4) MAE 0..300
%  5) MAE 0..700
%
% Assumes:
%  - folder contains mul8_000.m ... mul8_XXX.m
%  - you already computed maeVals and fnExists (or loaded them)

clc; clear;

folder = 'D:\Task3_adders_3_obj_s1_population_100\Task3_adders_3_obj_s1_population_100';  % <-- your folder
N = 700;  % you said you have MAE from 0 to 700

% ---- Load MAE table if you saved it, otherwise comment this out ----
% load(fullfile(folder,'mul8_MAE_all.mat'),'T');
% maeVals  = T.MAE;
% fnExists = T.FileFound;
% idx      = T.ID;

% ---- OR: if maeVals and fnExists are already in workspace, do nothing ----

% If you want this script standalone, uncomment and adapt this loader:
load(fullfile(folder,'mul8_MAE_all.mat'),'T');
maeVals  = T.MAE;
fnExists = T.FileFound;
idx      = T.ID;

% Define buckets (upper limits)
limits = [10, 100, 200, 300, 700];

% Create output folders (inside the same directory)
outDirs = strings(numel(limits),1);
for k = 1:numel(limits)
    outDirs(k) = fullfile(folder, sprintf('MAE_0_to_%d', limits(k)));
    if ~exist(outDirs(k), 'dir')
        mkdir(outDirs(k));
    end
end

% Copy files into each bucket folder
copiedCount = zeros(numel(limits),1);

for i = 0:N
    if i+1 > numel(maeVals)
        break; % safety if maeVals shorter than N+1
    end
    if ~fnExists(i+1)
        continue;
    end
    mae = maeVals(i+1);
    if isnan(mae)
        continue;
    end

    src = fullfile(folder, sprintf('mul8_%03d.m', i));
    if ~isfile(src)
        continue;
    end

    for k = 1:numel(limits)
        if mae >= 0 && mae <= limits(k)
            dst = fullfile(outDirs(k), sprintf('mul8_%03d.m', i));
            copyfile(src, dst);
            copiedCount(k) = copiedCount(k) + 1;
        end
    end
end

% Report
fprintf('\n=== Copy Summary ===\n');
for k = 1:numel(limits)
    fprintf('MAE 0..%-3d : %d files copied -> %s\n', limits(k), copiedCount(k), outDirs(k));
end
fprintf('Done.\n');
