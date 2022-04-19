%Save Vicon Data Into Matlab Struct
%VICON EXTRACTION MASTER

%Emma Reznick 2021
%Emma Reznick 2022
    %Updates:
    %-added subject details
    %-added AMTI and Kistler Force Plates

%% Connect to Vicon Nexus
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Matlab')
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Win64')
vicon = ViconNexus;

structureName = input('Structure Name:','s');

[trial,data_path] = uigetfile('*.x1d',...
    'Select One or More Files', ...
    'MultiSelect', 'on');

targetPath = 'C:\Users\hframe\Desktop\HoppingData'; %%FILL IN

%Select Desired Trials
bool_FP = true;
bool_marker = true;
bool_Jangle = false;
bool_Jvel = false;
bool_Jmom = false;
bool_Jforce = false;
bool_Jpow = false;
bool_event = true;
bool_subDet = false;

%Loop Through Trials
if iscell(trial)
    trialNum = numel(trial);
else
    trialNum = 1;
end

for t = 1:trialNum
    %Check for multiple subjects
    subject = vicon.GetSubjectInfo;
    for s = 1:numel(subject)
        
        try
            trialName = trial{t}(1:end-4);
        catch
            trialName = trial(1:end-4);
        end
        trialPath = [data_path, trialName];
        vicon.OpenTrial(trialPath,30)
        
        
        %% Raw Data
        if bool_FP
            Data.(trialName).(subject{s}).ForcePlate = PullForcePlateViconFRB(vicon);
        end
        if bool_marker
            Data.(trialName).(subject{s}).Markers = PullMarkerViconFRB(vicon, subject{s});
        end
        %% Modeled Kinematics
        if bool_Jangle
            Data.(trialName).(subject{s}).JointAngle = PullJointAngleViconFRB(vicon, subject{s});
        end
        if bool_Jvel
            Data.(trialName).JointVelocity = PullJointVelocityViconFRB(vicon, subject{s});
        end
        
        %% Modeled Kinetics
        if bool_Jmom
            Data.(trialName).(subject{s}).JointMoment = PullJointMomentViconFRB(vicon, subject{s});
        end
        if bool_Jforce
            Data.(trialName).(subject{s}).JointForce = PullJointForceViconFRB(vicon, subject{s});
        end
        if bool_Jpow
            Data.(trialName).(subject{s}).JointPower = PullJointPowerViconFRB(vicon, subject{s});
        end
        
        %% Misc Data
        if bool_event
            %if you want to add other events, input the name as a third argument as a string
            Data.(trialName).(subject{s}).Events = PullEventsViconFRB(vicon, subject{s}, 'hopStart');
        end
        if bool_subDet
            Data.(trialName).(subject{s}).SubjectDetails = PullSubjectDetailsViconFRB(vicon, subject{s});
        end
    end
end
cd(targetPath);
eval([structureName ' = Data;']);
save(structureName,structureName,'-v7.3')
