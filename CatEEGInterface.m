classdef CatEEGInterface
    % This class creates and upholds a link to the EEG computer to that
    % messages can be sent to it that indicate several events
    
    properties
    end
    
    methods
        function self = CatEEGInterface()
            % This function establishes the connection to the EEG computer
        end
        
        function sendOnset(self, difficulty, change)
            % Transmits when the 1st fixation was presented and the trial
            % has begun, and then also transmits the difficulty of this
            % trial and whether there was a change
            
            fprintf(' :: Tx to EEG = Onset\n');
            self.sendMessage(1);
            
            fprintf(' :: Tx to EEG = Difficulty (%2d)\n', difficulty);
            fprintf(' :: Tx to EEG = Change (%2d)\n', change);
            
        end
        
        function markMemoryArray(self)
            % Transmits when the 1st set of squres was presented to the
            % user
            
            fprintf(' :: Tx to EEG = Memory Array\n');
            self.sendMessage(2);
        end
        
        function markRetentionInterval(self)
            % Transmits when the 2nd fixation (inbetween memory array and
            % test array) was presented
            
            fprintf(' :: Tx to EEG = Retention Interval\n');
            self.sendMessage(3);
        end
        
        function markTestArray(self)
            % Transmits when the test array was presented
            
            fprintf(' :: Tx to EEG = Test Array\n');
            self.sendMessage(4);
        end
        
        function markUserResponse(self, responseNumber, responseValue)
            % Transmit what the user responded to which question
            fprintf(' :: Tx to EEG = Response (\n');
            self.sendMessage(5);
        end
    end
    
    methods (Access = protected)
        function sendMessage(self, value)
            % This method sends a message over the parallel line
            fprintf(' :: -> %3d\n', value);
        end
    end
    
end

