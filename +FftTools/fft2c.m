function outputData = fft2c(inputData)
	% Perform a "centered" fft2. In other words, this is an fft2 algorithm
	% that is better suited to medical imaging use. Thanks to Dr. Michael Lustig
	% for the original code.

	% Reshape original data to be 3D stack of 2D frames
  inputSize = size(inputData);
	nFrames = prod(inputSize(3:end));
  inputData = reshape(inputData, [inputSize(1) inputSize(2) nFrames]);

	% Calculate Scale Factor
	sizeProduct = inputSize(1) * inputSize(2);
	scaleFactor = 1 / sqrt(sizeProduct);

  % fft2 and fftshift each frame independently
  outputData = zeros(size(inputData), 'single');
  for iFrame = 1:nFrames
		dataFrame = inputData(:,:,iFrame);
		transformedFrame = fftshift(fft2(ifftshift(dataFrame)));
  	outputData(:,:,iFrame) = scaleFactor * transformedFrame;
  end

  % Reshape back to original size
  outputData = reshape(outputData, inputSize);
end
