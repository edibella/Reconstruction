function outputData = ifftc(inputData, dimensionIndex)
% Perform centered fft along dimension specified by dimensionIndex
if nargin < 2
  dimensionIndex = 2;
end

sizeAlongDimension = size(inputData, dimensionIndex);
scaleFactor = sqrt(sizeAlongDimension);

shiftedData = ifftshift(inputData, dimensionIndex);
transformedData = ifft(shiftedData, [], dimensionIndex);
unshiftedData = fftshift(transformedData, dimensionIndex);
outputData = scaleFactor * unshiftedData;
