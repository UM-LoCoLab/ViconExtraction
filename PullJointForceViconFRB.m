function JointForce = PullJointForceViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Force')
        try
            JointForce.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
        catch
            disp(['        Error Collecting ' outputs{o}]);
        end
    else
        continue
    end
end