function centered_fft_tests(tester)
  import FftTools.*
  % Using 1D test Data
  % t = linspace(0, 2*pi, 2^7); % 1KB data
  % testData1D = sin(5*t) + sin(0.5*t) - cos(2.5*t);
  load('test_centered_fft_data_1D.mat')

  % Test fftc
  load('fftc_1D_result.mat')
  fftcPresentResult = fftc(testData1D);
  tester.test(fftcOfficialResult, fftcPresentResult, 'Test fftc 1D')

  % Test ifftc
  load('ifftc_1D_result.mat')
  ifftcPresentResult = ifftc(testData1D);
  tester.test(ifftcOfficialResult, ifftcPresentResult, 'Test ifftc 1D')

  % fft2c and ifft2c should treat 1D data same as fftc and ifftc
  fft2cPresentResult = fft2c(testData1D);
  ifft2cPresentResult = ifft2c(testData1D);
  tester.test(fftcOfficialResult, fft2cPresentResult, 'Test fft2c 1D matches fftc')
  tester.test(ifftcOfficialResult, ifft2cPresentResult, 'Test ifft2c 1D matches ifftc')

  %% --
  % Using 2D data
  % Produced with simple matrix multiplication
  % t = linspace(0, 2*pi, 2^5);
  % testData2D = cos(.25*t(:))*sin(.75*t(:)');
  load('test_centered_fft_data_2D.mat')

  % % Test fft2c on 2D data
  load('fft2c_2D_result.mat')
  fft2cPresentResult2D = fft2c(testData2D);
  tester.test(fft2cOfficialResult2D, fft2cPresentResult2D, 'Test fft2c 2D')

  % Test ifft2c on 2D data
  load('ifft2c_2D_result.mat')
  ifft2cPresentResult2D = ifft2c(testData2D);
  tester.test(ifft2cOfficialResult2D, ifft2cPresentResult2D, 'Test ifft2c 2D')

  % TODO: test fftc and ifftc on multi-D data using 2 args
  % TODO: write 3D and 4D tests?
  % load('test_centered_fft_data_3D.mat')
  %
  % % Test fft2c on 3D data
  % load('fft2c_3D_result.mat')
  % fft2cPresentResult3D = fft2c(testData3D);
  % tester.test(fft2cOfficialResult3D, fft2cPresentResult3D)
  %
  % % Test ifft2c on 3D data
  % load('ifft2c_3D_result.mat')
  % ifft2cPresentResult3D = ifft2c(testData3D);
  % tester.test(ifft2cOfficialResult3D, ifft2cPresentResult3D)
  %
  % % Test fft2c on 4D data
  % load('fft2c_4D_result.mat')
  % fft2cPresentResult4D = fft2c(testData4D);
  % tester.test(fft2cOfficialResult4D, fft2cPresentResult4D)
  %
  % % Test ifft2c on 4D data
  % load('ifft2c_4D_result.mat')
  % ifft2cPresentResult4D = ifft2c(testData4D);
  % tester.test(ifft2cOfficialResult4D, ifft2cPresentResult4D)
  %
  % load('test_centered_fft_data_4D.mat')
end
