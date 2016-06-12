function self = updateDifficulty(self)
% From the previously stored answers, this method updates the
% difficults (i.e. how many squares are displayed) and adjusts
% this number based on the performance of the participant

% Obtain how correct the past answers were
% (by default this is looking at the past 2 answers)
correct = self.wereAnswersCorrect();

fprintf('-> cetrainty (%4.2f) : difficulty ', correct);

if correct == 1
    % Increase difficulty if the user always correct
    self.squareCount = self.squareCount + 1;
    fprintf('upped  (^) to ');
elseif correct == 0
    % Reduce difficulty if the user is always wrong
    self.squareCount = self.squareCount - 1;
    fprintf('downed (v) to ');
end

% Prevent not displaying any squares
if self.squareCount < 1
    self.squareCount = 1;
end

% Preent trying to display more squares than possible to be
% displayed in each half of the screen
if self.squareCount > self.squareGrid(1)*self.squareGrid(2)/2
    self.squareCount = self.squareGrid(1)*self.squareGrid(2)/2;
end

fprintf('%2d squares\n', self.squareCount);
end