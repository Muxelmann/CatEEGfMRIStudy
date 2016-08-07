function drawQuarters(self)
% Draws the coloured quarters on the screen in correct
% colouring
Screen('FillRect', self.window, [0.5 0.5 0.5 1], self.answerRects);

Screen('TextSize', self.window, 100);
% Screen('TextColor', self.window, self.black);
for i = 1:size(self.answerRectLabelCoords, 1)
    Screen('DrawText', self.window, self.answerRectLabels(i),...
        self.answerRectLabelCoords(i,1)-50, ...
        self.answerRectLabelCoords(i,2)-50, 1.0);
%     DrawFormattedText(self.window, self.answerRectLabels(i), ...
%         self.answerRectLabelCoords(i,1), ...
%         self.answerRectLabelCoords(i,2), 0);
end
Screen('TextSize', self.window, self.textSize);
% Screen('TextColor', self.window, self.white);
end