function [kSpace,para] = prepare_kSpace(kSpace_all,theta_all,para)
% [kSpace,phase_mod,para] = prepare_kSpace(kSpace_all,theta_all,para)

t1 = tic;
[sx,nor,nof,no_comp,ns] = size(kSpace_all);

ifNUFFT             = para.ifNUFFT;
kCenter             = para.kSpace_center;
interp_method       = para.interp_method;

para.Recon.nor = nor;
theta = reshape(theta_all,[1,nor,nof]);
kSpace = kSpace_all;
kSpace = reshape(kSpace,[sx,nor,nof,no_comp,1,ns]);


%%%%% pre-interpolation
disp('Pre-interpolate into Cartesian space...')

[x_coor, y_coor] = get_k_coor(sx,theta,ifNUFFT,kCenter);

switch interp_method
    case 'grid3'
        kSpace = pre_interp_radial_to_cart(kSpace,x_coor,y_coor);
    case'NN'
        G = NN.init(kSpace,x_coor,y_coor);
        kSpace = NN.interp(kSpace,G);
    case 'GROG'
        G = GROG.init(kSpace,x_coor,y_coor);
        kSpace = GROG.interp(kSpace,G);
    otherwise
        disp('Pre-interpolation method wrong');return
end

para.CPUtime.prepare_kSpace = toc(t1);toc(t1);fprintf('\n');
  