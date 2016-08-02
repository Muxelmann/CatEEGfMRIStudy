function saveTrial(self, varargin)
% This saves the trial's data

if length(varargin) == 1
    studyName = varargin{1};
    
    % Get the raw data and save it in a table
    indices = self.answers(:,1);
    sawChange = self.answers(:,2);
    sawChangeCertainty = self.answers(:,3);
    changeLocation = self.answers(:,4);
    changeLocationCertainty = self.answers(:,5);
    
    % Then make the data a bit more "human readable" and append
    % that into the table also
    
    % Get the actual location of the changed square
    locations = self.getLocationFromIndex();
    % Get the user perceived changed square location
    userLocations = self.getLocationFromAnswers();
    
    % Get the difficulty of the individual trials
    difficulty = self.difficulty;
    
    % Get the colour changes, if there were any
    colourChange = self.colours;
    
    % Make the table and populate it with all data
    trialAnswers = table(...
        indices, sawChange, sawChangeCertainty, changeLocation, changeLocationCertainty, ...
        difficulty, locations, userLocations, colourChange);
    % Save the table
    save([studyName, '.mat'], 'trialAnswers');
    writetable(trialAnswers, [studyName '.csv']);
end
end