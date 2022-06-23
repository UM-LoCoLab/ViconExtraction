%This function pulls evetns data from an open Vicon trial
%Emma Reznick 08/25/2021
%Emma Reznick 04/04/2022 Update: added option for general events (i.e.,
%triggers/monitors)

function Events = PullEventsViconFRB(vicon,subject, eventName)


Events.LHS = vicon.GetEvents(subject, 'Left', 'Foot Strike');
Events.LTO = vicon.GetEvents(subject, 'Left', 'Foot Off');
Events.RHS = vicon.GetEvents(subject, 'Right', 'Foot Strike');
Events.RTO = vicon.GetEvents(subject, 'Right', 'Foot Off');
if isempty(Events.LHS)
    Events = rmfield(Events, 'LHS');
    disp(['        Error Collecting LHS Events']);
end
if isempty(Events.LTO)
    Events = rmfield(Events, 'LTO');
    disp(['        Error Collecting LTO Events']);
end
if isempty(Events.RHS)
    Events = rmfield(Events, 'RHS');
    disp(['        Error Collecting RHS Events']);
end
if isempty(Events.RTO)
    Events = rmfield(Events, 'RTO');
    disp(['        Error Collecting RTO Events']);
end


try
    if nargin == 3
        Events.General = vicon.GetEvents(subject, 'General', eventName);
    end
catch
    disp(['        Error Collecting ' eventName ' Events']);
end

end
