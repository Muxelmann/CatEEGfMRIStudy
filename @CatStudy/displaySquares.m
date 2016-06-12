function self = displaySquares(self, period, inColour)
% Displays all suqares in white, and colours in the indexed one
% if the "inColour" value is set to true

if ~inColour
    self.rectColours = self.rectColouredBefore;
else
    self.rectColours = self.rectColouredAfter;
end

% Calculate how long the squares should be visible
framesToWait = round(period / self.ifi);

% Set the priority to highest
Priority(self.topPriorityLevel);

% Get the vbl
for frame = 1:framesToWait
    % Draws the fixation cross
    self.drawFixation();
    % Draw all rectangles
    self.drawSquares();
    % Then update the screen and wait before removing the squares
    self = self.flip();
end

% Reset priority to normal
Priority(0);
end