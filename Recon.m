% This script sets parameters for reconstruction and run the main
% reconstruction code. You can change parameters here.

% Copyright.
% Ye Tian
% phye1988@gmail.com
% Utah Center for Advanced Imaging Researches (UCAIR)
% Department of Radiology and Imaging Sciences
% University of Utah

addpath ./functions/

clear para

para.kSpace_center = 144; % radial k space center
para.dataAngle = 180;     % acquired radial data angle range, 180 or 360

para.dir.load_kSpace_name = 'human_perfusion_24_rays_slice_3.mat';
para.dir.load_kSpace_dir = [pwd,'/RawData/'];
para.dir.save_recon_img_mat_dir = strcat(pwd,'/processing/');

% Update images and cost function at each iteration. Default not showing
% for speed, can change the setting to "1" to turn it on.
para.plot = 0;

% change methods here.
% NUFFT  - based on Fesseler's NUFFT package
% GROG   - self-calibrated GRAPPA Operater Gridding
% NN     - Bilinear Nearest Neighber
% grid3  - MATLAB's griddate using default setting
para.interp_method = 'NN';

% Turn on GPU for faster reconstruction. Dose not support NUFFT method.
% Please read MATLAB's GPU requirments before using.
para.ifGPU = 0;

para.noi = 100;          % number of iterations
para.step_size = 0.1;    % step size
para.weight_sTV = 0.001; % spatial TV weight
para.weight_tTV = 0.005; % temporial TV weight
para.beta_square = 1e-8; % a small number used to get rid of sigularity

[image,para] = Reconstruction(para);