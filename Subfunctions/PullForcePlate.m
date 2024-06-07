%This function pulls raw force plate data from an open Vicon trial
%Emma Reznick 08/25/2021
%Emma Reznick 04/04/2022 Update: Added AMTI and Kistler Plates, added
%global CoP

function ForcePlate = PullForcePlate(vicon, boolRaw)
deviceIDs = vicon.GetDeviceIDs;
for i = 1:numel(deviceIDs)
    %Get and clean device name
    [DeviceName,~,DeviceRate,outputID,~,~] = vicon.GetDeviceDetails(deviceIDs(i));
    DeviceName = cleanName(DeviceName);
    if isempty(DeviceName)
        continue;
    end
    try 
        tempTab = table;
        for j = outputID
            [OutputName, ~, DeviceUnit, ~, channelNames, channelIDs] = ...
                vicon.GetDeviceOutputDetails(deviceIDs(i),outputID(j));
            ForcePlate.(DeviceName).SampleRate = DeviceRate;
            ForcePlate.(DeviceName).Unit = DeviceUnit;
            if boolRaw && contains(OutputName,'Raw')
                ForcePlate.(DeviceName).PinNames = channelNames;
            elseif contains(OutputName,'Raw')
                continue 
            end
            
            for k = channelIDs
                tempTab = [tempTab table(vicon.GetDeviceChannelGlobal(deviceIDs(i),j,k)', 'VariableNames', convertCharsToStrings(channelNames{k}))];
            end
        end
    catch ME
        fprintf(['        Error collecting ' DeviceName '\n'])
    end
    ForcePlate.(DeviceName) = tempTab;
    clear tempTab
end
end



