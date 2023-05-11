function Markers = PullMarkerVicon(vicon, subject)
marker = vicon.GetMarkerNames(subject);
Markers = table;
for m = 1:numel(marker)
    try
        Markers = [Markers table(vicon.GetModelOutput(subject, marker{m})','VariableNames', convertCharsToStrings(marker{m}))];
    catch
        fprintf(['        Error Collecting Marker Data For ' marker{m} '\n'])
    end
end





