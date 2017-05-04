function outputData = ifft2c(inputData)
  % Perform a "centered" ifft2. In other words, this is an ifft2 algorithm
  % that is better suited to medical imaging use. Thanks to Dr. Michael Lustig
  % for the original code.

  % Reshape original data to be 3D stack of 2D frames
  inputSize = size(inputData);
	nFrames = prod(inputSize(3:end));
  inputData = reshape(inputData, [inputSize(1) inputSize(2) nFrames]);

  % Calculate Scale Factor
  sizeProduct = inputSize(1) * inputSize(2);
  scaleFactor = sqrt(sizeProduct);

  % ifft2 and ifftshift each frame independently
  outputData = zeros(size(inputData), 'single');
  for iFrame = 1:nFrames
    dataFrame = inputData(:,:,iFrame);
    transformedFrame = fftshift(ifft2(ifftshift(dataFrame)));
    outputData(:,:,iFrame) = scaleFactor * transformedFrame;
  end
  
  % Reshape back to original size
  outputData = reshape(outputData, inputSize);
end
