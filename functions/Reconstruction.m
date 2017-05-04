% MRI Reconstruction
% phye1988@gmail.com
% Ye Tian, UCAIR, University of Utah

% This is the main reconstruction function for reconstruct 2D golden angle
% radial sampled k-space data

function [Image,para] = Reconstruction(para)

fprintf('\n');t1 = tic;

%%%%% load parameters from para
para = prepare_para(para);

%%%%% load k-space data
[kSpace,para] = PCA_kSpace_yt(para);

%%%%% load pre-selected systolic frames locations
load('./RawData/sysloc.mat');

%%%%% get sampling angle
theta = get_angle_mod(para);

%%%%% prepare k-space data
if para.ifNUFFT == 1
    
    % pre-calculate NUFFT object, estimate senstivity map
    [kSpace,NUFFT,para] = prepare_kSpace_NUFFT(kSpace,theta,para);
    im = NUFFT'* kSpace;
    sens_map = get_sens_map(im);
    
    % select systolic frames
    NUFFT.kSize(3) = length(sysloc);
    NUFFT.kSize_z = length(sysloc);
    NUFFT.nufft_structs = NUFFT.nufft_structs(1,sysloc);
    im = im(:,:,sysloc,:);
    kSpace = kSpace(:,:,sysloc,:);
    
    % initial estimation of images
    first_est = sum(bsxfun(@times,im,conj(sens_map)),4);
    para.CPUtime.pre_iteration = toc(t1);
    
    % iterative reconstruction
    [Image,para] = iteration_recon(first_est,kSpace,sens_map,1,para,NUFFT);

else
    % pre-interpolate radial k space data onto Cartesian space
    [kSpace,para] = prepare_kSpace(kSpace,theta,para);
    kSpace = fftshift(fftshift(kSpace,1),2);
    mask = logical(abs(kSpace(:,:,:,1)));
    im = fftshift(fftshift(ifft2(kSpace),1),2);
    kSpace = bsxfun(@times,fft2(im),mask);
    
    % estimate senstivity map
    sens_map = get_sens_map(im);
    
    % pick up systolic frames
    im = im(:,:,sysloc,:);
    kSpace = kSpace(:,:,sysloc,:);
    mask = mask(:,:,sysloc);
    
    % get initial estimation
    first_est = single(sum(bsxfun(@times, im, conj(sens_map)),4));
    para.CPUtime.pre_iteration = toc(t1);toc(t1);

    [Image,para] = iteration_recon(first_est,kSpace,sens_map,mask,para);

end
end

function sens_map = get_sens_map(im)
    
    im_for_sens = squeeze(sum(im,3));
    sens_map(:,:,1,:) = ismrm_estimate_csm_walsh_optimized_yt(im_for_sens,20);
    sens_map_scale = max(abs(sens_map(:)));                             
    sens_map = sens_map/sens_map_scale;
    sens_map_conj = conj(sens_map);
    sens_correct_term = 1./sum(sens_map_conj.*sens_map,4);
    sens_correct_term = sqrt(sens_correct_term);
    sens_map = bsxfun(@times,sens_correct_term,sens_map);

end