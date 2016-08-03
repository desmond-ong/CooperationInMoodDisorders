% This script is the only one you would have to run to do the Trust Game 
% and the Affective Cognition Task.
% It handles the rest, and outputs the file to a folder called Data, and a
% file called NERD_(subjectID)_TG_Data_(date and time).csv
%   Written by Desmond Ong (dco@stanford.edu)
%
%
%
%

% ----- Initialization ------ %
    clear all; % clears workspace
    clc; % clears console
    studyDir = pwd; % gets current working directory         
    
    subject_ID = input('Please enter your Subject ID: ');
    dateTimeNow = clock;
    TGOutputFileName = [studyDir '\Data\NERD_' num2str(subject_ID) '_TG_Data_' num2str(dateTimeNow(1)) '_' num2str(dateTimeNow(2)) '_' ...
        num2str(dateTimeNow(3)) '_' num2str(dateTimeNow(4)) '_' num2str(dateTimeNow(5)) '.csv'];
    
     % Printing Headers
     fid = fopen(TGOutputFileName, 'w');
     fprintf(fid, 'SubjectID, Round, LearningRate, Investment, Repayment');
     fprintf(fid, '\n');
     fclose(fid);
          
     %KbName('UnifyKeyNames');
     NERD_TG(subject_ID, TGOutputFileName);
     
    