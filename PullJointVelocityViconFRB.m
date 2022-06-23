function JointVel = PullJointVelocityViconFRB(vicon, subject)
try
    outputs = vicon.GetModelOutputNames(subject);
catch
    display(['        No Joint Angle Velocity For ' subject])
    return
end
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
            newName = strcat(outputs{o}(1:end-6), 'Velocity');
            JointVel.(newName) = ddt(vicon.GetModelOutput(subject, outputs{o})', 1/100);
        catch
            disp(['        Error Collecting ' newName]);
        end
    else
        continue
    end
end

end






