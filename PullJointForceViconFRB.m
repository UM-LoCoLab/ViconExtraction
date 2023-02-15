function JointForce = PullJointForceViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Force')
        try
            JointForce.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
        catch
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end