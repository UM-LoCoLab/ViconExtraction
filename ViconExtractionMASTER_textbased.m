%Save Vicon Data Into Matlab Struct
%VICON EXTRACTION MASTER

%Emma Reznick 2021

            
%% Connect to Vicon Nexus
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Matlab')
addpath('C:\Program Files (x86)\Vicon\Nexus2.12\SDK\Win64')
vicon = ViconNexus;

subject = input('Subject Name:','s');

% disp('===================================')
% disp(['Connected to Nexus for subject ',subject])
% disp('===================================')

structureName = input('Structure Name:','s'); 

[trial,data_path] = uigetfile('*.x1d',...
                'Select One or More Files', ...
                'MultiSelect', 'on');

targetPath = ''; %%SHANNON FILL IN

bool_FP = false;
bool_marker = true;
bool_Jangle = false;
bool_Jvel = false;
bool_Jmom = false;
bool_Jforce = false;
bool_Jpow = false;
bool_event = false;
bool_subDet = false;
bool_strideTime = false;


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
    vicon.OpenTrial(trialPath,30)
    
    
    %% Raw Data
    if bool_FP
    Data.(trialName).ForcePlate = PullForcePlateViconFRB(vicon);
    end
    if bool_marker
    Data.(trialName).Markers = PullMarkerViconFRB(vicon, subject);
    end
    %% Modeled Kinematics
    if bool_Jangle
    Data.(trialName).JointAngle = PullJointAngleViconFRB(vicon, subject);
    end
    if bool_Jvel
    Data.(trialName).JointVelocity = PullJointVelocityViconFRB(vicon, subject);
    end
    
    %% Modeled Kinetics
    if bool_Jmom
    Data.(trialName).JointMoment = PullJointMomentViconFRB(vicon, subject);
    end
    if bool_Jforce
    Data.(trialName).JointForce = PullJointForceViconFRB(vicon, subject);
    end
    if bool_Jpow
    Data.(trialName).JointPower = PullJointPowerViconFRB(vicon, subject);
    end
    
    %% Misc Data
    if bool_event
    Data.(trialName).Events = PullEventsViconFRB(vicon, subject);
    end
    if bool_subDet
        Data.(trialName).SubjectDetails = PullJointMomentViconFRB(vicon, subject);
    end
    if bool_strideTime
        
    end
end
cd(target_path);
eval([structureName ' = Data;']);
save(structureName,structureName,'-v7.3')
