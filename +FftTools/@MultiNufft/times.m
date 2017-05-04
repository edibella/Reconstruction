function res = times(a,b)
  % For some reason when I was experimenting with this I found that
  % fftObj'.*(fftObj.*data) produced the following order of operations
  %
  % 1. Transpose fftObj
  % 2. Perform fftObj.*data
  % 3. Perform fftObj.* result of above
  %
  % Since transpose is jumping ahead in the order of operations
  % it causes a problem here. This problem is new now that MultiNufft
  % is a handle object which makes a field like adjoint a permanent
  % property of the object, rather than a temporary setting.
  %
  % It is a mystery to me, but this is not an issue if you use .*
%   error 'Use * not .* with FFT objects'

res = mtimes(a,b);
end
