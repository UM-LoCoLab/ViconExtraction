function Data = processTrials(vicon, structureName, trial, data_path, targetPath, bool_marker, bool_FP, bool_Jangle,...
    bool_Jvel, bool_Jmom, bool_Jpow, bool_Jforce, bool_event, bool_subDet, ExpEvent, bool_EMG, bool_bones, bool_centers)
%Loop Through Trials
if iscell(trial)
    trialNum = numel(trial);
else
    trialNum = 1;
end

for t = 1:trialNum
    try
        trialName = trial{t}(1:end-4);
    catch
        trialName = trial(1:end-4);
    end
    trialPath = [data_path, trialName];
    fprintf(['Opening ' trialName '\n'])
    vicon.OpenTrial(trialPath,60)
    trialNameClean = trialName(find(~isspace(trialName)));
    %Check for multiple subjects
    [subject, ~, active] = vicon.GetSubjectInfo;
    for s = 1:numel(subject)
        %check to see if subject is checked
        fprintf(['  Processing Subject: ' subject{s} '\n'])
        if ~active(s)
             fprintf(['   Subject ' subject{s} ' Skipped (Not Checked)\n'])
            continue
        end

    %%Raw Data
        if bool_marker
            try
                Data.(trialNameClean).(subject{s}).Markers = PullMarkerVicon(vicon, subject{s});
                fprintf('    Markers Collected\n')
            catch
                fprintf('    No Marker Data\n')
            end
        end
        %% Modeled Kinematics
        if bool_Jangle
            try
                Data.(trialNameClean).(subject{s}).JointAngle = PullJointAngles(vicon, subject{s});
                fprintf('    Joint Angles Collected\n')
            catch
                fprintf('    No Joint Angle Data\n')
            end
        end
        if bool_Jvel
            try
                Data.(trialNameClean).(subject{s}).JointVelocity = PullJointVelocity(vicon, subject{s}, vicon.GetFrameRate);
                fprintf('    Joint Velocity Collected\n')
            catch
                fprintf('    No Joint Velocity Data\n')
            end
        end
        
        %% Modeled Kinetics
        if bool_Jmom
            try
                Data.(trialNameClean).(subject{s}).JointMoment = PullJointMoments(vicon, subject{s});
                fprintf('    Joint Moments Collected\n')
            catch
                fprintf('    No Joint Moment Data\n')
            end
        end
        if bool_Jforce
            try
                Data.(trialNameClean).(subject{s}).JointForce = PullJointForces(vicon, subject{s});
                fprintf('    Joint Forces Collected\n')
            catch
                fprintf('    No Joint Force Data')
            end
        end
        if bool_Jpow
            try
                Data.(trialNameClean).(subject{s}).JointPower = PullJointPowers(vicon, subject{s});
                fprintf('    Joint Powers Collected\n')
            catch
                fprintf('    No Joint Power Data\n')
            end
        end
        
        %% Misc Data
        if bool_centers
            try
                Data.(trialNameClean).(subject{s}).JointCenters = PullJointCenters(vicon, subject{s});
                fprintf('    Joint Centers Collected\n')
            catch
                fprintf('    No Joint Centers\n')
            end
        end
        
        if bool_bones
            try
                Data.(trialNameClean).(subject{s}).Bones = PullBones(vicon, subject{s});
                fprintf('    Bones Collected\n')
            catch
                fprintf('    No Bones\n')
            end
        end
        
        if bool_event
            ExpEvent = 'LHS,LTO,RHS,RTO';
            %if you want to add other events, input the name as a third argument as a comma separated list
            try
                Data.(trialNameClean).(subject{s}).Events = PullEvents(vicon, subject{s}, ExpEvent);
                fprintf('    Events Collected\n')
            catch
                fprintf('    No Events Data\n')
            end
        end
        if bool_subDet
            try
                Data.(trialNameClean).(subject{s}).SubjectDetails = PullSubjectDetailsVicon(vicon, subject{s});
                fprintf('    Subject Details Collected\n')
            catch
                fprintf('    No Subject Details\n')
            end
        end
        
    end
    if bool_FP
        try
            Data.(trialNameClean).ForcePlates = PullForcePlate(vicon, true);
            fprintf('    Force Plates Collected\n')
        catch
            fprintf('    No FP Data\n')
        end
    end
    if bool_EMG
        try
            Data.(trialNameClean).(subject{s}).EMG = PullEMGViconFRB(vicon);
            fprintf('    EMG Collected\n')
        catch
            fprintf('    No EMG Data\n')
        end
    end
end

%% Save
eval([structureName ' = Data;']);
strucfile = fullfile(targetPath, [structureName '.mat']);
fprintf('Saving Structure... ')
save(strucfile,structureName,'-v7.3')
fprintf('Saved.\n  ~*Mischief Managed*~\n')

end