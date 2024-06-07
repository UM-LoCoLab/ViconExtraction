function Markers = PullMarkerVicon(vicon, subject)
marker = vicon.GetMarkerNames(subject);
Markers = table;
for m = 1:numel(marker)
    try
        [x, y, z, e] = vicon.GetTrajectory(subject, marker{m});
        Markers = [Markers table([x',y',z',e'],'VariableNames', convertCharsToStrings(marker{m}))];
    catch
        fprintf(['        Error Collecting Marker Data For ' marker{m} '\n'])
    end
end


