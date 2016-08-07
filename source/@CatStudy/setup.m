function self = setup(self, skipSquareTest)
% initialises all properties that remain constant throughout
% the entire study, to prevent recalculating the same thing
% over and over again

% First set up the fixation cross properties

% Get the x and y coordinates for the fixation cross
xCoords = [-self.fixationCrossSize self.fixationCrossSize 0 0];
yCoords = [0 0 -self.fixationCrossSize self.fixationCrossSize];
self.fixationCoords = [xCoords; yCoords];

% Then compute the grid of squares

xSquares = self.squareGrid(1);
ySquares = self.squareGrid(2);
vSpace = 50;
hSpace = 0;

% The total number of squares
self.squares = xSquares*ySquares;

% Compute the size of a quadrant so we don't need to do it
% again for each placement of the squares
quadWidth = (self.windowWidth-hSpace) / 2;
quadHeight = (self.windowHeight-vSpace) / 2;

% Find the maximum square size if nine could be displayed in a
% single quadrant. Here I defined a maximum of 2x3 squares per
% single quadrant
squareSize = min(...
    (self.windowWidth - hSpace)/xSquares,...
    (self.windowHeight - vSpace)/ySquares) - 20;

% Generate the grid of rectangles...

% How big is half a square
halfSquare = squareSize / 2;
% How large is the x and y gap
xGap = (quadWidth - xSquares*halfSquare)/xSquares;
yGap = (quadHeight - ySquares*halfSquare)/ySquares;

% Make the grid
xPos = nan(self.squares, 1);
yPos = xPos;
xIndex = xPos;
yIndex = xPos;

for i = 1:xSquares;
    for j = 1:xSquares;
        
        % Get the current index
        k = (i-1)*xSquares + j;
        
        xIndex(k) = (i-xSquares/2-0.5)*2;
        if xIndex(k) < 0
            xPos(k) = self.windowXCentre + ...
                xIndex(k)*(halfSquare+xGap) - ...
                hSpace / 2;
        else
            xPos(k) = self.windowXCentre + ...
                xIndex(k)*(halfSquare+xGap) + ...
                hSpace / 2;
        end
        
        yIndex(k) = (j-ySquares/2-0.5)*2;
        if yIndex(k) < 0
            yPos(k) = self.windowYCentre + ...
                yIndex(k)*(halfSquare+yGap) - ...
                vSpace / 2;
        else
            yPos(k) = self.windowYCentre + ...
                yIndex(k)*(halfSquare+yGap) + ...
                vSpace / 2;
        end
    end
end

% Make the base rectangle
baseRect = [0 0 squareSize squareSize];

% Get the coordinates for all rectangles
self.allRects = nan(4, self.squares);
for i = 1:size(self.allRects,2)
    self.allRects(:,i) = ...
        CenterRectOnPoint(baseRect, xPos(i), yPos(i));
end

if ~skipSquareTest
    % Lets the user know what's happening in the beginning
    self = self.printMessage(['Square alignment test\n\n'...
        'Press any key to continue'], 2);
    
    self.rectColours = [self.rectColourSet' ones(3,self.squares-7)];
    % Draw all rectangles
    self.drawSquares();
    % Draws the fixation cross
    self.drawFixation();
    % Then update the screen and wait before removing the squares
    self = self.flip();
    KbWait();
    
    % Display a black screen until continuing
    self = self.printMessage('', 0.5);
end

% Make quarter rectangles for the user's location answers

% Initialise the answer rects
self.answerRects = nan(4,4);

quarterRect = [0 0 self.windowWidth/2 self.windowHeight/2] * 0.95;
self.answerRects(:,1) = CenterRectOnPoint(quarterRect, ...
    self.windowWidth/4, self.windowHeight/4);
self.answerRects(:,2) = CenterRectOnPoint(quarterRect, ...
    self.windowXCentre+self.windowWidth/4, self.windowHeight/4);
self.answerRects(:,3) = CenterRectOnPoint(quarterRect, ...
    self.windowWidth/4, self.windowYCentre+self.windowHeight/4);
self.answerRects(:,4) = CenterRectOnPoint(quarterRect, ...
    self.windowXCentre+self.windowWidth/4, self.windowYCentre+self.windowHeight/4);

% Initialise the label coordinates
self.answerRectLabelCoords = nan(4,2);

self.answerRectLabelCoords(1,1) = self.windowXCentre*0.5;
self.answerRectLabelCoords(2,1) = self.windowXCentre*1.5;
self.answerRectLabelCoords(3,1) = self.windowXCentre*0.5;
self.answerRectLabelCoords(4,1) = self.windowXCentre*1.5;
self.answerRectLabelCoords(1,2) = self.windowYCentre*0.5;
self.answerRectLabelCoords(2,2) = self.windowYCentre*0.5;
self.answerRectLabelCoords(3,2) = self.windowYCentre*1.5;
self.answerRectLabelCoords(4,2) = self.windowYCentre*1.5;

if ~skipSquareTest
    % Lets the user know what's happening in the beginning
    self = self.printMessage(['Quarters alignment test\n\n'...
        'Press any key to continue'], 2);
    
    % Draw the quarters
    self.drawQuarters();
    % Draws the fixation cross
    self.drawFixation();
    % Update the screen
    self = self.flip();
    % Wait for user input
    KbWait();
end

self = self.printMessage('Trial starting', 2);

% Make screen blank
self.drawBlankScreen();
self = self.flip();

end