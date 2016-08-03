function NERD_TG( subject_ID, TGOutputFileName )
% Trust Game task
    % coded by Desmond Ong (dco@stanford.edu)


if(nargin<1)
        studyDir = pwd; % gets current working directory   
        subject_ID = input('Please enter your Subject ID: ');
        dateTimeNow = clock;
        TGOutputFileName = [studyDir '\Data\NERD_' num2str(subject_ID) '_AC_Data_' num2str(dateTimeNow(1)) '_' num2str(dateTimeNow(2)) '_' ...
            num2str(dateTimeNow(3)) '_' num2str(dateTimeNow(4)) '_' num2str(dateTimeNow(5)) '.csv'];
end

    %KbName('UnifyKeyNames');
    try

        % ---------- Window Setup ----------
        % Opens a window.

        % Screen is able to do a lot of configuration and performance checks on
        % open, and will print out a fair amount of detailed information when
        % it does.  These commands supress that checking behavior and just let
        % the demo go straight into action.  See ScreenTest for an example of
        % how to do detailed checking.
        oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
        oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

        % Find out how many screens and use largest screen number.
        whichScreen = max(Screen('Screens'));

        % Hides the mouse cursor
        HideCursor;

        % Opens a graphics window on the main monitor (screen 0).  If you have
        % multiple monitors connected to your computer, then you can specify
        % a different monitor by supplying a different number in the second
        % argument to OpenWindow, e.g. Screen('OpenWindow', 2).
        [window, windowDims] = Screen('OpenWindow', whichScreen);

        %a rect is given by [RectLeft, RectTop, RectRight, RectBottom]. 

        % Updates the screen to reflect our changes to the window.
        %Screen('Flip', window);

        % Always call Screen Flip to draw buffer to screen!! Call it before waiting 

        % Tell Matlab to stop listening to keyboard input
        ListenChar(2);



        % ------- Start of TG Instructions Phase ---------- %

        black = BlackIndex(window);
        TGIntructions1 = imread('images/TGpart1.png');
        TGIntructions2 = imread('images/TGpart2.png');
        repeatInstructions = 1;
        while repeatInstructions
            Screen('TextFont',window, 'Helvetica');
            Screen('TextSize',window, 14);
            Screen('DrawText', window, 'Today, you will be playing multiple rounds of an Investment Game.', 40, 40, black);
            Screen('DrawText', window, 'There are two players, Player A (the investor) and Player B (the broker).', 40, 80, black);
            Screen('DrawText', window, 'In the first half of a round, Player A receives $10 and has to decide how much to invest by giving to Player B.', 40, 120, black);
            Screen('DrawText', window, 'Player A will get to keep whatever money he or she does not invest.', 40, 160, black);
            %Screen('DrawText', window, 'Say that A invests $X by giving it to B', 300, 250, black);

            Screen('PutImage', window, TGIntructions1, [300, 250, 700, 650]);

            Screen('DrawText', window, 'Press a key to continue', 400, 650, [255, 0, 0]);
            Screen('Flip', window); 
            pause(0.5);
            KbWait;


            Screen('DrawText', window, 'B will automatically triple whatever amount A invests.', 50, 40, black);
            Screen('DrawText', window, 'Now B has to decide how much to pay back to A.', 50, 80, black);
            Screen('DrawText', window, 'B will keep whatever money not paid back to A.', 50, 120, black);
            %Screen('DrawText', window, 'Say that B repays $Y to A', 300, 250, black);

            Screen('PutImage', window, TGIntructions2, [300, 250, 700, 650]);

            Screen('DrawText', window, 'Press a key to continue', 400, 650, [255, 0, 0]);
            Screen('Flip', window);
            pause(0.5);
            KbWait;

            Screen('DrawText', window, 'To summarize, 1) A invests.', 50, 30, black);
            Screen('DrawText', window, '2) B will triple the amount that A invests, and choose how much to give back.', 50, 70, black);
            Screen('DrawText', window, 'For example, if A invests $7 (out of $10), and if B returns $12 (out of $21),', 50, 110, black);
            Screen('DrawText', window, 'A will have ($10-$7+$12), or a total of $15, ', 50, 150, black);
            Screen('DrawText', window, 'while B will have ($21-$12), or a total of $9.', 50, 190, black);

            Screen('PutImage', window, TGIntructions1, [400, 240, 600, 440]);
            Screen('PutImage', window, TGIntructions2, [410, 440, 610, 640]);

            Screen('DrawText', window, 'Press Y if you understand, or anything else to repeat.', 250, 690, [255, 0, 0]);
            Screen('Flip', window); 

            pause(0.5);

            yKey=89; %Windows Keycode
            %yKey=28; %Unified Keycode
            [secs, keyCode, deltaSecs] = KbWait;
            if(KbName(KbName(keyCode)) == yKey)
                repeatInstructions=0;
            end

        end % end repeatInstruction loop

        Screen('DrawText', window, 'Today, you will be playing as player B', 50, 40, black);
        Screen('DrawText', window, 'You will be play 10 rounds with another participant who will be the investor.', 50, 80, black);
        %Screen('DrawText', window, 'You will paid in real money based on one randomly chosen round.', 50, 120, black);

        Screen('DrawText', window, 'Press a key to continue', 400, 650, [255, 0, 0]);
        Screen('Flip', window);
        pause(1);
        KbWait;


        Screen('DrawText', window, 'Synchronizing computers...', 400, 300, black);
        Screen('Flip', window);
        pause(3.5);

        Screen('DrawText', window, 'Computers synchronized!', 400, 400, black);
        Screen('DrawText', window, 'Press a key when you are ready.', 375, 600, [255, 0, 0]);
        Screen('Flip', window);
        pause(0.5);
        KbWait;

        % ------- End of TG Instructions Phase ---------- %
        % ------- Start of TG Phase ---------- %


        inputXposition = 400;
        inputYposition = 400;

        MULTIPLIER = 3;

        investments = zeros(1,10);
        repayments = zeros(1,10);
        learningRate = zeros(1,10);
        expectedValueRatio = 1.2;

        % Loop over 10 rounds of the game
        for trialNumber=1:10

        FlushEvents();    % This is VERY important. It deletes any previous keypresses that may still be lingering in Matlab memory


        Screen('TextFont',window, 'Helvetica');
        Screen('TextSize',window, 20);
        Screen('DrawText', window, ['Round ' num2str(trialNumber)], 450, 40, black);
        Screen('TextSize',window, 16);
        Screen('DrawText', window, 'Player A is deciding how much to invest... ', 200, 300, black);

        Screen('DrawText', window, 'Please wait for Player A''s decision.', 200, 500, [255 0 0]);

        Screen('Flip', window);
        pauseAmount = 3+2*rand;
        pause(pauseAmount);


        % --- deciding investment amount --- %
        %Variable decreasing learning rate: 
        %for positive PE, uniformly drawn between [0.5 and 0.75] on first round to [0.25 and 0.5] on last round
        %for negative PE, uniformly drawn between [1.00 and 1.25] on each round to [0.5 to 0.75] on last round

        learningRateLowerBound = (trialNumber*(.25) + (10-trialNumber)*(.5))/10;
        randProp = rand();

        if (trialNumber==1)
            investments(trialNumber)=5; % start with initial investment of 5.
        else
            if((repayments(trialNumber-1) - expectedValueRatio*investments(trialNumber-1)) >0)
                learningRate(trialNumber) = learningRateLowerBound + (randProp * .25)
            else
                learningRate(trialNumber) = 2*learningRateLowerBound + (randProp * .25)
            end

            if (trialNumber==6)
            % Boost
            investments(trialNumber) = investments(trialNumber-1) + ...
                learningRate(trialNumber)*(repayments(trialNumber-1) - expectedValueRatio*investments(trialNumber-1)) +...
                .5*(10 - investments(trialNumber-1));
            else
            investments(trialNumber) = investments(trialNumber-1) + ...
                learningRate(trialNumber)*(repayments(trialNumber-1) - expectedValueRatio*investments(trialNumber-1));
            end
        end
            % Cap it between 0 and 10
            investments(trialNumber) = max(min(investments(trialNumber),10),1);
            % Round to nearest 0.50
            investments(trialNumber) = round(investments(trialNumber)*2)/2;
            investment=investments(trialNumber);

        Screen('TextFont',window, 'Helvetica');
        Screen('TextSize',window, 20);
        Screen('DrawText', window, ['Round ' num2str(trialNumber)], 450, 40, black);
        Screen('TextSize',window, 16);
        Screen('DrawText', window, 'Player A has decided to invest: ', 100, 100, black);
        Screen('DrawText', window, ['$' num2str(investment)], 420, 100, [255,0,0]);
        Screen('DrawText', window, 'You have tripled it after investing, and now you have: ', 100, 150, black);
        Screen('DrawText', window, ['$' num2str(MULTIPLIER*investment)], 660, 150, [255,0,0]);
        Screen('DrawText', window, 'Please enter how much you want to give back to A (without the $), then press enter.', 100, 200, black);

        Screen('DrawText', window, ' Enter the amount you want to give back to A. ', inputXposition-150, inputYposition, black);
        Screen('Flip', window);



            % ---------- Key Input -----------
            %escapeKey = KbName('ESCAPE');
            
            %% changed back to windows key...
            escapeKey = 27; %41;
            %windows: esc; Mac OSX: ESCAPE
            returnKey = 13; %40;
            backspaceKey = 8;%42;
            periodKey = 190;%55;
            periodKey2 = 190;%99; %% to update once I find out periodKey2 for windows
     %       startSecs = GetSecs;

            %KbName('UnifyKeyNames');
            %output = GetEchoNumber(window, 'Type a value', ratingX, ratingY, [90,90,90], [0,0,0]);

            strInput='';

            % exit is a boolean to keep going. so if exit == 1, program exits.
            exit = 0;
            while ~exit
                %[ keyIsDown, timeSecs, keyCode ] = KbCheck;
                [secs, keyCode, deltaSecs] = KbWait([], 3);
                
                    %KbName mapping for Windows:
                    % 0 -- 48
                    % 1 -- 49
                    % 9 -- 57

                    %KbName mapping for Unified / Mac:
                    % 1 -- 30
                    % 9 -- 38
                    % 0 -- 39
                
                %if keyIsDown
                    key=KbName(keyCode);
                    
                    % If two or more keys are pressed, take first one
                    if (iscell(key))
                        key=key(1);
                    end
                    
                    %if (strcmp(key,'Return'))
                    %    keyCodeNum = 40;
                    %else
                        keyCodeNum = KbName(key);
                    %end

                    if (KbName(key)>47 && KbName(key)<58) %(keyCodeNum>29 && keyCodeNum<40) 
                        %if (keyCodeNum==39)
                        %    strInput = [strInput num2str(keyCodeNum-39)];
                        %else
                        %    strInput = [strInput num2str(keyCodeNum-29)];
                        %end
                        strInput = [strInput num2str(KbName(key)-48)];
                    elseif (keyCodeNum==periodKey || keyCodeNum==periodKey2)
                        strInput = [strInput '.'];
                    elseif (keyCodeNum==backspaceKey)
                        if ~isempty(strInput) % if string is not empty
                            strInput = strInput(1:length(strInput)-1);
                        end
                    %elseif (KbName(key)==escapeKey)
                    %    exit=1;
                    %    break;
                    elseif (keyCodeNum==returnKey)
                        strValue = str2double(strInput);
                        if (strValue<= (MULTIPLIER*investment) && strValue>=0)

                        % add confirmation ("are you sure you want to invest X? (y/n)")

                            exit=1;
                            break
                        else
                            Screen('DrawText', window, ['Enter a number between 0 and ' num2str(MULTIPLIER*investment) '.'], 400, 650, [255, 0, 0]);
                        end
                    end
                        Screen('TextSize',window, 20);
                        Screen('DrawText', window, ['Round ' num2str(trialNumber)], 450, 40, black);
                        Screen('TextSize',window, 16);
                        Screen('DrawText', window, 'Player A has decided to invest: ', 100, 100, black);
                        Screen('DrawText', window, ['$' num2str(investment)], 420, 100, [255,0,0]);
                        Screen('DrawText', window, 'You have tripled it after investing, and now you have: ', 100, 150, black);
                        Screen('DrawText', window, ['$' num2str(MULTIPLIER*investment)], 660, 150, [255,0,0]);
                        Screen('DrawText', window, 'Please enter how much you want to give back to A (without the $), then press enter.', 100, 200, black);

                        Screen('DrawText', window, strInput, inputXposition, inputYposition, [0,0,255], [0,0,0]);
                        Screen('Flip', window);
                %end
                %while KbCheck; end % waits until key is lifted.
            end

            repayments(trialNumber) = strValue;

            % writes output to file
            dlmwrite(TGOutputFileName, [subject_ID, trialNumber, ...
                learningRate(trialNumber), ...
                investments(trialNumber), repayments(trialNumber)], '-append'); 

        end

        %dataToWrite = [num2str(investments(1)) ', ' num2str(repayments(1))];
        %for j=2:10
        %    dataToWrite = [dataToWrite ', ' num2str(investments(j)) ', ' num2str(repayments(j))];
        %end
        %dlmwrite(WideOutputFileName, [subject_ID, dataToWrite], '-append');  
        
        randomRound = ceil(rand()*10);
        payment = investments(randomRound)*3 - repayments(randomRound);

        % ------- End of TG Phase. Last Screen ---------- %

        Screen('TextFont',window, 'Helvetica');
        Screen('TextSize',window, 16);
        Screen('DrawText', window, 'You are finished with this part of the study! Thank you. ', 100, 200, black);
        %Screen('DrawText', window, ['You will be paid $' num2str(payment) ' based on the actions in Round ' num2str(randomRound)], 100, 240, black);

        Screen('DrawText', window, 'Please inform the experimenter that you have completed this part.', 100, 400, [255 0 0]);

        Screen('Flip', window);
        KbWait;



        % Tell Matlab to start listening to keyboard input again
        ListenChar(0);

            % ---------- Window Cleanup ---------- 

        % Closes all windows.
        Screen('CloseAll');

        % Restores the mouse cursor.
        ShowCursor;

        % Restore preferences
        Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
        Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);

        % Close and Clear Everything
        clear all;
    catch

        % ---------- Error Handling ---------- 
        % If there is an error in our code, we will end up here.


        % Tell Matlab to start listening to keyboard input again
        ListenChar(0);
        %ListenChar(1);

        % The try-catch block ensures that Screen will restore the display and return us
        % to the MATLAB prompt even if there is an error in our code.  Without this try-catch
        % block, Screen could still have control of the display when MATLAB throws an error, in
        % which case the user will not see the MATLAB prompt.
        Screen('CloseAll');

        % Restores the mouse cursor.
        ShowCursor;

        % Restore preferences
        Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
        Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);

        % We throw the error again so the user sees the error description.
        psychrethrow(psychlasterror);

    end



end

