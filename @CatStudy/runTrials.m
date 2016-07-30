function self = runTrials(self, varargin)
% Runs 50 trials or a predefined number of trials

if length(varargin) == 1
    self.trialCount = varargin{1};
else
    self.trialCount = 50;
end

% Find out how many trials are active and dummy trials
active = round(self.trialCount * self.trialActivePercentage);
dummy = round(self.trialCount * (1-self.trialActivePercentage));
% Make a list of these
self.trialActive = [ones(active,1); zeros(dummy,1)];
% And shuffle the list
self.trialActive = self.trialActive(randperm(length(self.trialActive)));

% Initialise the answer vector in which all actual and user
% answers are stored
self.answers = nan(self.trialCount, 5);
% Initialise the difficulty vector in which the difficulty for
% the current answer / trial is stored
self.difficulty = nan(self.trialCount, 1);
% Initialises the colour vector in which the colour before and
% after colour of the square that changed colour is stored
self.colours = nan(self.trialCount, 6);

% Step though each trial
for trial = 1:self.trialCount
    
    % Depending on whether the trial is an active one...
    if self.trialActive(trial) == 1
        % ...set a random square to change colour
        self.squareIndex = randi([1 self.squares]);
    else
        % ...set no square to change colour
        self.squareIndex = 0;
    end
    
    % Computes the colours, flashes the squares and reads in
    % the user's answers
    self = self.flashSquares();
    % Save the read in user's answers and actual parameters
    self = self.userAnswers();
    % Update the difficulty based on the recorded answers
    self = self.updateDifficulty();
end
end