function JointPower = PullJointPowerViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Power')
        try
            JointPower.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
            JointPower.(outputs{o})(:,1) = JointPower.(outputs{o})(:,1)*-1;
        catch
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end