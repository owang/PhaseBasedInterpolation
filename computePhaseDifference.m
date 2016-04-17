%% Phase Based View Interpolation
% This is a personal reimplementation by Oliver Wang: oliver.wang2@gmail.com
% Note: see README before using!!!

% compute shift corrected phase differences (interpolating unreliable phase
% estimates from the previous levels)
function phaseDiff = computePhaseDifference(phaseL, phaseR, pind, params)

% compute phase difference
phaseDiff = atan2(sin(phaseR-phaseL),cos(phaseR-phaseL));

% save the original phase difference for the last step
phaseDiffOriginal = phaseDiff;

% for each level of the pyramid
for i=1:size(phaseL,2)
    
    %% compute shift correction (Eq. 10,11)
    phaseDiff(:,i) =  shiftCorrection(phaseDiff(:,i), pind, params);
    
    %% unwrap phase difference to allow a smooth interpolation (Eq. 13)
    unrappedPhaseDifference = myUnwrap([phaseDiff(:,i),phaseDiffOriginal(:,i)], [], 2);
    
    %% save and go to next level
    phaseDiff(:,i) = unrappedPhaseDifference(:,2);
end

end

