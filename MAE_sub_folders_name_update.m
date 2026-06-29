clc; clear;

baseFolder = 'D:\Task3_adders_3_obj_s1_population_100\Task3_adders_3_obj_s1_population_100';
load(fullfile(baseFolder,'mul8_MAE_all.mat'),'T');

maeVals = T.MAE;
limits  = [10, 100, 200, 300, 700];

% Mapping storage
map_folderID    = [];
map_newSeqID    = [];
map_originalID  = [];
map_MAE         = [];
map_newFileName = {};

for k = 1:numel(limits)

    folderName    = sprintf('MAE_0_to_%d', limits(k));
    currentFolder = fullfile(baseFolder, folderName);

    files = dir(fullfile(currentFolder, 'mul8_*.m'));
    if isempty(files)
        warning('No files found in %s', currentFolder);
        continue;
    end

    % ---- First pass: read OriginalID from file content for each file ----
    fileInfo = struct('name', {}, 'path', {}, 'origID', {});
    for f = 1:numel(files)
        p = fullfile(currentFolder, files(f).name);
        txt = fileread(p);

        % Try multiple patterns (robust)
        tok = regexp(txt, 'Circuit\s*=\s*mul8_(\d+)', 'tokens', 'once');
        if isempty(tok)
            tok = regexp(txt, 'Approximate function\s+mul8_(\d+)', 'tokens', 'once');
        end
        if isempty(tok)
            % last fallback: function line (might already be renamed, so not reliable)
            tok = regexp(txt, '=\s*mul8_(\d+)\s*\(', 'tokens', 'once');
        end

        if isempty(tok)
            warning('Could not find OriginalID in file: %s', p);
            continue;
        end

        origID = str2double(tok{1});
        fileInfo(end+1).name  = files(f).name; %#ok<SAGROW>
        fileInfo(end).path    = p;
        fileInfo(end).origID  = origID;
    end

    if isempty(fileInfo)
        warning('No parsable files in %s', currentFolder);
        continue;
    end

    % Optional: sort for deterministic sequencing (by OriginalID)
    [~, order] = sort([fileInfo.origID]);
    fileInfo = fileInfo(order);

    % ---- Second pass: rename sequentially + update function name ----
    for seqID = 0:numel(fileInfo)-1

        oldPath = fileInfo(seqID+1).path;
        oldName = fileInfo(seqID+1).name;
        origID  = fileInfo(seqID+1).origID;

        newName = sprintf('mul8_%03d_%d.m', seqID, k);
        newPath = fullfile(currentFolder, newName);

        % Rename only if needed and safe
        if ~strcmpi(oldPath, newPath)
            if isfile(newPath)
                warning('Target exists (skip rename): %s', newPath);
            else
                movefile(oldPath, newPath);
            end
        end

        % Decide which file to edit
        if isfile(newPath)
            editPath = newPath;
            finalNameForMap = newName;
        else
            editPath = oldPath;
            finalNameForMap = oldName;
        end

        % Update function name inside file to match filename (without .m)
        [~, funcName, ~] = fileparts(finalNameForMap); % e.g., mul8_050_2
        txt = fileread(editPath);

        % Replace function declaration line (only once)
        txt = regexprep(txt, ...
            'function\s*\[[^\]]*\]\s*=\s*mul8_\d+(_\d+)?\s*\(', ...
            ['function [ c Area Delay Power MAE MSE] = ' funcName '('], ...
            'once');

        fid = fopen(editPath, 'w');
        fwrite(fid, txt);
        fclose(fid);

        % Save mapping (THIS is the important part)
        map_folderID(end+1,1)    = k;
        map_newSeqID(end+1,1)    = seqID;
        map_originalID(end+1,1)  = origID;
        map_MAE(end+1,1)         = maeVals(origID+1);
        map_newFileName{end+1,1} = finalNameForMap;
    end
end

MappingTable = table(map_folderID, map_newSeqID, map_originalID, map_MAE, map_newFileName, ...
    'VariableNames', {'FolderIndex','NewSequentialID','OriginalID','MAE','NewFileName'});

save(fullfile(baseFolder,'renaming_map_sequential.mat'),'MappingTable');
writetable(MappingTable, fullfile(baseFolder,'renaming_map_sequential.csv'));

disp('Done: sequential renaming + correct OriginalID mapping saved.');
