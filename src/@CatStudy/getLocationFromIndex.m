function location = getLocationFromIndex(self)
% Translates the index of a square into where it sat on the
% square grid

% Get the index of the changing square
index = self.answers(:,1);

% Get the number of squares in x and y direction
xCount = self.squareGrid(1);
yCount = self.squareGrid(2);

% Identify whether the change occurred to the left or right:
% i.e. index is lower than half the number of squares
isLeft = (index < xCount * yCount / 2) & (index > 0);
% Identify whether the change occurred on the top or bottom:
% i.e. index's remainder when dividing by the grid height is less than half
% the grid height... (sounds complicated but draw it out and it'll make
% sense, trust me)
isTop = (mod(index-1,yCount)+1 <= yCount / 2) & (index > 0);

% Initialise the locations vector, where all changes are defaulted to an
% empty string, i.e. error
location = repmat('  ', length(index), 1);

% For each trial...
for i = 1:length(index)
    
    % If the trial hasn't progressed that far yet leave as is and continue
    % otherwise check if there was no change and set the location to 'NO'
    if isnan(index(i))
        continue;
    elseif index(i) == 0
        location(i,:) = 'NO';
        continue;
    end
    
    % If a change occurred change the 1st character to L or R
    if isLeft(i) == 1
        location(i,1) = 'L';
    else
        location(i,1) = 'R';
    end
    
    % If a change occurred change the 2nd character to T or B
    if isTop(i) == 1
        location(i,2) = 'T';
    else
        location(i,2) = 'B';
    end
end

end