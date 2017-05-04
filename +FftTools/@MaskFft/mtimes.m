function [ res ] = mtimes(self, input_data)
  import FftTools.*

  % mask and then take the fft
  if self.adjoint
    % if mask size and input_data size don't match, then repmat the mask
    % to make them match. This takes a little finagling.
    if ndims(self.mask) ~= ndims(input_data)
      mask = resize_mask(self.mask, input_data);
    else
      mask = self.mask;
    end
    masked_data = input_data .* mask;
    res = ifft2c(masked_data);
  else
    res = fft2c(input_data);
  end
end

function [ out_mask ] = resize_mask(in_mask, input_data)
  % Resize a mask via repmat to match the size of input data
  % this assumes the issue is the input data is bigger in size
  % if it's smaller, then you're using MaskFft wrong :)
  % The following code is a little convoluted so I'll comment over
  % each line with example data

  mask_size = size(in_mask); % => [288, 288]
  input_data_size = size(input_data);  % => [288, 288, 5, 20]

  mask_size_length = length(mask_size); % => 2
  input_size_length = length(input_data_size); % => 4

  size_diff = input_size_length - mask_size_length; % => 2
  out_mask_size = padarray(mask_size, [0, size_diff], 1, 'post');
  % => [288, 288, 1, 1]
  out_mask_size = out_mask_size - 1; % => [287, 287, 0, 0]
  repeat_command = input_data_size - out_mask_size; % => [1,1,5,20]


  out_mask = repmat(in_mask, repeat_command);
end
