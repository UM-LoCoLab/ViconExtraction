%This function pulls subject details from an open Vicon trial
%Emma Reznick 04/04/2022
%Emma Reznick 02/15/2023 Update: add in units
function Details = PullSubjectDetailsViconFRB(vicon, subject)
paramNames = {'Bodymass','Height','LeftLegLength','LeftKneeWidth','LeftAnkleWidth',...
    'RightLegLength','RightKneeWidth','RightAnkleWidth'};
unit = {'kg' 'mm' 'mm' 'mm' 'mm' 'mm' 'mm' 'mm'};
try %Plug in Gait
    for n = 1:numel(paramNames)
        Details{n, 1} = paramNames{n};
        Details{n, 2} = vicon.GetSubjectParam(subject, paramNames{n});
        Details{n, 3} = unit{n};
    end
catch %Other types of subjects
    paramNames = vicon.GetSubjectParamNames(subject);
    for n = 1:numel(paramNames)
        Details{n, 1} = paramNames{n};
        Details{n, 2} = vicon.GetSubjectParam(subject, paramNames{n});
    end
end







