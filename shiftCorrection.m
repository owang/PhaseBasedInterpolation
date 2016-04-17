%% Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!!

% Compute a shift corrected pyramid to resolve 2pi ambiguities
function corrected_pyr = shiftCorrection(pyr, pind, params)

nLevels =  spyrHt(pind);
nBands = spyrNumBands(pind);
nHighElems = prod(pind(1,:));
nLowElems = prod(pind(end,:));

% Add space for high and low pass
corrected_pyr = [zeros(nHighElems,1); pyr; zeros(nLowElems,1)];

% Start at the smallest level
for level = nLevels:-1:1
    
    % Correct this level
    corrected_level = correctLevel(corrected_pyr, pind, level, ...
        params.scale, params.limit);
    
    % Get the indices to fix and update pyramid in place
    first_band = 2 + nBands*(level-1);
    indices =  pyrBandIndices(pind,first_band);
    firstind = indices(1);
    ind = pind(first_band:first_band+nBands-1,:);
    corrected_pyr(firstind:firstind+sum(prod(ind,2))-1) = corrected_level;
end

% Remove high/lowpass
corrected_pyr = corrected_pyr(nHighElems+1:end-nLowElems);
end

% Shift correction on one level
function out_level = correctLevel(pyr, pind, level, scale, limit)

out_level=[];
nLevels =  spyrHt(pind);
nBands = spyrNumBands(pind);

% If not at the lowest level
if level < nLevels
    
    % Get level size
    dims = pind((2+nBands*(level-1)),:);
    
    for band=1:nBands
        
        % Get both pyramid levels and resize lower level to same size
        low_level_small = spyrBand(pyr,pind,level+1,band);
        low_level = imresize(low_level_small, dims, 'bilinear');
        high_level = spyrBand(pyr,pind,level,band);
                      
        % Unwrap based on the level below to avoid jumps > pi (Sec 3.2)
        unwrapped = [low_level(:)/scale, high_level(:)];
        unwrapped = myUnwrap(unwrapped, [], 2);
        high_level = unwrapped(:,2);
        high_level = reshape(high_level, dims);
                
        % Compute phase difference between the levels 
        angle_diff = atan2(sin(high_level-low_level/scale), ...
            cos(high_level-low_level/scale));
        
        % Find which pixels to shift correct (Eq 10)
        to_fix = abs(angle_diff)>pi/2;
        
        % Apply shift correction (Eq 10)
        high_level(to_fix) = low_level(to_fix)/scale;
        
        % Limit the allowed shift, (Eq 11)
        if limit > 0
            to_fix = abs(high_level) > limit*pi/scale^(nLevels-level);
            high_level(to_fix) = low_level(to_fix)/scale;
        end
        
        out_level = [out_level;high_level(:)];
    end
end

% If lowest level, don't correct anything but the max shift
if level == nLevels
    for band=1:nBands
        low_level = spyrBand(pyr,pind,level,band);
        
        % Limit the allowed shift, if too large, use value from level below
        if limit > 0
            to_fix = abs(low_level)>limit*pi/scale^(nLevels-level);
            low_level(to_fix) = 0;
        end
        
        out_level = [out_level;low_level(:)];        
    end
end
end