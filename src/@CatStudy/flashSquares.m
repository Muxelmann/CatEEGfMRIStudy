function self = flashSquares(self)
% Flashes a set of squares and changes the colour in one

self = self.computeSquareColouring();

Priority(self.topPriorityLevel);

self.wait(rand()*2+3);
self.displaySquares(self.periodDisplay, false);
self.wait(0.2);
self.displaySquares(self.periodDisplay, true);
self.wait(0.1);

% Do drawing stuff
Priority(0);
end