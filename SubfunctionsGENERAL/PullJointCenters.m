function Centers = PullJointCenters(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
Centers = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'JC')
        try
            Centers = [Centers table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
        catch ME
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end

