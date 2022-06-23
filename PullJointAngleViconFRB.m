function JointAngles = PullJointAngleViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
            JointAngles.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
        catch
            disp(['        Error Collecting ' outputs{o}]);
        end
    else
        continue
    end
end






