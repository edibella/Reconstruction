# Reconstruction

This repository is self-consistent. It includes MATLAB code and data for the paper "Evaluation of Pre-reconstruction Interpolation Methods for Iterative Reconstruction of Radial k-Space Data".

- The "Recon.m" includes settings and parameters for reconstuction and just run it will call the main reconstruction function "Reconstruction.m".

- The final results will be saved at "./Results", with a name of "Perfustion_methods_time.m". The "methods" is the reconstruction methods, which is "NN", "grid3", "GROG" or "NUFFT" and can be changed in "Recon.m". The "time" in the file name is the time when start the code, and has a format of "yymmdd_hhMMSS". All the settings and parameters will be saved in the same file in a structure named "para".

- The saved image is half of the size of the image during processing to save space on disk. Crops can be changed in "./functions/iteration_recon.m".

The oringional authors of these codes were Ganesh Adluru and KC Erb, and then modified to fit this study by Ye Tian. The copyright is reserved by the research group of Professor Edward DiBella at UCAIR ( Utah Center for advanced Imaging Researches), University of Utah.

These code is currently maintained by Ye Tian.
Contact: phye1988@gmail.com
