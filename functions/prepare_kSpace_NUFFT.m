function [kSpace,NUFFT,para] = prepare_kSpace_NUFFT(kSpace_all,theta_all,para)
disp('Creating NUFFT object...');tic
[sx,nor,nof,no_comp,ns] = size(kSpace_all);

ifNUFFT             = para.ifNUFFT;
kCenter             = para.kSpace_center;

para.Recon.nof = nof;
theta = reshape(theta_all,[1,nor,nof]);
kSpace = reshape(kSpace_all,[sx,nor,nof,no_comp,1,ns]);

[x_coor, y_coor] = get_k_coor(sx,theta,ifNUFFT,kCenter);
coor = x_coor + 1i*y_coor;

%%%%% density compensation for NUFFT
center_shift = kCenter - sx/2 -1;
W = designFilter(sx,center_shift,'ram-lak');

%%%%% create the NUFFT structure
NUFFT = FftTools.MultiNufft(coor,W,0,[sx sx]);

para.CPUtime.create_NUFFT_obj = toc;toc;
