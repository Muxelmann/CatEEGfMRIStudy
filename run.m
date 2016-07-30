% Clear workspace, close all figures and clear screen
clearvars;
close all;

% Passes the subject's name
saveName = 'subject_name';

% Set this to true if the screen test does not work
skipSync = true;
% Determines whether to skip the square alignment test
skipSquareTest = false;
% The number of trials per block
trialCount = 10;
% The number of blocks that will be run and saved
blockCount = 8;

% Initialises the study
catStudy = CatStudy(skipSync, skipSquareTest, 3);
% catStudy.egg('Secret Name');

% Runs through the blocks
for blockNumber = 1:blockCount
    % Runs through the trials one block at a time
    catStudy = catStudy.runTrials(trialCount);
    % Saves the block's data (for all trials) in the output file
    catStudy.saveTrial([saveName '_block' num2str(blockNumber)]);
end

% Closes all screens and does some tidyig (if required)
catStudy.tidyUp();