%Save Vicon Data Into Matlab Struct
%VICON EXTRACTION MASTER

%Emma Reznick 2021
%Emma Reznick 2022
%Updates:
%-added subject details
%-added AMTI and Kistler Force Plates
%-does not collect data from unchecked subjects

%% Connect to Vicon Nexus
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Matlab')
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Win64')
vicon = ViconNexus;

structureName = input('Structure Name:','s');

[trial,data_path] = uigetfile('*.x1d',...
    'Select One or More Files', ...
    'MultiSelect', 'on');

targetPath = data_path; %%FILL IN

%Select Desired Trials
bool_FP = false;        %force plate
bool_marker = true;     %markers
bool_Jangle = false;    %joint angles
bool_Jvel = false;      %joint velocity
bool_Jmom = false;      %joint moment
bool_Jforce = false;    %joint angles
bool_Jpow = false;      %joint powers
bool_event = false;     %events
bool_subDet = false;    %subject details

%Loop Through Trials
if iscell(trial)
    trialNum = numel(trial);
else
    trialNum = 1;
end

for t = 1:trialNum
    %Check for multiple subjects
    [subject, ~, active] = vicon.GetSubjectInfo;
    for s = 1:numel(subject)
        %check to see if subject is checked
        if ~active(s)
            continue
        end
        
        try
            trialName = trial{t}(1:end-4);
        catch
            trialName = trial(1:end-4);
        end
        trialPath = [data_path, trialName];
        disp(['Opening ' trialName])
        vicon.OpenTrial(trialPath,30)
        trialNameClean = trialName(find(~isspace(trialName)));
        
        %% Raw Data
        if bool_FP
            try
                Data.(trialNameClean).(subject{s}).ForcePlate = PullForcePlateViconFRB(vicon);
                disp('    Force Plates Collected')
            catch
                disp('    No FP Data')
            end
            
        end
        if bool_marker
            try
                Data.(trialNameClean).(subject{s}).Markers = PullMarkerViconFRB(vicon, subject{s});
                disp('    Markers Collected')
            catch
                disp('    No Marker Data')
            end
        end
        %% Modeled Kinematics
        if bool_Jangle
            try
                Data.(trialNameClean).(subject{s}).JointAngle = PullJointAngleViconFRB(vicon, subject{s});
                disp('    Joint Angles Collected')
            catch
                disp('    No Joint Angle Data')
            end
        end
        if bool_Jvel
            try
                Data.(trialNameClean).JointVelocity = PullJointVelocityViconFRB(vicon, subject{s});
                disp('    Joint Velocity Collected')
            catch
                disp('    No Joint Velocity Data')
            end
        end
        
        %% Modeled Kinetics
        if bool_Jmom
            try
                Data.(trialNameClean).(subject{s}).JointMoment = PullJointMomentViconFRB(vicon, subject{s});
                disp('    Joint Moments Collected')
            catch
                disp('    No Joint Moment Data')
            end
        end
        if bool_Jforce
            try
                Data.(trialNameClean).(subject{s}).JointForce = PullJointForceViconFRB(vicon, subject{s});
                disp('    Joint Forces Collected')
            catch
                disp('    No Joint Force Data')
            end
        end
        if bool_Jpow
            try
                Data.(trialNameClean).(subject{s}).JointPower = PullJointPowerViconFRB(vicon, subject{s});
                disp('    Joint Powers Collected')
            catch
                disp('    No Joint Power Data')
            end
        end
        
        %% Misc Data
        if bool_event
            %if you want to add other events, input the name as a third argument as a string
            try
                Data.(trialNameClean).(subject{s}).Events = PullEventsViconFRB(vicon, subject{s}, 'hopStart');
                disp('    Events Collected')
            catch
                disp('    No Events Data')
            end
        end
        if bool_subDet
            try
                Data.(trialNameClean).(subject{s}).SubjectDetails = PullSubjectDetailsViconFRB(vicon, subject{s});
                disp('    Subject Details Collected')
            catch
                disp('    No Subject Details')
            end
        end
    end
end
cd(targetPath);
eval([structureName ' = Data;']);
save(structureName,structureName,'-v7.3')
disp('Mischef Managed')


