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
        
        % Background colour
        % 0 = black
        % 1 = white (do not use white)
        backgroundColour = 0.0;
        
        % The answering rectangles coordinates
        answerRects
        % The answering rectangle labels
        answerRectLabels = ['1'; '2'; '3'; '4'];
        % Coordinates where the answer labels are displayed
        answerRectLabelCoords
        
        % The rectangle coordinates
        allRects
        % Available rect colours
        rectColourSet = [1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 1];
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
        periodAnswer = [2, 2, 2, 2];
        % The three questions that the user has to answer
        % So far the answers are assigned keys 1,2,3,4 from left to right
        textAnswer = {
            ['Did you see a change?\n\n\n\n\n\n' ...
            '[yes]      [no]'];
            ['How certain are you?\n\n\n\n\n\n' ...
            '[very certain] [certain] [uncertain] [very uncertain]']};
        % Default text size
        textSize = 50;
        
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
        % 49 -> 1 key
        % 50 -> 2 key
        % 51 -> 3 key
        % 52 -> 4 key
        answerButtons = [49 50 51 52]; 
        
        % The link to the EEG computer
        eegInterface = CatEEGInterface();
        % Keeping track of which response is being given
        
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
            
            % Only output critical errors to console. Highest level is 5
            % lowest (i.e. no output) is 0
            Screen('Preferences', 'Verbosity', 1);
            % Removes debug information from the screen
            % 4 display everytging, 3 removes welcome screen, ... 1 nothing
            Screen('Preferences', 'VisualDebugLevel', 3);
            
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
                PsychImaging('OpenWindow', self.screenNumber, ...
                self.backgroundColour);
            
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
            Screen('TextSize', self.window, self.textSize);
            Screen('TextColor', self.window, [1 1 1 1]);
            
            % Now do some setup calculations...
            self = self.setup(skipSquareTest);
        end
        
        self = runTrials(self, varargin)
        
        saveTrial(self, varargin)
        
        tidyUp(~)
        
        self = egg(self, varargin)
    end
    
    methods (Access = protected)
        %% Protected methods
        
        self = flashSquares(self)
        
        self = setup(self, skipSquareTest)
        
        self = computeSquareColouring(self)
        
        self = displaySquares(self, period, inColour)
        
        wait(self, period)
        
        self = userAnswers(self, trial)
        
        correct = isAValidKey(~, keyCode, validKeys)
        
        buttonIndex = decodeKeyCode(self, keyCode)
        
        self = updateDifficulty(self)
        
        location = getLocationFromIndex(self, index)
        
        location = getLocationFromAnswers(~, allAnswers)
        
        correct = wereAnswersCorrect(self, varargin)
        
        %% Functions for printing and refreshing
        
        self = flip(self)
        
        [self, keyCode] = printMessage(self, message, duration, validKeys)
        
        [self, keyCode] = printQuarters(self, duration, validKeys)
        
        drawBlackScreen(self)
        
        drawFixation(self)
        
        drawSquares(self)
        
        drawQuarters(self)
    end
end

