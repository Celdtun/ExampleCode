function [ result ] = Determine_Speaker( vq, signal, weights )
%==========================================================================
%  Function:            Determine_Speaker
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
%  Description:         To compare a filtered signal to the weight array to
%                       determine who the speaker is
%
%  Input:               vq = Codebook
%                       signal = Signal to compare
%                       weights = Weighted value array
%
%  Output:              result = Result of the comparaison
%
%  Global Variables:    None
%
%  Global Constants:    None
%
%  Local Variables:     num = Number of arrays in weights
%                       index = Accumlation array for comparison
%                       hvqenc = VQ encoder object
%                       locations = Index output from VQ encoder
%
%--------------------------------------------------------------------------
%
%  References:          None
%
%==========================================================================

  %Initialize local variables
  [num, ~] = size(weights);
  result = zeros((num + 1), 2);
  index = zeros(1, length(weights));
  hvqenc = dsp.VectorQuantizerEncoder(...
    'CodebookSource', 'Input port', ...
    'OutputIndexDataType', 'uint8');

  %Pass signal through VQ encoder
  locations = step(hvqenc, signal, vq);

  %Release the encoder object
  release(hvqenc);

  %Sum all trainer values for each cookbook location
  for i = 1:length(locations)
    ind = locations(i) + 2;   %+2 because index is 0-based
    index(ind) = index(ind)+ 1;
  end
  
  %Convert indec values to % of the signal samples
  index = index / length(locations);
  
  %Calculate the combined weights
  result(1, 1) = sum(index .* weights(1,:));
  result(2, 1) = sum(index .* weights(2,:));
  result(3, 1) = sum(index .* weights(3,:));
  
  %Calculate total weight
  result(4,1) = sum(result(:,1));

  %Calculate % of total weights
  result(1, 2) = 1 - (result(1, 1) / result(4, 1));
  result(2, 2) = 1 - (result(2, 1) / result(4, 1));
  result(3, 2) = 1 - (result(3, 1) / result(4, 1));

end

