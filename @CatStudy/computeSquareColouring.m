function self = computeSquareColouring(self)
% Compute which square is coloured how for before and after a
% change occurred

% The total number of squares
squares = self.squares;

if self.squareIndex > 0
    % If a square will change colour find out where it sits
    % first...
    
    % Generate all square indices for the left and right sides
    % of the screen
    leftIndices = 1:squares/2;
    rightIndices = squares/2+1:squares;
    
    if self.squareIndex < squares/2
        % Remove the already visible index from the right
        % indices
        leftIndices(leftIndices == self.squareIndex) = [];
        % And assign it to be visible
        leftVisible = self.squareIndex;
        % Then add a random selection of left indices to become
        % visible, too
        leftVisible = [leftVisible ...
            leftIndices(randperm(length(leftIndices), self.squareCount-1))];
        
        % Finally assign the equal number of random visible
        % indices to the right hand side
        rightVisible = randperm(squares/2, self.squareCount) + squares/2;
    else
        % Remove the already fisible index from the left
        % indices
        rightIndices(rightIndices == self.squareIndex) = [];
        % And assign it to be visible
        rightVisible = self.squareIndex;
        % Then add a random selection of right indices to
        % become visible, too
        rightVisible = [rightVisible ...
            rightIndices(randperm(length(rightIndices), self.squareCount-1))];
        
        % Finally assign the equal number of random visible
        % indices to the left hand side
        leftVisible = randperm(squares/2, self.squareCount);
    end
else
    % If there is no square changing colour, allocate random
    % ones on either side of the screen
    leftVisible = randperm(squares/2, self.squareCount);
    rightVisible = randperm(squares/2, self.squareCount) + squares/2;
end

% Sort them (only really for debugging)
leftVisible = sort(leftVisible);
rightVisible = sort(rightVisible);

% Make a vector of all visible squares
visible = [leftVisible rightVisible];

% Get a random set of colour indices
randomIDs = randi([1 size(self.rectColourSet, 1)], 1, length(visible));
% Get all the random colours and append ones to all colours
% (so that they are not transparent -> RGBA)
randomColours = [self.rectColourSet(randomIDs,:) ones(length(visible),1)]';

% Initially set all squares to be transparent, i.e. not visible
self.rectColouredBefore = zeros(4, squares);
% Then set those that are visible to the random colours
self.rectColouredBefore(:,visible) = randomColours;

% Then change one square's colour if it is to change
self.rectColouredAfter = self.rectColouredBefore;
if self.squareIndex > 0
    % Makes a copy of the availbale colours
    newRectColourSet = self.rectColourSet;
    % Gets the current colour of the square that will change
    currentColour = self.rectColouredBefore(1:3,self.squareIndex).';
    % Removes the current colour of the square that will change
    % from the temporary colour set
    newRectColourSet(ismember(newRectColourSet,currentColour,'rows'),:) = [];
    % Extracts a random (different) colour from the reduced
    % colour set
    randomColour = newRectColourSet(...
        randi([1 size(newRectColourSet,1)]),:);
    % Assigns the colour to the corresponding property
    self.rectColouredAfter(:,self.squareIndex) = [randomColour 1].';
end
end