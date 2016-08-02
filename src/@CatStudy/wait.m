function wait(self, period)
% Waits the predetermined period before continuing. This also
% displays a fixation cross in the middle of the screen

% Calculate how long to wait with a black screen
framesToWait = round(period / self.ifi);

% Set the priority to highest
Priority(self.topPriorityLevel);

% Make a black screen and wait before continuing
for frame = 1:framesToWait
    self.drawFixation();
    % Screen('DrawingFinished', self.window);
    self = self.flip();
end
end