function [positions, tac, threshold] = CACFAR(X, PFA, RefCells, GuardCells)

% Define parameters
Length = length(X);
no_lag = floor(RefCells/2); % Number of lag cells
no_lead = ceil(RefCells/2); % Number of lead cells

DataAfterPowerLawDetector = abs(X).^2;%square law detector
alpha = RefCells*(PFA^(-1/RefCells)- 1); %16.25 CA-CFAR constant (α)


% Initiate variables
threshold = zeros(1, Length);
trigger = zeros(1, Length);
tac = 0; % trigger count


First = no_lag + GuardCells + 1; % Position of the first CUT being measured
Last = Length - no_lead - GuardCells; % Position of the last CUT being measured

for i = First: Last % Lead and lag cells

    sum_lag = sum(DataAfterPowerLawDetector(i - no_lag - GuardCells: i - GuardCells - 1));
    sum_lead = sum(DataAfterPowerLawDetector(i + GuardCells + 1: i + GuardCells + no_lead));
    avg_ref =  (sum_lag + sum_lead)/(no_lag + no_lead);

    threshold(i) = alpha*avg_ref; 
    if DataAfterPowerLawDetector(i) > threshold(i)

        tac = tac +1;
        trigger(i) = 1;

    end

end

positions = find(trigger);

end