function correct = isAValidKey(~, keyCode, validKeys)
% Checks if a pressed key is a valid input to prevent setting
% false values as an answer
correct = any(keyCode == validKeys);
fprintf('Key Code: %2d -> %2d\n', keyCode, correct);
end