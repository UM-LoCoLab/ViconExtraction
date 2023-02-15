function JointVel = PullJointVelocityViconFRB(vicon, subject, sampleRate)
try
    outputs = vicon.GetModelOutputNames(subject);
catch
    fprintf(['        No Joint Angle Velocity For ' subject '\n'])
    return
end
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
            newName = strcat(outputs{o}(1:end-6), 'Velocity');
            JointVel.(newName) = ddt(vicon.GetModelOutput(subject, outputs{o})', 1/sampleRate);
        catch
            fprintf(['        Error Collecting ' newName '\n']);
        end
    else
        continue
    end
end

end






