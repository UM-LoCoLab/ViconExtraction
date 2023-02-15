function JointAngles = PullJointAngleViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
            JointAngles.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
        catch
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end






