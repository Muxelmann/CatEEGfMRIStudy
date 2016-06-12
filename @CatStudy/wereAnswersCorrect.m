function correct = wereAnswersCorrect(self, answerCount)
% Generates a vector stating whether the answers were correct
% or not. An argument can be passed that evaluates the past N
% answers. The result is:
% - 0 if the all the last N answers were wrong
% - 1 if the all the last N answers were right
% - between 0 and 1 if some were right and some were wrong

% Specify custom number of answers to compare
if ~exist('answerCount', 'var')
    answerCount = 2;
end

% Obtain where there are submitted answers
availableAnswers = ~isnan(self.answers(:,1));

% Compute the user's answer and the actual answer
userAnswers = self.getLocationFromAnswers();
userAnswers = userAnswers(availableAnswers, :);
actualAnswers = self.getLocationFromIndex();
actualAnswers = actualAnswers(availableAnswers, :);

% Reduce the number of answers to match the answer count
if sum(availableAnswers) > answerCount
    userAnswers = userAnswers(end-answerCount+1:end,:);
    actualAnswers = actualAnswers(end-answerCount+1:end,:);
end

% Calculate the correctness of the submitted answers
correct = 0;
for i = 1:size(userAnswers,1)
    correct = correct + ...
        strcmp(userAnswers(i,:), actualAnswers(i,:));
end
correct = correct / size(userAnswers,1);
end