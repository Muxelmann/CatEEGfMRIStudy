function location = getLocationFromAnswers(self)
% Converts the answers into locations so they can be compared

% Get whether a change was observed (1st column) and where (3rd column)
allAnswers = self.answers(:,[2 4]);

% Initialise the location vector with empty (i.e. error)
location = repmat('  ', size(allAnswers, 1), 1);

% Evaluates each answer individually
for i = 1:size(allAnswers)
    
    if isnan(allAnswers(i,1))
        % If the answer is not given, continue to the next answer
        continue;
    elseif allAnswers(i,1) == 2
        % If no change was observed change set the value to 'NO' and
        % continue to the next answer
        location(i,:) = 'NO';
        continue;
    end
    
    % Determine where the answer was seen if there was one and default to a
    % blank entry if the value is not given or cannot be identified
    switch allAnswers(i,2)
        case 1; location(i,:) = 'LT';
        case 2; location(i,:) = 'RT';
        case 3; location(i,:) = 'LB';
        case 4; location(i,:) = 'RB';
        otherwise; location(i,:) = '  ';
    end 
end
end