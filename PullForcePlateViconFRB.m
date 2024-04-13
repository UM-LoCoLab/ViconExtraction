%This function pulls raw force plate data from an open Vicon trial
%Emma Reznick 08/25/2021
%Emma Reznick 04/04/2022 Update: Added AMTI and Kistler Plates, added
%global CoP
% Katharine Walters 02/22/2024 Update: Added Kistler stair force plates

function ForcePlate = PullForcePlateViconFRB(vicon)
deviceIDs = vicon.GetDeviceIDs; %leftFP, rightFP, LRail, RRail, AMTI1, AMTI2, AMTI3, Stair1, Stair2, Stair3, Stair4, Stair5
OutputName = {'Force' 'Moment' 'CoP'};
for i = 1:numel(deviceIDs)
    try
        DeviceName = vicon.GetDeviceDetails(deviceIDs(i));
        % disp(strcat(string(deviceIDs(i)), ' ', DeviceName))
        if contains(DeviceName, 'AMTI') 
            outputIDs = [1,2,3]; %force, moment, Cop
        elseif  contains(DeviceName, 'Handrail')
            outputIDs = 1; %force only
            ind = strfind(DeviceName, ' ');
            DeviceName(ind) = [];
        elseif contains(DeviceName, 'ForcePlate') || contains(DeviceName, 'Kistler')
            outputIDs = [1,2,3]; %force, moment, Cop
        elseif contains(DeviceName, 'Stair') 
            outputIDs = [1,2,3]; % force, moment, COP
        elseif isempty(DeviceName)
            continue
        end
        %Get Data from x,y,z components of applicable output
        for j = outputIDs
            ForcePlate.(DeviceName(find(~isspace(DeviceName)))).(OutputName{j}) = [vicon.GetDeviceChannelGlobal(deviceIDs(i),j,1)'...
                ,vicon.GetDeviceChannelGlobal(deviceIDs(i),j,2)',vicon.GetDeviceChannelGlobal(deviceIDs(i),j,3)'];
        end
    catch
        fprintf(['        Error collecting ' DeviceName '\n'])
    end
end



