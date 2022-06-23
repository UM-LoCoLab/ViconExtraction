function Markers = PullMarkerViconFRB(vicon, subject)
try
    marker = vicon.GetMarkerNames(subject);
catch
    display(['        No Marker Data For ' subject])
    return
end
for m = 1:numel(marker)
    try
        [x,y,z,e] = vicon.GetTrajectory(subject, marker{m});
        Markers.(marker{m})  = [x', y', z', e'];
    catch
        display(['        Error Collecting Marker Data For ' marker{m}])
    end
end





