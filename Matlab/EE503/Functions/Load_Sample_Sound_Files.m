function [ sound_files_names ] = Load_Sample_Sound_Files( )

%==========================================================================
%  Function:            Load_Sound_Files
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
%  Input:               None
%
%  Output:              sound_files_names = Array with critical file
%                         information.  Each file is a Row arranged as
%                         [Speaker, FileName]
%
%  Global Variables:    None
%
%  Global Constants:    None
%
%  Local Variables:     i = Counting variable to walk through the array
%
%--------------------------------------------------------------------------
%
%  References:          None
%
%==========================================================================

%Initialize local variables
sound_files_names = {};
i = 1;

% %Load speaker Chad into the array
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Cat 5.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Chad Rat 5.wav');
i = i + 1;

%Load speaker Crystal into the array
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Cat 5.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Crystal Rat 5.wav');
i = i + 1;

%Load speaker Marissa into the array
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Cat 5.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Marissa Rat 5.wav');
i = i + 1;

%Load speaker Unknown into the array
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Cat 5.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 0.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 1.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 2.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 3.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 4.wav');
i = i + 1;
sound_files_names{i, 1} = 'Unknown';
sound_files_names{i, 2} = ('Sound Files/Unknown Rat 5.wav');
end