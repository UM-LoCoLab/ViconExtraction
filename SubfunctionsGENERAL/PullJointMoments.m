function JointMoment = PullJointMoments(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
JointMoment = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'Moment')
        try
            JointMoment = [JointMoment table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
            JointMoment.(outputs{o})(:,1) = JointMoment.(outputs{o})(:,1)*-1;
        catch ME 
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end
end