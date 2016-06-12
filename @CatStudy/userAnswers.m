function self = userAnswers(self)
% Gets the user input

% Instantiate the four answer slots
button = nan(1,4);

% Ask if a change was seen
[self, button(1)] = self.printMessage( ...
    self.textAnswer{1}, self.periodAnswer(1), ...
    self.answerButtons(1:2));

% Ask the user how certain he/she was
[self, button(2)] = self.printMessage( ...
    self.textAnswer{2}, self.periodAnswer(2), ...
    self.answerButtons);

% Only ask where the change was if the user observed one
if button(1) == 1
    
    % Ask where the change was observed
    [self, button(3)] = self.printQuarters(self.periodAnswer(3), self.answerButtons);
    
    % Ask the user how certain he/she was
    [self, button(4)] = self.printMessage(self.textAnswer{2}, self.periodAnswer(4), self.answerButtons);
    
end

% Identify which trial we're on and save the user's answers as well as the
% trial's information in the answer vector

% Find the index of the answer slots that have not been assigned
trial = find(isnan(self.answers(:,1)));
% Extract the 1st unassigned slot to store the answer in
trial = trial(1);
fprintf('-> Saving trial: %2d\n', trial)

% Store the user's answers and associated button indices
self.answers(trial,:) = [self.squareIndex button];
% Store the difficulty, i.e. number of squares per on each half
self.difficulty(trial,:) = self.squareCount;
% If a colour change occurred, save the before and after colour
if self.squareIndex > 0
    self.colours(trial,:) = [...
        self.rectColouredBefore(1:3,self.squareIndex).'...
        self.rectColouredAfter(1:3,self.squareIndex).'];
end
end