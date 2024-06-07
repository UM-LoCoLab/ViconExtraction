function Bones = PullBones(vicon, subject)
outputs = vicon.GetModelOutputNames(subject);
Bones = table;
for o = 1:numel(outputs)
    if contains(outputs{o},'LFE') || contains(outputs{o},'LFE') || contains(outputs{o},'LTI') ...
            || contains(outputs{o},'LTO') || contains(outputs{o},'PEL') || contains(outputs{o},'RFE') ...
            || contains(outputs{o},'RFO') || contains(outputs{o},'RTI') || contains(outputs{o},'RTO')
            % no nice way to do this - could do ~contain everything else
        try
            Bones = [Bones table(vicon.GetModelOutput(subject, outputs{o})','VariableNames', convertCharsToStrings(outputs{o}))];
        catch ME
            fprintf(['        Error Collecting ' outputs{o} '\n']);
        end
    else
        continue
    end
end

