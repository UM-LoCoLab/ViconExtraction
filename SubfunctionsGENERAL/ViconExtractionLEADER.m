%Save Vicon Data Into Matlab Struct
%VICON EXTRACTION MASTER

%Emma Reznick 2021

function ViconExtractionLEADER(vicon, structureName, trial, data_path, targetPath, bool_marker, bool_FP, bool_rawPin, bool_Jangle,...
    bool_Jvel, bool_Jmom, bool_Jpow, bool_Jforce, bool_event, bool_subDet, bool_checked, ExpEvent)

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
    vicon.OpenTrial(trialPath,30)
    trialNameClean = trialName(find(~isspace(trialName)));
    %Check for multiple subjects
    [subject, ~, active] = vicon.GetSubjectInfo;
    
    for s = 1:numel(subject)
        %check to see if subject is checked
        fprintf(['  Processing Subject: ' subject{s} '\n'])
        if ~active(s) && ~bool_checked
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
                Data.(trialNameClean).(subject{s}).JointAngle = PullJointAngleVicon(vicon, subject{s});
                fprintf('    Joint Angles Collected\n')
            catch
                fprintf('    No Joint Angle Data\n')
            end
        end
        if bool_Jvel
            try
                Data.(trialNameClean).(subject{s}).JointVelocity = PullJointVelocityVicon(vicon, subject{s}, vicon.GetFrameRate);
                fprintf('    Joint Velocity Collected\n')
            catch
                fprintf('    No Joint Velocity Data\n')
            end
        end
        
        %% Modeled Kinetics
        if bool_Jmom
            try
                Data.(trialNameClean).(subject{s}).JointMoment = PullJointMomentVicon(vicon, subject{s});
                fprintf('    Joint Moments Collected\n')
            catch
                fprintf('    No Joint Moment Data\n')
            end
        end
        if bool_Jforce
            try
                Data.(trialNameClean).(subject{s}).JointForce = PullJointForceVicon(vicon, subject{s});
                fprintf('    Joint Forces Collected\n')
            catch
                fprintf('    No Joint Force Data')
            end
        end
        if bool_Jpow
            try
                Data.(trialNameClean).(subject{s}).JointPower = PullJointPowerVicon(vicon, subject{s});
                fprintf('    Joint Powers Collected\n')
            catch
                fprintf('    No Joint Power Data\n')
            end
        end
        
        %% Misc Data
        if bool_event
            %if you want to add other events, input the name as a third argument as a comma separated list
            try
                Data.(trialNameClean).(subject{s}).Events = PullEventsVicon(vicon, subject{s}, ExpEvent);
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
                Data.(trialNameClean).ForcePlates = PullForcePlate(vicon, bool_rawPin);
                fprintf('    Force Plates Collected\n')
            catch
                fprintf('    No FP Data\n')
            end
            
   end
end
eval([structureName ' = Data;']);
clear Data
strucfile = fullfile(targetPath, [structureName '.mat']);
fprintf('Saving Structure... ')
save(strucfile, structureName, '-v7.3')
fprintf('Saved.\n  ✧˖°.Mischief Managed.°˖✧\n')
end