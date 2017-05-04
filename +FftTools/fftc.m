function outputData = fftc(inputData, dimensionIndex)
% Perform centered fft along dimension specified by dimensionIndex
if nargin < 2
  dimensionIndex = 2;
end

sizeAlongDimension = size(inputData, dimensionIndex);
scaleFactor = 1 / sqrt(sizeAlongDimension);

shiftedData = ifftshift(inputData, dimensionIndex);
transformedData = fft(shiftedData, [], dimensionIndex);
unshiftedData = fftshift(transformedData, dimensionIndex);
outputData = scaleFactor * unshiftedData;
