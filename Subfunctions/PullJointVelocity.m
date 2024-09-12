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
            if contains(outputs{o},'_M')
                newName = strcat(outputs{o}(1:end-8), 'Velocity_M');
            else
                newName = strcat(outputs{o}(1:end-6), 'Velocity');
            end
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






