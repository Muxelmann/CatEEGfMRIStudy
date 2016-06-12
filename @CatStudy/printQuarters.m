function [self, button] = printQuarters(self, duration, validKeys)
% Draws four squares on the screen and fills them with colour
% so that the user can quickly identify where the change was
% seen. If no key is expected to be pressed and returned, leave out the
% validKeys argument.

button = nan;

% Calculate how many frames to display the quarter colouring
% for
framesToWait = round(duration / self.ifi);
% Display the text for x-many frames, i.e. the duration
for frame = 1:framesToWait
    % Draw the quarter colouring
    self.drawQuarters();
    % Draws the fixation cross
    self.drawFixation();
    % Update the screen
    self = self.flip();
    
    % Keep checking if a button was pressed...
    [keyIsDown, ~, tmpkeyCode] = KbCheck();
    if keyIsDown && isnan(button)
        % Extract the index of the pressed key
        tmpkeyCode = find(tmpkeyCode);
        % Evaluate if the pressed key is a valid key
        if exist('validKeys', 'var') && self.isAValidKey(tmpkeyCode(1), validKeys)
            % And assign the key code to be returned if it is a valid key
            keyCode = tmpkeyCode(1);
            % Obtain which button was pressed
            button = self.decodeKeyCode(keyCode);
            
            self.eegInterface.
        end
    end
end
end