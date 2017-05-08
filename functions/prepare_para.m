function para = prepare_para(para)
fprintf('Loading parameters...');tic
para.time = datestr(clock,'yymmdd_hhMMSS');

switch para.interp_method
    case 'NUFFT'
        para.ifNUFFT = 1;
    otherwise
        para.ifNUFFT = 0;
end

kSpace_name = char(para.dir.load_kSpace_name);

name = '';
if ~isempty(strfind(kSpace_name,'perfusion')) || ~isempty(strfind(kSpace_name,'Perfusion')) || ~isempty(strfind(kSpace_name,'PERFUSION'))
    name = strcat(name,'Perfusion_');
end
name = strcat(name,[para.interp_method,'_']);
para.Recon.save_dir = strcat(para.dir.save_recon_img_mat_dir,name);

if isempty(dir(para.dir.save_recon_img_mat_dir))
    mkdir(para.dir.save_recon_img_mat_dir);
end

kSpace_data_dir  = para.dir.load_kSpace_dir;
kSpace_data_name = para.dir.load_kSpace_name;
PCA_name = strcat(kSpace_data_name(1:end-4),'_PCA.mat');
PCA_dir_oringinal = [kSpace_data_dir,PCA_name];
if isempty(dir(PCA_dir_oringinal))
    para.Recon.PCA_dir = [pwd,'/RawData/',PCA_name];
else
    para.Recon.PCA_dir = PCA_dir_oringinal;
end 
PCA_precomputed = dir(para.Recon.PCA_dir);
para.Recon.ifPCA = ~isempty(PCA_precomputed);


para.Recon.cart_kSpace_dir = strcat(kSpace_data_dir,kSpace_data_name(1:end-4),'_cart.mat');
interp_precomputed = dir(para.Recon.cart_kSpace_dir);
para.Recon.ifInterp = ~isempty(interp_precomputed);

para.CPUtime.load_para_time = toc;toc;fprintf('\n');
end