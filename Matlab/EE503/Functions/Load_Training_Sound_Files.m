function [ sound_files_names ] = Load_Training_Sound_Files( )

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
%  Global Constants:	None
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

%Load speaker Chad into the array
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Training/Chad Cat Trainer.wav');
i = i + 1;
sound_files_names{i, 1} = 'Chad';
sound_files_names{i, 2} = ('Sound Files/Training/Chad Rat Trainer.wav');
i = i + 1;

%Load speaker Crystal into the array
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Training/Crystal Cat Trainer.wav');
i = i + 1;
sound_files_names{i, 1} = 'Crystal';
sound_files_names{i, 2} = ('Sound Files/Training/Crystal Rat Trainer.wav');
i = i + 1;

%Load speaker Marissa into the array
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Training/Marissa Cat Trainer.wav');
i = i + 1;
sound_files_names{i, 1} = 'Marissa';
sound_files_names{i, 2} = ('Sound Files/Training/Marissa Rat Trainer.wav');
i = i + 1;

end