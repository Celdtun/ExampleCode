%==========================================================================
%  Function:            Project
%  Project:             ECE503 Course Design Project; Speaker Recognition
%
%  Author:              Chad Graham
%  Date:                April 21, 2015
%
%  Class:               ECE503 - Digital Signal Processing
%  Semester:            Spring 2015
%
%  Matlab Revision:     Matlab R2014b
%
%--------------------------------------------------------------------------
%
%  Revision:            Rev 0
%
%--------------------------------------------------------------------------
%
%  Description:         To act as the primary project file (main) for the
%                       class project program
%
%  Input:               sys_vq = Previously Trained VQ; Read from File
%                       sys_names = Array with Trained Speaker Names; Read
%                         from File
%                       sys_weights = Comparator Array; Read from File
%
%  Output:              sys_vq = If Trained; Saved to File
%                       sys_names = If Trained; Saved to File
%                       sys_weights = If Trained; Saved to File
%
%  Global Variables:    None
%
%  Global Constants:    None
%
%  Local Variables:     train  = True for Train Mode; False for Test Mode
%                       erase_sys_vq = Overwrite VQ in Train Mode
%                       compare_sys_vq = Skip Training Process in Train
%                         Mode
%                       filename = File name of variable storage file
%                       index = Counting variable
%                       names = List of file names for user GUI
%                       valid = True if user chose a valid file
%                       subject = Name of the Speaker for a given file
%                       test_name = Name of the file to be tested
%                       original = Original data from the file
%                       fs = Sampling frequency for original
%                       filtered = Signal data afert the Input Lowpass
%                         filter
%                       fd = Sampling frequency for filtered
%                       pre_q_mirror = Data after resampling
%                       test_signal = Data after Quad Mirror Bank
%                       results = Results of the comparason process
%                       msg = Message if the variable file is missing upon
%                         program start
%
%--------------------------------------------------------------------------
%
%  References:          None
%
%==========================================================================

  %Clear all Variables
  clear;
  %Close all Windows
  close all;
  %Clear Command Window
  clc;

  fprintf('Starting Program...\n');

  %Set true to retrain vector quantizer
  train = false;
  %Set erase_sys_vq and recalculate with a new codebook
  erase_sys_vq = true;
  %Set compare_sys_vq to skip training and go right to array generation
  compare_sys_vq = false;
  
  %Add subfolder paths to enable functions and scripts to work
  %  These will be removed at the end of the program
  addpath Filters
  addpath Functions

  %Load filenme pointer
  filename = 'Functions/variables.mat';

  %cCheck that the variable file exists
  if exist(filename, 'file')
    %loas sys_* variables
    load(filename);

    %Default counter to 1
    index = 1;

    %Check if the program is in train mode or test mode
    if train
      %Training Quantizer Process
      [sys_vq, sys_names, sys_weights] = ...
          Trainer(sys_vq, erase_sys_vq, compare_sys_vq);
      %Save new sys_* variables to file
      save(filename, 'sys_vq', 'sys_names', 'sys_weights');
    else
      %Load Sample Sound Files
      sample_sound_files = Load_Sample_Sound_Files;
      
      %Load array with only potential test files
      names = sample_sound_files(:,2);
      %Add 'All' to the array
      names = cat(1, 'All', names);
      
      %Default vaild to false
      valid = false;
      while ~valid
        %Query for user input
        [index,valid] = listdlg('SelectionMode','single', ...
            'PromptString','Select a Signal File:', ...
            'ListSize', [320 300], ...
            'ListString',names);
      end
      
      %Check if 'All' Files or Single File
      if index == 1
        %All Files
        for index = 1:length(sample_sound_files)
          %Load file information
          [subject, test_name] = sample_sound_files{index, 1:2};
     
          fprintf('Processing "%s"...', char(test_name));
          %Read speaker file
          [original, fs] = audioread(test_name);
          fprintf('.');
          %Input Lowpass
          [filtered, fd] = Lowpass_4kP_4r1kS_44r1kFs_4D(original);
          fprintf('.');
          %Resample
          pre_q_mirror = resample(filtered, 95, 128);
          fprintf('.');
          %Quad Mirror
          test_signal = Quadrature_Mirror(pre_q_mirror);
          fprintf('.');
          %Compare Signal
          results = Determine_Speaker(sys_vq, test_signal, sys_weights);
          fprintf('Finished');
           %Calculate Results
          result = results(1,1) >= sys_weights(1,1);
        
          %Display Results
           if(result && strcmp('Chad', subject))
             fprintf('; Success - It''s Chad!!\n');
           elseif(~result && ~strcmp('Chad', subject))
             fprintf('; Success - Not Chad!!\n');
           else
             fprintf('; Failed - It might be Chad...\n');
           end
        end
      else
        %Load file information
        [subject, test_name] = sample_sound_files{index - 1, 1:2};
     
        fprintf('Processing "%s"...', char(test_name));
        %Read speaker file
        [original, fs] = audioread(test_name);
        fprintf('.');
        %Input Lowpass
        [filtered, fd] = Lowpass_4kP_4r1kS_44r1kFs_4D(original);
        fprintf('.');
        %Resample
        pre_q_mirror = resample(filtered, 95, 128);
        fprintf('.');
        %Quad Mirror
        test_signal = Quadrature_Mirror(pre_q_mirror);
        fprintf('.');
        %Compare Signal
        results = Determine_Speaker(sys_vq, test_signal, sys_weights);
        fprintf('Finished');
        %Calculate Results
        result = results(1,1) >= sys_weights(1,1);
        %Display Results
        if(result && strcmp('Chad', subject))
          fprintf('; Success - It''s Chad!!\n');
        elseif(~result && ~strcmp('Chad', subject))
          fprintf('; Success - Not Chad!!\n');
        else
          fprintf('; Failed - It might be Chad...\n');
        end  
      end
    end

  else
    %Variable file missing message
    msg = sprintf(['Vector Quantizer File Missing\n\n', ...
        'Confirm File is in the Correct Folder\n\n', ...
        '[PROJECT FOLDER]/%s'], filename);
    %Display Warning Window
    uiwait(msgbox(msg));  
  end
  
  fprintf('Program Complete; Exiting...\n');

  %Remove subfolder paths that enabled functions and scripts to work
  rmpath Filters
  rmpath Functions
