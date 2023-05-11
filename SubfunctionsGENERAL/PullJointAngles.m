function JointAngles = PullJointAngles(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
JointAngles = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
             JointAngles = [JointAngles table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
        catch ME
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end
end






