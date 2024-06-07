function JointForce = PullJointForces(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
JointForce = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'Force')
        try
             JointForce = [JointForce table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
        catch ME
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end
end