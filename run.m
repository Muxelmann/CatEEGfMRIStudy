% Clear workspace, close all figures and clear screen
clearvars;
close all;

% Passes the subject's name
saveName = 'subject_name';

% Set this to true if the screen test does not work
skipSync = true;

% Initialises the study
catStudy = CatStudy(skipSync);

% Runs through the trials one block at a time
catStudy = catStudy.runTrials();
% Saves the block's data (for all trials) in the output file
catStudy.saveTrial(saveName);

% Closes all screens and does some tidyig (if required)
catStudy.tidyUp();