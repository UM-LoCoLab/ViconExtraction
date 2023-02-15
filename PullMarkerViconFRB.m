function Markers = PullMarkerViconFRB(vicon, subject)
try
    marker = vicon.GetMarkerNames(subject);
catch
    fprintf(['        No Marker Data For ' subject '\n'])
    return
end
for m = 1:numel(marker)
    try
        [x,y,z,e] = vicon.GetTrajectory(subject, marker{m});
        Markers.(marker{m})  = [x', y', z', e'];
    catch
        fprintf(['        Error Collecting Marker Data For ' marker{m} '\n'])
    end
end





