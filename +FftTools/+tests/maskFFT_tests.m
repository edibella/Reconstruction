function MaskFft_tests(tester)
  import FftTools.*
  % Same 2D data from fftc tests (see not there on creation)
  % testMask2D = ones(32,32);
  % testMask2D(:,1:2:32) = 0;
  load('test_mask_fft_data_2D.mat')

  % -- Test MaskFft on 2D data
  % Test forward transform
  % Named 'maskFFTOfficialResult' old naming convention
  load('mask_fft_2D_forward_result.mat')
  obj = MaskFft(testMask2D);
  maskFftPresentResult = obj * testData2D;
  tester.test(maskFFTOfficialResult, maskFftPresentResult, 'Test MaskFft 2D forward')

  % Test backward transform
  load('mask_fft_2D_backward_result.mat')
  presentAdjointResult = obj' * maskFftPresentResult;
  tester.test(officialAdjointResult, presentAdjointResult, 'Test MaskFft 2D backward')


  % Test MaskFft on 3D data
  testData3D = repmat(testData2D, [1 1 7]);

  % Test forward transform
  load('mask_fft_3D_forward_result.mat')
  obj = MaskFft(testMask2D);
  maskFftPresentResult = obj * testData3D;
  tester.test(maskFFTOfficialResult, maskFftPresentResult, 'Test MaskFft 3D forward')
  % Test backward transform
  load('mask_fft_3D_backward_result.mat')
  presentAdjointResult = obj' * maskFftPresentResult;
  tester.test(officialAdjointResult, presentAdjointResult, 'Test MaskFft 3D backward')


  % % Test MaskFft on 4D data
  % load('mask_fft_4D_result.mat')
  % obj = MaskFft(testMask4D);
  % maskFftPresentResult = obj * testData4D;
  % tester.test(maskFFTOfficialResult, maskFftPresentResult)
  % % Test backward transform - should return original data
  % testResult = obj' * maskFftPresentResult;
  % tester.test(testData4D, testResult)
end
