function [ self ] = pauseScreen( self )
% Allows the experiment to be paused until a button is pressed

DrawFormattedText(self.window, 'Pause', 'center', 'center', self.white);
self = self.flip();
KbWait();

end

