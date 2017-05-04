function MultiNufft_tests(tester)
  import FftTools.*
  % Test data comes from some gated cardiac perfusion data that has been PCA'd
  % Therefore 'backward' transforms are tested first.
  % 2D version contains 2D trajectory, data and density compensation.
  load('test_multi_nufft_data_2D.mat')

  % Matrix size
  N = [288, 288];

  %% -- Test MultiNufft on 2D data
  obj = MultiNufft(testTrajectory2D, testDensityCompensation, [0,0], N);
  % Test backward transform
  % Var name is multiNUFFTOfficialResult after old naming convention
  load('multi_nufft_2D_backward_result.mat')
  multiNufftPresentResult = obj' * testData2D;
  tester.test(multiNUFFTOfficialResult, multiNufftPresentResult, 'Test MultiNufft 2D backward')

  % Test forward transform
  load('multi_nufft_2D_forward_result.mat')
  presentForwardResult = obj * multiNufftPresentResult;
  tester.test(officialForwardResult, presentForwardResult, 'Test MultiNufft 2D forward')

  %% Test MultiNufft on 3D data
  % density compensation is per image so only 2D, but trajectory changes between frames so it is 3D along with data.
  load('test_multi_nufft_data_3D.mat')

  obj = MultiNufft(testTrajectory3D, testDensityCompensation, [0,0], N);
  % Test backward transform
  load('multi_nufft_3D_backward_result.mat')
  multiNufftPresentResult = obj' * testData3D;
  tester.test(multiNUFFTOfficialResult, multiNufftPresentResult, 'Test MultiNufft 3D backward')

  % Test forward transform
  load('multi_nufft_3D_forward_result.mat')
  presentForwardResult = obj * multiNufftPresentResult;
  tester.test(officialForwardResult, presentForwardResult, 'Test MultiNufft 3D forward')

  %% Test MultiNufft on 4D data
  load('test_multi_nufft_data_4D.mat')
  % Now we get to the last test, trajectory is only 3D,
  % density compensation still 2D.
  load('multi_nufft_4D_backward_result.mat')
  obj = MultiNufft(testTrajectory3D, testDensityCompensation, [0,0], N);
  multiNufftPresentResult = obj' * testData4D;
  tester.test(multiNUFFTOfficialResult, multiNufftPresentResult, 'Test MultiNufft 4D backward')

  % Test forward transform
  load('multi_nufft_4D_forward_result.mat')
  presentForwardResult = obj * multiNufftPresentResult;
  tester.test(officialForwardResult, presentForwardResult, 'Test MultiNufft 4D forward')
end
