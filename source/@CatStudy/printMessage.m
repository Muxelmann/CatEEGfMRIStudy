function [self, button] = printMessage(self, message, duration, validKeys)
% Displays a message for a certain time and returns the key
% that was pressed first during that duration if the key index is passed in
% the validKeys vector. If no key is expected to be returned, leave out the
% validKeys argument.

% Initialise the keycode to "not a number" (i.e. nan)
button = nan;

% Calculate how many frames to display the text for
framesToWait = round(duration / self.ifi);
% Display the text for x-many frames, i.e. the duration
for frame = 1:framesToWait
    DrawFormattedText(self.window, message, ...
        'center', 'center', self.white);
    self = self.flip();
    
    % Keep checking if a button was pressed...
    [keyIsDown, ~, tmpkeyCode] = KbCheck();
    if keyIsDown && isnan(button)
        % Extract which key was pressed
        tmpkeyCode = find(tmpkeyCode);
        % Evaluate whether the key is a valid key or not
        if exist('validKeys', 'var') && self.isAValidKey(tmpkeyCode(1), validKeys)
            % Assign the they key code if it is valid
            keyCode = tmpkeyCode(1);
            % Obtain which button was pressed
            button = self.decodeKeyCode(keyCode);
        end
    end
end
end