function JointPower = PullJointPowers(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
JointPower = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'Power')
        try
            JointPower = [JointPower table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
            JointPower.(outputs{o})(:,1) = JointPower.(outputs{o})(:,1)*-1;
        catch
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end
end