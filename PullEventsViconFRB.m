%This function pulls evetns data from an open Vicon trial
%Emma Reznick 08/25/2021
%Emma Reznick 04/04/2022 Update: added option for general events (i.e.,
%triggers/monitors)
%Emma Reznick 02/15/2023 Update: added option multiple general events in
%comma serparated list

function Events = PullEventsViconFRB(vicon,subject, eventName)


Events.LHS = vicon.GetEvents(subject, 'Left', 'Foot Strike');
Events.LTO = vicon.GetEvents(subject, 'Left', 'Foot Off');
Events.RHS = vicon.GetEvents(subject, 'Right', 'Foot Strike');
Events.RTO = vicon.GetEvents(subject, 'Right', 'Foot Off');
if isempty(Events.LHS)
    Events = rmfield(Events, 'LHS');
    fprintf(['        Error Collecting LHS Events\n']);
end
if isempty(Events.LTO)
    Events = rmfield(Events, 'LTO');
    fprintf(['        Error Collecting LTO Events\n']);
end
if isempty(Events.RHS)
    Events = rmfield(Events, 'RHS');
    fprintf(['        Error Collecting RHS Events\n']);
end
if isempty(Events.RTO)
    Events = rmfield(Events, 'RTO');
    fprintf(['        Error Collecting RTO Events\n']);
end


if ~isempty(eventName)
    if contains(eventName, ',')
        events = split(eventName,',');
        for n = 1:numel(events)
            events{n} = events{n}(find(~isspace(events{n})));
            Events.(events{n}) = vicon.GetEvents(subject, 'General', events{n});
            if isempty(Events.(events{n}))
                Events = rmfield(Events, events{n});
                fprintf(['        Error Collecting ' events{n} ' Events\n']);
            end

        end
    else
        Events.(eventName) = vicon.GetEvents(subject, 'General', eventName);
        if isempty(Events.(eventName))
            Events = rmfield(Events, eventName);
            fprintf(['        Error Collecting ' eventName ' Events\n']);
        end
    end
    
    
end
