function Data = ViconExtractionLEADER_textbased()
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

addpath("Subfunctions\")
% CONFIGURATION:
% Select Desired Trials
bool_FP = true;
bool_EMG = false;
bool_marker = true;
bool_Jangle = true;
bool_Jvel = true;
bool_Jmom = true;
bool_Jforce = true;
bool_Jpow = true;
bool_event = true;
bool_subDet = true;
bool_centers = true;
bool_bones = true;

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

Data = processTrials(vicon, structureName, trial, data_path, targetPath, bool_marker, bool_FP, bool_Jangle,...
                    bool_Jvel, bool_Jmom, bool_Jpow, bool_Jforce, bool_event, bool_subDet, '', bool_EMG, bool_bones, bool_centers);


end