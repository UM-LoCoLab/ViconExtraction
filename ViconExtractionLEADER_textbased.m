function structureName = ViconExtractionLEADER_textbased()
%VICON EXTRACTION MASTER
%Save Vicon Data Into Matlab Struct

%Emma Reznick 2021
%Emma Reznick 2022
%Updates:
%-added subject details
%-added AMTI and Kistler Force Plates
%-gloabal CoP
%Emma Reznick 2023 -- updated to match GUI
% Katharine Walters 02/22/2024 - Updated to pull Kistler stair forceplates
% Katharine Walters 04/13/2024 - Updated to pull EMG (Delsys digital device)
% Kevin Best 06/4/2024 - Added 2.16 SDK paths, general path improvements.
%                      - Made into a function to allow for persistent vars

% CONFIGURATION:
% Select Desired Trials
bool_FP = true;
bool_EMG = false;
bool_marker = true;
bool_Jangle = false;
bool_Jvel = false;
bool_Jmom = false;
bool_Jforce = false;
bool_Jpow = false;
bool_event = false;
bool_subDet = false;

%% Connect to Vicon Nexus
warning('off','MATLAB:mpath:nameNonexistentOrNotADirectory')
try
    addpath('C:\Program Files\Vicon\Nexus2.15\SDK\MATLAB')
    addpath('C:\Program Files\Vicon\Nexus2.15\SDK\Win64')
    addpath('C:\Program Files\Vicon\Nexus2.16\SDK\Matlab')
    addpath('C:\Program Files\Vicon\Nexus2.16\SDK\Win64')
catch
    warning('on','MATLAB:mpath:nameNonexistentOrNotADirectory')
    error('Ensure that the Vicon SDK is installed and located in the expected path.')
end
warning('on','MATLAB:mpath:nameNonexistentOrNotADirectory')
vicon = ViconNexus;

% Load and save path handling
structureName = input('Structure Name:','s');
persistent data_path
if isempty(data_path)
    data_path = pwd;
end
[trial,data_path] = uigetfile(fullfile(data_path,'*.x1d'),...
    'Select One or More Files to Process', ...
    'MultiSelect', 'on');

persistent targetPath
if isempty(targetPath)
    targetPath = pwd;
end
targetPath = uigetdir(targetPath, 'Select Location to Save Structure');

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
        if bool_EMG
            try
                Data.(trialNameClean).(subject{s}).EMG = PullEMGViconFRB(vicon);
                fprintf('    EMG Collected\n')
            catch
                fprintf('    No EMG Data\n')
            end
        end
        if bool_FP
            try
                Data.(trialNameClean).(subject{s}).ForcePlate = PullForcePlateViconFRB(vicon);
                fprintf('    Force Plates Collected\n')
            catch
                fprintf('    No FP Data\n')
            end
            
        end
        if bool_marker
            try
                Data.(trialNameClean).(subject{s}).Markers = PullMarkerViconFRB(vicon, subject{s});
                fprintf('    Markers Collected\n')
            catch
                fprintf('    No Marker Data\n')
            end
        end
        %% Modeled Kinematics
        if bool_Jangle
            try
                Data.(trialNameClean).(subject{s}).JointAngle = PullJointAngleViconFRB(vicon, subject{s});
                fprintf('    Joint Angles Collected\n')
            catch
                fprintf('    No Joint Angle Data\n')
            end
        end
        if bool_Jvel
            try
                Data.(trialNameClean).(subject{s}).JointVelocity = PullJointVelocityViconFRB(vicon, subject{s}, vicon.GetFrameRate);
                fprintf('    Joint Velocity Collected\n')
            catch
                fprintf('    No Joint Velocity Data\n')
            end
        end
        
        %% Modeled Kinetics
        if bool_Jmom
            try
                Data.(trialNameClean).(subject{s}).JointMoment = PullJointMomentViconFRB(vicon, subject{s});
                fprintf('    Joint Moments Collected\n')
            catch
                fprintf('    No Joint Moment Data\n')
            end
        end
        if bool_Jforce
            try
                Data.(trialNameClean).(subject{s}).JointForce = PullJointForceViconFRB(vicon, subject{s});
                fprintf('    Joint Forces Collected\n')
            catch
                fprintf('    No Joint Force Data')
            end
        end
        if bool_Jpow
            try
                Data.(trialNameClean).(subject{s}).JointPower = PullJointPowerViconFRB(vicon, subject{s});
                fprintf('    Joint Powers Collected\n')
            catch
                fprintf('    No Joint Power Data\n')
            end
        end
        
        %% Misc Data
        if bool_event
            %if you want to add other events, input the name as a third argument as a comma separated list
            try
                Data.(trialNameClean).(subject{s}).Events = PullEventsViconFRB(vicon, subject{s}, ExpEvent);
                fprintf('    Events Collected\n')
            catch
                fprintf('    No Events Data\n')
            end
        end
        if bool_subDet
            try
                Data.(trialNameClean).(subject{s}).SubjectDetails = PullSubjectDetailsViconFRB(vicon, subject{s});
                fprintf('    Subject Details Collected\n')
            catch
                fprintf('    No Subject Details\n')
            end
        end
    end
end
eval([structureName ' = Data;']);
clear Data
strucfile = fullfile(targetPath, [structureName '.mat']);
fprintf('Saving Structure... ')
save(strucfile,structureName,'-v7.3')
fprintf('Saved.\n  ~*Mischief Managed*~\n')

end