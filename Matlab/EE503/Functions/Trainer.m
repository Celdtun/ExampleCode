function [best_solution, u_names, weight_vector] = ...
    Trainer(input_cb, start_over, compare_only)

%==========================================================================
%  Function:            Trainer
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
%  Description:         To load a single array with critical information on
%                       for the sample sound files.
%
%  Input:               input_cb = Initial Codebook
%                       start_over = TRUE creates random Codebook
%                       compare_only = True Skips the training process
%
%  Output:              best_solution = Trained VQ Matrix
%                       u_names = List of Unique Names from Trained Files
%                       weight_vector = Comparison weight string
%
%  Global Variables:    None
%
%  Global Constants:    None
%
%  Local Variables:     i = Counting variable
%                       errorlimit = Maxium error allowed for a solution
%                       transition_limit = Max varition to be considered a
%                         different solution
%                       solution_limit = Number of cycles to confirm best
%                         solution status
%                       cb_default_depth = Default column size of codebook
%                       hvqenc = VQ encoder object
%                       training_sound_files = List of training sounds fil
%                         names and speakers
%                       cb = Working Codebook
%                       cb_row = # Codebook Rows
%                       cb_col = # Codebook Columns
%                       len = Working variable
%                       test_name = File Name variable
%                       original = Signal data
%                       num = Working variable
%                       more_data = Additional signal data
%                       filtered = Post Lowpass data
%                       pre_q_mirror = Post Resampling Data
%                       trainer_signal = Post Mirror Data
%                       solution_test = Counting variable for solution
%                       best_solution_diff = Lowest difference so far
%                       codeword = Encoded codeword data
%                       error = Error per codeword
%                       prev_error = error place holder
%                       new_error = error place holder
%                       prev_diff = difference place holder
%                       error_diff = difference placeholder
%                       best_solution_error = lowest error so far
%                       diff = Difference array
%
%--------------------------------------------------------------------------
%
%  References:          None
%
%==========================================================================

  %Initialize Variables
  errorlimit = 1e-5;
  transition_limit = 0.05; %5
  solution_limit = 10;
  cb_default_depth = 64;
  hvqenc = dsp.VectorQuantizerEncoder(...
      'CodebookSource', 'Input port', ...
      'CodewordOutputPort', true, ...
      'QuantizationErrorOutputPort', true, ...
      'OutputIndexDataType', 'uint8');
  training_sound_files = Load_Training_Sound_Files;
  u_names = unique(training_sound_files(:,1));

  %Check to see if new Random Codebook is to be generated
  if start_over
    %New codebook required
    fprintf('\n\nLoading Random Codebook...\n');
    %Make new CB with random numbers
    cb = rand(8, cb_default_depth);
    %Walk through files to get samples from all speakers
    for i = 1:length(u_names)
      %Find speaker's files
      name_files = strmatch(u_names(i), training_sound_files(:,1));
      %Open first Speaker Files
      [~, test_name] = training_sound_files{name_files(1), 1:2};
      %Read speaker file
      [original, ~] = audioread(test_name);
      %Input Lowpass
      [filtered, ~] = Lowpass_4kP_4r1kS_44r1kFs_4D(original);
      %Resample
      pre_q_mirror = resample(filtered, 95, 128);
      %Quad Mirror
      trainer_signal = Quadrature_Mirror(pre_q_mirror);

      %How much data is in the signal
      len = length(trainer_signal);
      
      %Find starting col position
      start_col = ((i - 1) * floor(cb_default_depth / ...
        length(u_names))) + 1;
      %Find ending column position
      if i == length(u_names)
        end_col = cb_default_depth;
      else
        end_col = (i * floor(cb_default_depth / length(u_names)));
      end

      %Convert random numbers to random values
      for row = 1:8
        for col = start_col:end_col
          cb(row, col) = floor(cb(row, col) * (len - 1)) + 1;
          cb(row, col) = trainer_signal(row, cb(row, col));
        end
      end
    end
  else
    %Copy input VQ into working CB for later stages
    cb = input_cb;
  end

  %Get codebook size
  [cb_row, cb_col] = size(cb);

  %Check if the CB is to be trained
  if ~compare_only
    %CB is to be trained
    fprintf('\nTeaching Process...\n');

    %Find the number of traiing files
    len = length(training_sound_files);
    
    fprintf('  Reading File 1 of %d...\n', len);
    %Read file name
    [~, test_name] = training_sound_files{1, 1:2};
    %Read file data
    [original, ~] = audioread(test_name);
    %Loop if more than one training file
    for num = 2:len
      fprintf('  Reading File %d of %d...\n', num, len);
      %Get next file name
      [~, test_name] = training_sound_files{num, 1:2};
      %Read next file
      [more_data, ~] = audioread(test_name);
      %Add new file data to original
      original = cat(1,original, more_data);
    end
    
    fprintf('  Filtering Signal...\n');
    %Lowpass Filter
    [filtered, ~] = Lowpass_4kP_4r1kS_44r1kFs_4D(original);
    %Resample Signal
    pre_q_mirror = resample(filtered, 95, 128);
    fprintf('  Quadrature Mirror Filter...\n');
    %Quad Mirror Filter Bank
    trainer_signal = Quadrature_Mirror(pre_q_mirror);
    
    fprintf('  Quantizing Signal...\n');
    %Default Solution Variables
    solution_test = 0;
    best_solution_diff = 0;
    len = length(trainer_signal);
    
    %Intial Pass of signal through vq encoder
    [index, codeword, error] = step(hvqenc, trainer_signal, cb);
    %Initial encoder results/defaults
    prev_error = 0;
    new_error = sum(error);
    prev_diff = 0;
    error_diff = new_error;
    best_solution_error = new_error;
      
    fprintf('    Starting Error: %.2f\n', new_error);
    fprintf('    Updating Error: %.2f.', new_error);
    
    %Loop to improve training error
    while solution_test < solution_limit
       
      fprintf('.');
      %If error low enough & has enough % change OR Error is identical to a
      %certain rounding precision, new solution data might exist
      if (error_diff <= errorlimit && ...
          (error_diff / prev_diff) >= (1 - transition_limit)) || ...
          round(prev_error, 6) == round(new_error, 6)
        %Check if data is beter than previous solutions
        if best_solution_diff == 0 || best_solution_diff > error_diff
          fprintf(' %.2f.', new_error);
          %Save to best_* variables
          best_solution_diff = error_diff;
          best_solution_error = new_error;
          best_solution = cb;
        end
        %Data met new data point requiremets so increment counter
        solution_test = solution_test + 1;
      else
        %Solution was not close enough; reset looping control variables
        solution_test = 0;
        prev_error = new_error;
      end

      %Save error for next loop
      prev_diff = error_diff;

      %Zero out difference array
      diff = zeros(cb_row + 1, cb_col);

      %Sum all trainer values for each cookbook location
      for i = 1:len
        ind = index(i) + 1;
        diff(1, ind) = diff(1, ind)+ (codeword(1, i) - trainer_signal(1, i));
        diff(2, ind) = diff(2, ind)+ (codeword(2, i) - trainer_signal(2, i));
        diff(3, ind) = diff(3, ind)+ 1;
      end

      %Average the trainer values and calculate the new cookbook
      for i = 1:cb_col
        if diff(3, i) > 0
          %Codeword has some data assigned to it; calculate shift
          diff(1 , i) = diff(1, i) / diff(3, i);
          diff(2 , i) = diff(2, i) / diff(3, i);
          %Update codeword location
          cb(1, i) = cb(1, i) - diff(1, i);
          cb(2, i) = cb(2, i) - diff(2, i);
        else
          %Codeword has no points; Move it near most used point
          [~, max_index] = max(diff(3,:));
          %Ensure random variation
          if rand() > 0.5
            random = 1;
          else
            random = -1;
          end
          %Calculate position based on location to prevent more than one
          %point being moved intot eh same location
          diff(1, i) = diff(1, max_index) + (random * ...
            (diff(1, max_index) * .01 * (i / cb_col)));
          diff(2, i) = diff(2, max_index) + (random * ...
            (diff(2, max_index) * .01 * (i / cb_col)));
        end
      end

      %Get next set of encoder data
      [index, codeword, error] = step(hvqenc, trainer_signal, cb);

      %Calculate total error
      new_error = sum(abs(error));
      %Compare error change
      error_diff = abs(new_error - prev_error);
    end

    fprintf('\n    Final Error: %.2f\n\n', best_solution_error);

    %Release encoder
    release(hvqenc);
  else
    best_solution = cb;
  end
  
  fprintf('\n\nUpdating Codebook Weights...\n');

  %Default Weight array
  weight_vector = zeros(length(u_names), (cb_col+1));
  
  %Calcaulate weight array for each person with training files
  for name = 1:length(u_names)
    %Get speaker's files
    name_files = strmatch(u_names(name), training_sound_files(:,1));
    %If more than one file
    if length(name_files) > 1
      fprintf('  Reading %s''s Files...\n', char(u_names(name)));
      %Get signal information
      [~, file_name] = training_sound_files{name_files(1), 1:2};
      %Read signal
      [original, fs] = audioread(file_name);
      %Look for next file
      for next_file = 2:length(name_files)
        %Load next file data
        [~, file_name] = training_sound_files{name_files(next_file), 1:2};
        %Read next file
        [more_data, fs] = audioread(file_name);
        %Add to original signal
        original = cat(1,original, more_data);
      end
    else
      %Only one file to read
      fprintf('  Reading %s''s File...\n', char(u_name(name)));
      %Get file data
      [~, file_name] = training_sound_files{name_files, 1:2};
      %Read signal
      [original, fs] = audioread(file_name);
    end

    fprintf('    Filtering Signal...\n');
    %Lowpss Filter
    [filtered, ~] = Lowpass_4kP_4r1kS_44r1kFs_4D(original);
    %Resample Filter
    pre_q_mirror = resample(filtered, 95, 128);

    fprintf('    Quadrature Mirror Filter...\n');
    %Mirror Filter
    trainer_signal = Quadrature_Mirror(pre_q_mirror);

    fprintf('    Quantizing Signal...\n');

    %Pass though VQ encoder for index values
    [index, ~, ~] = step(hvqenc, trainer_signal, best_solution);
    %Release encoder
    release(hvqenc);

    fprintf('    Calculating Weights...\n');

    %Sum all trainer values for each cookbook location
    for i = 1:length(index)
      ind = index(i) + 2;   %+2 because index is 0-based
      weight_vector(name, ind) = weight_vector(name, ind)+ 1;
    end
    
    %Calculate weight values
    weight_vector(name, :) = weight_vector(name, :) / length(index);
    %Enter comparison cutoff value; Derived form system testing
    weight_vector(name, 1) = 0.9;
  end
end

