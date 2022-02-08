function [bins] = Quadrature_Mirror(input)
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

signal = input;

%Filter original signal
%  Sample Frequency ==> 8.2kHz (input)
%  Frequency Range ==> 0Hz -> 4.1kHz 
%Lowpass ==> 0Hz -> 2.05kHz
a_l = downsample(Lowpass_0r495P_0r505S(signal), 2);
%Highpass ==> 2.05kHz -> 4.1kHz
a_h = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(signal), 2);

%Filter a_l signal
%  Sample Frequency ==> 4.1kHz
%  Frequency Range ==> 0Hz -> 2.05kHz 
%Lowpass ==> 0Hz -> 1.025kHz
b0_l = downsample(Lowpass_0r495P_0r505S(a_l), 2);
%Highpass ==> 1.025kHz -> 2.05kHz
b0_h = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(a_l), 2);
%Filter a_h signal
%  Sample Frequency ==> 4.1kHz
%  Frequency Range ==> 2.05kHz -> 4.1kHz 
%Lowpass ==> 2.05kHz -> 3.075kHz
b1_l = downsample(Lowpass_0r495P_0r505S(a_h), 2);
%Highpass ==> 3.075kHz -> 4.1kHz
b1_h = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(a_h), 2);

%Filter b0_l signal
%  Sample Frequency ==> 2.05kHz
%  Frequency Range ==> 0Hz -> 1.025kHz 
%Lowpass ==> 0Hz -> 512.5Hz
bins(1, :) = downsample(Lowpass_0r495P_0r505S(b0_l), 2);
%Highpass ==> 512.5Hz -> 1.025kHz
bins(2, :) = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(b0_l), 2);
%Filter b0_h signal
%  Sample Frequency ==> 2.05kHz
%  Frequency Range ==> 1.025kHz -> 2.05kHz 
%Lowpass ==> 1.025kHz -> 1.5375kHz
bins(3, :) = downsample(Lowpass_0r495P_0r505S(b0_h), 2);
%Highpass ==> 1.5375kHz -> 2.05kHz
bins(4, :) = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(b0_h), 2);
%Filter b1_l signal
%  Sample Frequency ==> 2.05kHz
%  Frequency Range ==> 2.05kHz -> 3.075kHz 
%Lowpass ==> 2.05kHz -> 2.5625kHz
bins(5, :) = downsample(Lowpass_0r495P_0r505S(b1_l), 2);
%Highpass ==> 2.5625kHz -> 3.075kHz
bins(6, :) = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(b1_l), 2);
%Filter b1_h signal
%  Sample Frequency ==> 2.05kHz
%  Frequency Range ==> 3.075kHz -> 4.1kHz 
%Lowpass ==> 3.075kHz -> 3.5875kHz
bins(7, :) = downsample(Lowpass_0r495P_0r505S(b1_h), 2);
%Highpass ==> 3.5875kHz -> 4.1kHz
bins(8, :) = downsample(Lowpass_Converted_to_Highpass_0r495P_0r505S(b1_h), 2);

end

