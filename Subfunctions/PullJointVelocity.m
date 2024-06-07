function JointVel = PullJointVelocity(vicon, subject, sampleRate)
try
    outputs = vicon.GetModelOutputNames(subject);
catch
    fprintf(['        No Joint Angle Velocity For ' subject '\n'])
    return
end
tempTab = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'Angle')
        try
            newName = strcat(outputs{o}(1:end-6), 'Velocity');
            tempTab = [tempTab table(ddt(vicon.GetModelOutput(subject, outputs{o})', 1/sampleRate),'VariableNames', convertCharsToStrings(newName))];
            tempTab.(newName)(:,1) = tempTab.(newName)(:,1)*-1;
        catch 
            fprintf(['        Error Collecting ' newName '\n']);
        end
    else
        continue
    end
end
JointVel = tempTab;
end






