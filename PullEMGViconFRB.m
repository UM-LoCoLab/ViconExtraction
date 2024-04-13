%This function pulls raw EMG data from an open Vicon trial
% Katharine Walters 04/13/2024

function EMG = PullEMGViconFRB(vicon)
deviceIDs = vicon.GetDeviceIDs; %leftFP, rightFP, LRail, RRail, AMTI1, AMTI2, AMTI3, Stair1, Stair2, Stair3, Stair4, Stair5

% Find which device IDs are not labeled (all labeled devices are
% forceplates)
emg_IDs = [];
for i = 1:numel(deviceIDs)
    DeviceName = vicon.GetDeviceDetails(deviceIDs(i));
    % disp(strcat(string(deviceIDs(i)), ' ', DeviceName))
    if isempty(DeviceName)
        emg_IDs = [emg_IDs, deviceIDs(i)];
    end
end

% EMG channel is the max unlabeled channel ID ???
emg_channel = max(emg_IDs);
for j = 1:16    % Iterate through all sensor outputs
    try
        EMG.(strcat("Sensor", num2str(j))) = vicon.GetDeviceChannelGlobal(emg_channel,j,1);
    catch
        fprintf(['Error collecting EMG sensor ' num2str(j) '\n'])
    end
end



