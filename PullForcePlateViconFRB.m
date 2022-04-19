%This function pulls raw force plate data from an open Vicon trial
%Emma Reznick 08/25/2021
%Emma Reznick 04/04/2022 Update: Added AMTI and Kistler Plates, added
%global CoP

function ForcePlate = PullForcePlateViconFRB(vicon)
deviceIDs = vicon.GetDeviceIDs; %leftFP, rightFP, LRail, RRail, AMTI1, AMTI2, AMTI3
OutputName = {'Force' 'Moment' 'CoP'};
for i = 1:numel(deviceIDs)
    try
    DeviceName = vicon.GetDeviceDetails(deviceIDs(i));
    if contains(DeviceName, 'AMTI') || isempty(DeviceName) %Currently does not pull data from AMTI force plates
        outputIDs = [1,2,3]; %force, moment, Cop
    elseif  contains(DeviceName, 'Handrail')
        outputIDs = 1; %force only
        ind = strfind(DeviceName, ' ');
        DeviceName(ind) = [];
    elseif contains(DeviceName, 'ForcePlate') || contains(DeviceName, 'Kistler')
        outputIDs = [1,2,3]; %force, moment, Cop
    end
    
    %Get Data from x,y,z components of applicable output 
    for j = outputIDs
        ForcePlate.(DeviceName).(OutputName{j}) = [vicon.GetDeviceChannelGlobal(deviceIDs(i),j,1)'...
            ,vicon.GetDeviceChannelGlobal(deviceIDs(i),j,2)',vicon.GetDeviceChannelGlobal(deviceIDs(i),j,3)'];
    end
    catch
        disp(['Error collecting ' DeviceName])
    end
end




