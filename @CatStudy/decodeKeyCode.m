function buttonIndex = decodeKeyCode(self, keyCode)
% Obtain the button indices (from 1 left to 4 right) or nan if not correct
switch keyCode
    case self.answerButtons(1); buttonIndex = 1;
    case self.answerButtons(2); buttonIndex = 2;
    case self.answerButtons(3); buttonIndex = 3;
    case self.answerButtons(4); buttonIndex = 4;
    otherwise; buttonIndex = nan;
end
end