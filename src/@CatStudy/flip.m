function self = flip(self)
% Updates the screen and displays what has been drawn

% Informs the graphics pipeline that we're done drawing
Screen('DrawingFinished', self.window);
% Updates the screen and draws to it
self.vbl = Screen('Flip', self.window, self.vbl+0.5*self.ifi);
end