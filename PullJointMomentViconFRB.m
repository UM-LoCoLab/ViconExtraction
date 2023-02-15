function JointMoment = PullJointMomentViconFRB(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
for o = 1:numel(outputs)
    if contains(outputs{o},'Moment')
        try
            JointMoment.(outputs{o}) = vicon.GetModelOutput(subject, outputs{o})';
            JointMoment.(outputs{o})(:,1) = JointMoment.(outputs{o})(:,1)*-1;
        catch
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end