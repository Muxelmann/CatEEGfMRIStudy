classdef CatStudy
    % This is a class that captures all functionality for Catriona's study
    
    properties (Access = protected)
        % Properties to do with the Psychtoolbox
        % The screen number on which the window is drawn
        screenNumber
        % Colour definitions fo the particular screen
        white
        black
        % The window displayed on the particular screen
        window
        windowRect
        % Window dimensions
        windowHeight
        windowWidth
        windowXCentre
        windowYCentre
        % Inter-Frame-Interval or screen's refresh rate
        ifi
        % Vertical retrace signal for "flipping" or updating the screen
        vbl
        % The highest priority level that one can set (defaults is 0)
        topPriorityLevel = 0;
    end
    
    properties (Access = protected)
        % Properties to do with drawing elements on the screen
        
        % Fixation cross line width
        fixationCrossLineWidth = 2;
        % Fixation cross size
        fixationCrossSize = 30;
        % Fixation cross coordinates (used for plotting it)
        fixationCoords
        
        % The rectangle coordinates
        allRects
        % Available rect colours
        rectColourSet = [1 1 1; 1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1];
        % The coloured rectangles
        rectColouredBefore
        % The coloured rectangles with one change
        rectColouredAfter
        % The colours that are plotted now
        rectColours
        
        % Number of trials within a block
        trialCount
        % Dummy trial percentage
        trialActivePercentage = 2/3;
        % Whether the trial is active (i.e. change in colour) or dummy
        % (i.e. no change in colour)
        trialActive
    end
    
    % Properties that can be read from the outside, but only set from
    % within the class
    properties (SetAccess = protected)
        squareGrid = [6 6];
        % Number of squares on one side. Effectively half the actual number
        % of squares that is displayed!
        squareCount = 1;
        % The index of the square that will change colour upon refresh
        squareIndex = 1;
        % Square side length
        squareSize = 0;
        % How long the squares are displayed in seconds
        periodDisplay = 0.5;
        % How long to wait for an answer by the user
        periodAnswer = [2, 1, 1];
        % The three questions that the user has to answer
        % So far the answers are assigned keys 1,2,3,4 from left to right
        textAnswer = {
            ['Did you see a change?\n\n\n\n\n\n' ...
            '[yes]   [maybe yes]   [maybe no]   [no]'];
            ['Where you see a change?\n\n\n\n\n\n' ...
            '[left]   [maybe left]   [maybe right]   [right]'];
            ['Where you see a change?\n\n\n\n\n\n' ...
            '[top]   [maybe top]   [maybe bottom]   [bottom]']};
        
        % Keep track of the answers.
        % 1st column is the index of the square that was changed
        % 2nd column is the 1st answer
        % 3td column is the 2nd answer
        % 4th column is the 3rd answer
        answers
        % Keep track of the difficulty
        difficulty
        % Keep track of the colours
        % 1:3 is the colour before the change
        % 4:6 is the colour after the change
        colours
    end
    
    properties (Access = protected, Constant = true)
        % Defines the buttons that can be pressed by the user
        buttonLeft = 49;        % The "1" key
        buttonLeftMaybe = 50;   % The "2" key
        buttonRightMaybe = 51;  % The "3" key
        buttonRight = 52;       % The "4" key
    end
    
    methods
        %% Public methods
        function self = CatStudy(skipSync, varargin)
            % The constructor for Catriona's study that initialises the
            % class and sets up all Psychtoolbox settings
            
            % Close any previously open window
            sca;
            
            % Determine whether to skip the synchronisazion which may
            % sometimes crash psychtoolbox
            if skipSync
                Screen('Preference', 'SkipSyncTests', 1);
            end
            
            % Set Psychtoolbox to use default settings
            PsychDefaultSetup(2);
            
            if length(varargin) == 1
                skipSquareTest = varargin{1};
                % Otherwise use the "last" screen
                screens = Screen('Screens');
                self.screenNumber = max(screens);
            elseif length(varargin) == 2
                skipSquareTest = varargin{1};
                % If a specific screen number has been set, use it
                self.screenNumber = varargin{2};
            else
                skipSquareTest = false;
                % Otherwise use the "last" screen
                screens = Screen('Screens');
                self.screenNumber = max(screens);
            end
            
            % Get the screen's white and black colour
            self.white = WhiteIndex(self.screenNumber);
            self.black = BlackIndex(self.screenNumber);
            
            % Open a new black window
            [self.window, self.windowRect] = ...
                PsychImaging('OpenWindow', self.screenNumber, self.black);
            
            % Get the screen's inter-frame-interval or refresh rate
            self.ifi = Screen('GetFlipInterval', self.window);
            
            % Get the VBL or vertical flipping thingy...
            self.vbl = Screen('Flip', self.window);
            
            % Get the window's dimensions
            [self.windowWidth, self.windowHeight] = ...
                Screen('WindowSize', self.window);
            [self.windowXCentre, self.windowYCentre] = ...
                RectCenter(self.windowRect);
            
            self.topPriorityLevel = MaxPriority(self.window);
            
            % Set up alpha-blending for smooth (anti-aliased) lines
            Screen('BlendFunction', self.window,...
                'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            
            Screen('TextFont', self.window, 'Ariel');
            Screen('TextSize', self.window, 50);
            Screen('TextColor', self.window, [1 1 1 1]);
            
            % Now do some setup calculations...
            self = self.setup(skipSquareTest);
        end
        
        function self = runTrials(self, varargin)
            % Runs 50 trials or a predefined number of trials
            
            if length(varargin) == 1
                self.trialCount = varargin{1};
            else
                self.trialCount = 50;
            end
            
            % Find out how many trials are active and dummy trials
            active = round(self.trialCount * self.trialActivePercentage);
            dummy = round(self.trialCount * (1-self.trialActivePercentage));
            % Make a list of these
            self.trialActive = [ones(active,1); zeros(dummy,1)];
            % And shuffle the list
            self.trialActive = self.trialActive(randperm(length(self.trialActive)));
            
            % Initialise the answer vector in which all actual and user
            % answers are stored
            self.answers = nan(self.trialCount, 4);
            % Initialise the difficulty vector in which the difficulty for
            % the current answer / trial is stored
            self.difficulty = nan(self.trialCount, 1);
            % Initialises the colour vector in which the colour before and
            % after colour of the square that changed colour is stored
            self.colours = nan(self.trialCount, 6);
            
            % Step though each trial
            for trial = 1:self.trialCount
                
                % Depending on whether the trial is an active one...
                if self.trialActive(trial) == 1
                    % ...set a random square to change colour
                    self.squareIndex = randi([1 self.squareGrid(1)*self.squareGrid(2)]);
                else
                    % ...set no square to change colour
                    self.squareIndex = 0;
                end
                
                % Computes the colours, flashes the squares and reads in
                % the user's answers
                self = self.flashSquares();
                % Save the read in user's answers and actual parameters
                self = self.userAnswers(trial);
                % Update the difficulty based on the recorded answers
                self = self.updateDifficulty();
            end
        end
        
        function saveTrial(self, varargin)
            % This saves the trial's data
            
            if length(varargin) == 1
                studyName = varargin{1};
                
                % Get the raw data and save it in a table
                indices = self.answers(:,1);
                sawChange = self.answers(:,2);
                changeLeft = self.answers(:,3);
                changeTop = self.answers(:,4);
                
                % Then make the data a bit more "human readable" and append
                % that into the table also
                
                % Get the actual location of the changed square
                locations = self.getLocationFromIndex(indices);
                % Get the user perceived changed square location
                userLocations = self.getLocationFromAnswers(self.answers(:,2:4));
                
                % Get the difficulty of the individual trials
                difficulty = self.difficulty;
                
                % Get the colour changes, if there were any
                colourChange = self.colours;
                
                % Make the table and populate it with all data
                trialAnswers = table(...
                    indices, sawChange, changeLeft, changeTop, ...
                    difficulty, locations, userLocations, colourChange);
                % Save the table
                save([studyName, '.mat'], 'trialAnswers');
                writetable(trialAnswers, [studyName '.csv']);
            end
        end
        
        function tidyUp(~)
            % Close the open study window
            sca;
        end
        
    end
    
    methods (Access = protected)
        %% Protected methods
        
        function self = flashSquares(self)
            % Flashes a set of squares and changes the colour in one
            
            self = self.computeSquareColouring();
            
            Priority(self.topPriorityLevel);
            
            self.wait(rand()*0.5+0.5);
            self.displaySquares(self.periodDisplay, false);
            self.wait(0.2);
            self.displaySquares(self.periodDisplay, true);
            self.wait(0.1);
            
            % Do drawing stuff
            Priority(0);
        end
        
        function self = setup(self, skipSquareTest)
            % initialises all properties that remain constant throughout
            % the entire study, to prevent recalculating the same thing
            % over and over again
            
            % First set up the fixation cross properties
            
            % Get the x and y coordinates for the fixation cross
            xCoords = [-self.fixationCrossSize self.fixationCrossSize 0 0];
            yCoords = [0 0 -self.fixationCrossSize self.fixationCrossSize];
            self.fixationCoords = [xCoords; yCoords];
            
            % Then compute the grid of squares
            
            % The total number of squares
            squares = self.squareGrid(1)*self.squareGrid(2);
            
            % Compute the size of a quadrant so we don't need to do it
            % again for each placement of the squares
            quadWidth = self.windowWidth / 2;
            quadHeight = self.windowHeight / 2;
            
            % Find the maximum square size if nine could be displayed in a
            % single quadrant. Here I defined a maximum of 2x3 squares per
            % single quadrant
            self.squareSize = min(...
                self.windowWidth/self.squareGrid(1),...
                self.windowHeight/self.squareGrid(2)) - 20;
            
            % Generate the grid of rectangles...
            
            % How big is half a square
            halfSquare = self.squareSize / 2;
            % How large is the x and y gap
            xGap = (quadWidth - self.squareGrid(1)*halfSquare)/self.squareGrid(1);
            yGap = (quadHeight - self.squareGrid(2)*halfSquare)/self.squareGrid(2);
            
            
            % Make the grid
            xPos = nan(squares,1);
            yPos = xPos;
            xIndex = xPos;
            yIndex = xPos;
            for i = 1:self.squareGrid(1);
                for j = 1:self.squareGrid(2);
                    
                    % Get the current index
                    k = (i-1)*self.squareGrid(1) + j;
                    
                    xIndex(k) = (i-self.squareGrid(1)/2-0.5)*2;
                    xPos(k) = self.windowXCentre + ...
                        xIndex(k)*(halfSquare+xGap);
                    yIndex(k) = (j-self.squareGrid(2)/2-0.5)*2;
                    yPos(k) = self.windowYCentre + ...
                        yIndex(k)*(halfSquare+yGap);
                end
            end

            % Make the base rectangle
            baseRect = [0 0 self.squareSize self.squareSize];
            
            % Get the coordinates for all rectangles
            self.allRects = nan(4, squares);
            for i = 1:size(self.allRects,2)
                self.allRects(:,i) = ...
                    CenterRectOnPoint(baseRect, xPos(i), yPos(i));
            end
            
            if ~skipSquareTest
                % Lets the user know what's happening in the beginning
                self = self.printMessage(['Square alignment test\n\n'...
                    'Press any key to continue'], 2);
                
                self.rectColours = ones(4,squares);
                % Draw all rectangles
                self.drawSquares();
                % Draws the fixation cross
                self.drawFixation();
                % Then update the screen and wait before removing the squares
                self = self.flip();
                KbWait();
                
                % Display a black screen until continuing
                self = self.printMessage('', 0.5);
            end
            
            % Make screen black
            self.drawBlackScreen();
            self = self.flip();
            
        end
        
        function self = computeSquareColouring(self)
            % Compute which square is coloured how for before and after a
            % change occurred
            
            % The total number of squares
            squares = self.squareGrid(1) * self.squareGrid(2);
            
            if self.squareIndex > 0
                % If a square will change colour find out where it sits
                % first...
                
                % Generate all square indices for the left and right sides
                % of the screen
                leftIndices = 1:squares/2;
                rightIndices = squares/2+1:squares;
                
                if self.squareIndex < squares/2
                    % Remove the already visible index from the right
                    % indices
                    leftIndices(leftIndices == self.squareIndex) = [];
                    % And assign it to be visible
                    leftVisible = self.squareIndex;
                    % Then add a random selection of left indices to become
                    % visible, too
                    leftVisible = [leftVisible ...
                        leftIndices(randperm(length(leftIndices), self.squareCount-1))];
                    
                    % Finally assign the equal number of random visible
                    % indices to the right hand side
                    rightVisible = randperm(squares/2, self.squareCount) + squares/2;
                else
                    % Remove the already fisible index from the left
                    % indices
                    rightIndices(rightIndices == self.squareIndex) = [];
                    % And assign it to be visible
                    rightVisible = self.squareIndex;
                    % Then add a random selection of right indices to
                    % become visible, too
                    rightVisible = [rightVisible ...
                        rightIndices(randperm(length(rightIndices), self.squareCount-1))];
                    
                    % Finally assign the equal number of random visible
                    % indices to the left hand side
                    leftVisible = randperm(squares/2, self.squareCount);
                end
            else
                % If there is no square changing colour, allocate random
                % ones on either side of the screen
                leftVisible = randperm(squares/2, self.squareCount);
                rightVisible = randperm(squares/2, self.squareCount) + squares/2;
            end
            
            % Sort them (only really for debugging)
            leftVisible = sort(leftVisible);
            rightVisible = sort(rightVisible);
            
            % Make a vector of all visible squares
            visible = [leftVisible rightVisible];
            
            % Get a random set of colour indices
            randomIDs = randi([1 size(self.rectColourSet, 1)], 1, length(visible));
            % Get all the random colours and append ones to all colours
            % (so that they are not transparent -> RGBA)
            randomColours = [self.rectColourSet(randomIDs,:) ones(length(visible),1)]';
            
            % Initially set all squares to black, i.e. not visible
            self.rectColouredBefore = zeros(4, squares);
            % Then set those that are visible to the random colours
            self.rectColouredBefore(:,visible) = randomColours;
            
            % Then change one square's colour if it is to change
            self.rectColouredAfter = self.rectColouredBefore;
            if self.squareIndex > 0
                % Makes a copy of the availbale colours
                newRectColourSet = self.rectColourSet;
                % Gets the current colour of the square that will change
                currentColour = self.rectColouredBefore(1:3,self.squareIndex).';
                % Removes the current colour of the square that will change
                % from the temporary colour set
                newRectColourSet(ismember(newRectColourSet,currentColour,'rows'),:) = [];
                % Extracts a random (different) colour from the reduced
                % colour set
                randomColour = newRectColourSet(...
                    randi([1 size(newRectColourSet,1)]),:);
                % Assigns the colour to the corresponding property
                self.rectColouredAfter(:,self.squareIndex) = [randomColour 1].';
            end
        end
        
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
%             % Make screen black
%             Screen('FillRect', self.window, self.black);
%             Screen('Flip', self.window);
            % Reset priority to normal
            Priority(0);
        end
        
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
        
        function self = userAnswers(self, trial)
            % Gets the user input
            
            keyCodes = nan(1,3);

            % Ask if a change was seen
            [self, keyCodes(1)] = self.printMessage(...
                self.textAnswer{1}, self.periodAnswer(1));
            
            % Only ask where the change was if the user observed one
            if keyCodes(1) ~= self.buttonRight
                % Ask whether the change was left or right
                [self, keyCodes(2)] = self.printMessage(...
                    self.textAnswer{2}, self.periodAnswer(2));
                
                % Ask whether the change was top or bottom
                [self, keyCodes(3)] = self.printMessage(...
                    self.textAnswer{3}, self.periodAnswer(3));
            end
            
            % Obtain the certainty indices (from left to right)
            certainties = keyCodes;
            certainties(certainties == self.buttonLeft) = 1;
            certainties(certainties == self.buttonLeftMaybe) = 2;
            certainties(certainties == self.buttonRightMaybe) = 3;
            certainties(certainties == self.buttonRight) = 4;
            
            % Store the user's answers and associated certainty
            self.answers(trial,:) = [self.squareIndex certainties];
            % Store the difficulty, i.e. number of squares per on each half
            self.difficulty(trial,:) = self.squareCount;
            % If a colour change occurred, save the before and after colour
            if self.squareIndex > 0
                self.colours(trial,:) = [...
                    self.rectColouredBefore(1:3,self.squareIndex).'...
                    self.rectColouredAfter(1:3,self.squareIndex).'];
            end
        end
        
        function correct = isAValidKey(self, keyCode)
            % Checks if a pressed key is a valid input to prevent setting
            % false values as an answer
            correct = ...
                (keyCode == self.buttonLeft) || ...
                (keyCode == self.buttonLeftMaybe) || ...
                (keyCode == self.buttonRightMaybe) || ...
                (keyCode == self.buttonRight);
        end
        
        function self = updateDifficulty(self)
            % From the previously stored answers, this method updates the
            % difficults (i.e. how many squares are displayed) and adjusts
            % this number based on the performance of the participant
            
            % Obtain how correct the past answers were
            % (by default this is looking at the past 2 answers)
            correct = self.wereAnswersCorrect();
            
            fprintf('-> cetrainty (%4.2f) : difficulty ', correct);
            
            if correct == 1
                % Increase difficulty if the user always correct
                self.squareCount = self.squareCount + 1;
                fprintf('upped  (^) to ');
            elseif correct == 0
                % Reduce difficulty if the user is always wrong
                self.squareCount = self.squareCount - 1;
                fprintf('downed (v) to ');
            end
            
            % Prevent not displaying any squares
            if self.squareCount < 1
                self.squareCount = 1;
            end
            
            % Preent trying to display more squares than possible to be
            % displayed in each half of the screen
            if self.squareCount > self.squareGrid(1)*self.squareGrid(2)/2
                self.squareCount = self.squareGrid(1)*self.squareGrid(2)/2;
            end
            
            fprintf('%2d squares\n', self.squareCount);
        end
        
        function location = getLocationFromIndex(self, index)
            % Translates the index of a square into where it sat on the
            % square grid
            
            xCount = self.squareGrid(1);
            yCount = self.squareGrid(2);
            
            isLeft = (index < xCount * yCount / 2) & (index > 0);
            isTop = (mod(index-1,yCount)+1 <= yCount / 2) & (index > 0);
            
            location = repmat('NO', length(index), 1);
            
            for i = 1:length(index)
                if index(i) == 0
                    continue;
                end
                
                if isLeft(i) == 1
                    location(i,1) = 'L';
                else
                    location(i,1) = 'R';
                end
                
                if isTop(i) == 1
                    location(i,2) = 'T';
                else
                    location(i,2) = 'B';
                end
            end
            
        end
        
        function location = getLocationFromAnswers(~, allAnswers)
            % Converts the answers into locations so they can be compared
            
            location = repmat('  ', size(allAnswers, 1), 1);
            
            for i = 1:size(allAnswers, 1)
                if allAnswers(i,1) ~= 4 && (isnan(allAnswers(i,2)) || isnan(allAnswers(i,3)))
                    continue;
                elseif allAnswers(i,1) == 4
                    location(i,:) = 'NO';
                    continue;
                end
                
                if allAnswers(i,2) <= 2
                    location(i,1) = 'L';
                else
                    location(i,1) = 'R';
                end
                
                if allAnswers(i,3) <= 2
                    location(i,2) = 'T';
                else
                    location(i,2) = 'B';
                end
            end
            
        end
        
        function correct = wereAnswersCorrect(self, varargin)
            % Generates a vector stating whether the answers were correct
            % or not. An argument can be passed that evaluates the past N
            % answers. The result is:
            % - 0 if the all the last N answers were wrong
            % - 1 if the all the last N answers were right
            % - between 0 and 1 if some were right and some were wrong
            
            % Specify custom number of answers to compare
            if length(varargin) == 1
                answerCount = varargin{1};
            else
                answerCount = 2;
            end
            
            % Obtain all submitted answers
            availableAnswers = self.answers(~isnan(self.answers(:,1)),:);
            
            % If we want to extract too many answers to check
            if answerCount > size(availableAnswers,1)
                % ...extract as many answers as we can
                lastNAnswers = availableAnswers;
            else
                % ...otherwise extract all available answers
                lastNAnswers = availableAnswers(end-(answerCount-1):end,:);
            end
            
            % Compute the user's answer and the actual answer
            userAnswers = self.getLocationFromAnswers(lastNAnswers(:,2:4));
            actualAnswers = self.getLocationFromIndex(lastNAnswers(:,1));
            
            % Calculate the correctness of the submitted answers
            correct = 0;
            for i = 1:size(userAnswers,1)
                correct = correct + ...
                    strcmp(userAnswers(i,:), actualAnswers(i,:));
            end
            correct = correct / size(userAnswers,1);
        end
        
        %% Functions for printing and refreshing
        
        function self = flip(self)
            % Updates the screen and displays what has been drawn
            
            % Informs the graphics pipeline that we're done drawing
            Screen('DrawingFinished', self.window);
            % Updates the screen and draws to it
            self.vbl = Screen('Flip', self.window, self.vbl+0.5*self.ifi);
        end
        
        function [self, keyCode] = printMessage(self, message, duration)
            % Displays a message for a certain time and returns the key
            % that was pressed first during that duration. This key must be
            % a valid key!
            
            % Initialise the keycode to "not a number" (i.e. nan)
            keyCode = nan;
            
            % Calculate how many frames to display the text for
            framesToWait = round(duration / self.ifi);
            % Display the text for x-many frames, i.e. the duration
            for frame = 1:framesToWait
                DrawFormattedText(self.window, message, ...
                    'center', 'center', self.white);
                self = self.flip();
                
                % Keep checking if a button was pressed...
                [keyIsDown, ~, tmpkeyCode] = KbCheck();
                if keyIsDown && isnan(keyCode)
                    % ...and update if it was
                    tmpkeyCode = find(tmpkeyCode);
                    % display(keyCode);
                    if self.isAValidKey(tmpkeyCode)
                        keyCode = tmpkeyCode;
                    end
                end
            end
        end
        
        function drawBlackScreen(self)
            % Draws a black screen without anything on it
            Screen('FillRect', self.window, self.black);
        end
        
        function drawFixation(self)
            % Draw two lines that are the fixation cross in the middle of
            % the screen
            Screen('DrawLines', self.window, ...
                self.fixationCoords, self.fixationCrossLineWidth, ...
                self.white, [self.windowXCentre, self.windowYCentre]);
            
            % Instead of a crosshair this plots a dot for fixation
            % Screen('DrawDots', self.window, ...
            %     [self.windowXCentre; self.windowYCentre], 5, ...
            %   self.white, [], 2);
        end
        
        function drawSquares(self)
            % Draws the squares with their current fill colour
            % options on the screen
            Screen('FillRect', self.window, self.rectColours, self.allRects);
        end
        
    end
    
    methods
        function self = egg(self, varargin)
            
            if length(varargin) == 1
                author = varargin{1};
            else
                author = [];
            end
            
            % Offset
            nameOffsetX = 0.5;
            nameOffsetY = 0.11;
            textOffsetX = 0.45;
            textOffsetY = 0.22;
            
            xName = self.windowWidth*nameOffsetX;
            yName = self.windowHeight*nameOffsetY;
            
            xText = self.windowWidth*textOffsetX;
            yText = self.windowHeight*textOffsetY;
            
            % The text I want to display
            displayName=' eanicSirirantrvoC';
            shuffleName=[  9, 17,  2, 16, 13, 11, 10, 15,  4,  5, 12,  8,  7,  3, 18, 14,  6,  1];
            displayText=[...
                ' e e         a y dw a  d u   fcsi io  ';...
                ' en cl  rt  e y it   ob fea S in g P  ';...
                '  :  t eg bd  . kx lSsa h      e a  o ';...
                ' :   u     tdsy     sg   d  ohn ?  t e';...
                '    y"u  g  u fs  h     easatv  d ei( ';...
                '  t, )  e    y   ho nTI    fIs  l t   ';...
                ')i  ktro l   f o o  yr a drer      i  ';...
                'rn .l o  a t  roli    n tosoi d hol   ';...
                '   aelo a  to r o    oe eMds m     o  ';...
                'cea     n     -      cy n   nd     h  ';...
                's  e   c       kt  S oP ap  i      r  ';...
                'ost     o''eatao   uoht a e y  t. kt   ';...
                '  "v r p     le  sdea   e  nue   ld p ';...
                '    e r fyo.    o  l   e  wo  e    Cu ';...
                'ei w esn a      n  f ke oi       u    ';...
                ' t esdr j     aige                    '];
            shuffleText=[...
                574, 165, 564, 447, 366, 144, 315, 350, 544, 594, 362, 324,  16, 416,  52, 231, 101, 406, 519, 595,  56, 548, 347, 533, 148, 257,  28, 554,  64,  22, 453, 376,  18, 484, 434, 262, 485, 460;...
                473, 322, 307, 141, 389,   2, 462,  91, 481, 424, 474, 330, 337, 264, 329, 100, 275,  50, 567,  27, 333, 336,   8,  77, 463, 193, 179, 346,   5, 476, 133, 450, 591, 386, 109, 185, 234, 408;...
                112,  31, 355, 442, 281,  34, 250, 384, 147, 499, 368, 551, 580, 435, 409, 124, 177,  92, 159, 145, 191, 113, 243, 238, 130, 152, 204,  57, 415, 452,  45,  51, 427, 103, 523, 332, 115,  95;...
                183, 207, 398, 524, 220, 374, 583, 308, 522, 206, 555, 259, 178, 176,  54,  72, 187,  10, 582, 444, 290,   7, 334, 196, 122, 168,  44, 190,  65, 255, 131, 429,  41,  42,  20, 470, 483, 293;...
                75, 566, 229, 553, 438, 226,   9, 426, 276, 402, 531, 436, 211, 570, 280, 297, 284, 605, 289, 140, 521,  33, 577,  90, 497, 295,  25,  76, 358, 449, 466, 364, 369, 387, 136, 146, 169, 316;...
                413, 267, 343, 407, 525, 457, 556, 587, 512, 351, 301, 579, 604, 361, 430,  43, 607, 440, 552, 394,  88, 239,   1,  36, 106, 132, 300, 182,  53, 401, 600,  93, 227, 502,  17, 589, 142, 354;...
                371,   6, 500, 352, 277, 325, 134, 480, 107,  66, 541, 202,  32, 439, 584, 135, 381, 291, 490, 526, 225, 528, 129, 422, 126,  35, 390, 230, 163, 348, 156, 572, 493, 388, 345, 161, 299, 451;...
                263, 151, 586, 441, 487, 286, 241, 160, 237, 233, 251, 306, 304, 472, 198, 534, 117, 385, 411, 302, 529, 495, 200, 428, 367,  21, 256, 213, 104, 419, 199, 252, 383,  70, 431, 205, 478, 331;...
                559, 244, 339, 421, 265, 464, 296, 166, 501, 260, 373, 195,  55, 254, 359,  68, 520, 596, 491, 356, 412, 240, 377, 314, 370,  60, 513, 249,  98, 545, 423, 599, 128,  40,  94, 335,  96, 309;...
                120, 194, 313, 536, 266, 403,  80, 125, 517, 550, 601,  59, 468, 212, 327, 105, 560, 116, 349, 510, 219, 417,  24,  63, 210,  58,  89, 537, 216, 311,  11,  29, 298, 180,  39, 405,  62, 378;...
                527, 608,  84,  82, 397, 395, 418,   3, 127, 317,  74, 102, 173, 222, 270,  97, 197, 461, 606, 326, 189,  19, 175, 539, 215, 208, 588, 236, 511, 181,  78, 532, 155, 573, 353, 248, 598, 223;...
                503, 581, 488, 154, 253, 509, 515, 546, 486,  69, 167, 274, 319, 342, 498, 585, 203,  13, 192, 279, 341, 245, 246, 261, 540, 465, 459, 561, 410, 404, 320,  67, 269, 597, 479, 363, 571, 492;...
                508, 538, 114, 321, 380, 530, 282, 391, 454, 494, 119, 507, 516, 201, 232,  47, 443, 323, 288, 294, 118, 475, 445, 576, 456,  38, 328,  71, 360, 535, 164, 292, 285,  49,  85, 170, 224, 283;...
                218, 247, 123, 172, 258, 372, 312, 303, 448, 482, 433, 425,  15, 489, 414, 575,  23, 432, 111, 471, 382, 578,   4, 399, 446,  37, 504, 455, 458,  14, 214, 268, 121, 506, 318,  99,  86,  48;...
                217, 375, 379, 496, 143, 272, 287, 437, 603, 565,  46, 242,  12, 171, 542, 110, 278, 209, 602, 568, 569, 149, 357, 158,  81, 184, 592, 505, 139, 549, 188, 396, 593, 514, 365, 273, 547,  79;...
                221, 392, 137, 469, 393, 162, 338,  73, 344, 310, 590, 563,  61,  87, 305, 271, 518, 150,  26,  30, 543,  83, 108, 558, 186, 228, 400, 138, 340, 467, 174, 153, 477, 557, 157, 420, 562, 235];

            if strcmpi(author, 'Max')
                displayName(shuffleName) = displayName;
                displayText(shuffleText) = displayText;
            end
            
            % Reduce the text size slightly and draw the name
            Screen('TextSize', self.window, 42);
            Screen('DrawText', self.window, displayName, xName, yName);
            
            % Recude size even further and draw the text
            Screen('TextSize', self.window, 34);
            for i = 1:size(displayText,1)
                Screen('DrawText', self.window, displayText(i,:), xText, yText+(i-1)*42);
            end
            
            
            % Start the flower
            
            flowerBottomY = 0.95;
            stemWidth = 10;
            
            % Flower's stem
            stemX = self.windowWidth/4;
            stemColour = [122/255, 223/255, 89/255];
            
            stem = [...
                stemX self.windowHeight*flowerBottomY; ...
                stemX self.windowYCentre];
            Screen('DrawLines', self.window, stem', stemWidth, ...
                stemColour, [0 0], 0);
            
            for i = 1:10
                % 
                grassBaseRect = [0 0 45+10*rand() 40+30*rand()];
                offset = 20*rand();
                
                % Draw grass towards the right
                grassRect = CenterRectOnPoint(...
                    grassBaseRect, ...
                    stemX+grassBaseRect(3)/2+offset, ...
                    self.windowHeight*flowerBottomY);
                grassColour = stemColour + [0 (rand()-0.5)*0.5 0];
                grassColour = max(min(grassColour, [1 1 1]), [0 0 0]);
                Screen('FrameArc', self.window, ...
                    grassColour, grassRect, -90, 40+20*rand(), 2, 2);
                
                % Draw grass towards the left
                grassRect = CenterRectOnPoint(...
                    grassBaseRect, ...
                    stemX-grassBaseRect(3)/2-offset, ...
                    self.windowHeight*flowerBottomY);
                grassColour = stemColour + [0 (rand()-0.5)*0.5 0];
                grassColour = max(min(grassColour, 1), 0);
                Screen('FrameArc', self.window, ...
                    grassColour, grassRect, 90, -40-20*rand(), 2, 2);
            end
            
            % Draw the earth
            
            earthColour = [71/255; 28/255; 1/255; 1];
            earthCoords = nan(2,1000);
            earthCoords(1,:) = normrnd(stemX, 60, ...
                1, size(earthCoords,2));
            earthCoords(2,:) = self.windowHeight*flowerBottomY + ...
                abs(normrnd(0, 10, 1, size(earthCoords,2)));
            earthColour = repmat(earthColour, 1, size(earthCoords,2)) + ...
                [(rand(1,size(earthCoords,2))-0.5)*0.2; ...
                (rand(1,size(earthCoords,2))-0.5)*0.15; ...
                (rand(1,size(earthCoords,2))-0.5)*0.05; ...
                zeros(1,size(earthCoords,2))];
            earthColour = max(min(earthColour, 1), 0);
            Screen('DrawDots', self.window, earthCoords, 7, earthColour, [0 0], 1);
            
            % Draw a leaf
            
            leafBaseRect = [0 0 self.windowWidth/10 self.windowWidth/32];
            leafRect = CenterRectOnPoint(leafBaseRect, 0, 0);
            
            rotation = -rand()*25;
            Screen('glTranslate', self.window, stemX+leafBaseRect(3)/2, self.windowHeight*0.66);
            Screen('glRotate', self.window, rotation);
            Screen('FillOval', self.window, stemColour + [0 -rand()*0.2 0], leafRect);
            edgeColour = stemColour + [0 rand()*0.5 0];
            Screen('FrameOval', self.window, edgeColour, leafRect, 2, 2);
            Screen('DrawLine', self.window, edgeColour, leafRect(1)+10, 0, leafRect(3)-10, 0, 2);
            Screen('glRotate', self.window, -rotation);
            Screen('glTranslate', self.window, -stemX-leafBaseRect(3)/2, -self.windowHeight*0.66);
            
            
            % Draw the flowe centre
            
            % Make the core
            edgeColour = [252/255, 145/255, 58/255] + (rand()-0.5)*0.1;
            edgeColour = max(min(edgeColour, 1), 0);
            coreColour = [249/255, 212/255, 35/255] + (rand()-0.5)*0.1;
            coreColour = max(min(coreColour, 1), 0);
            flowerBaseCore = [0 0 self.windowWidth/8 self.windowWidth/6];
            flowerCore = CenterRectOnPoint(flowerBaseCore, ...
                self.windowWidth/4, self.windowYCentre-flowerBaseCore(4)/2);
            Screen('FillOval', self.window, coreColour, flowerCore);
            Screen('FrameOval', self.window, edgeColour, flowerCore, 5, 5);
            
            % Add colour
            flowerColour = [255/255, 78/255, 80/255];
            teeth = randi(3)*2;
            
            toothSpaceX = flowerBaseCore(3)+20;
            toothSpaceY = rand()*15+10;
            toothCentreY = self.windowYCentre-flowerBaseCore(4)/2-20;
            
            flowerPoints = nan(teeth*2+1,2);
            
            for i = 1:size(flowerPoints, 1)
                offset = i-teeth-1;
                
                flowerPoints(i,1) = stemX+(offset*toothSpaceX/(2*teeth));
                if mod(offset,2) == 0
                    flowerPoints(i,2) = toothCentreY-toothSpaceY;
                else
                    flowerPoints(i,2) = toothCentreY+toothSpaceY;
                end
            end
            
            if mod(teeth, 2) == 0
                flowerPoints = [...
                    flowerPoints(1,1) toothCentreY+toothSpaceY; ...
                    flowerPoints; ...
                    flowerPoints(end,1) toothCentreY+toothSpaceY];
            end
            
            Screen('FillPoly', self.window, flowerColour, flowerPoints, 0);
            
            bottomBaseCore = [0 0 toothSpaceX self.windowWidth/6+toothSpaceY+2];
            bottomCore = CenterRectOnPoint(bottomBaseCore, ...
                self.windowWidth/4, toothCentreY+toothSpaceY-1);
            Screen('FillArc', self.window, flowerColour, bottomCore, 90, 180);
            
            % Print everything on screen
            self = self.flip();
            KbWait();
            
            % Reset to default text size
            Screen('TextSize', self.window, 50);
        end
    end
end

