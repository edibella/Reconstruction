function [kSpace,para] = PCA_kSpace_yt(para)

tic;disp('Load k space data...');
PCA_dir          = para.Recon.PCA_dir;
ifPCA            = para.Recon.ifPCA;

if ifPCA
    load(PCA_dir)
    [~,sy,sz,~,~] = size(kSpace);
    disp('PCA result alreaty exists, skip PCA...');para.CPUtime.PCA = toc;toc;fprintf('\n');
else
    load(strcat(para.dir.load_kSpace_dir,para.dir.load_kSpace_name));

    if(size(kSpace,4)==1)
        kSpace = permute(kSpace,[1 2 3 5 4]);
    end
    
    scale_kspace = 10/mean(abs(kSpace(:)));
    kSpace = kSpace*scale_kspace;
    [sx,sy,nc,sz,ns] = size(kSpace);

    para.CPUtime.load_kSpace = toc;toc;fprintf('\n');
    
%%%%% peforming PCA on coils

    disp('Peforming PCA on coils...');tic
    no_comp = 8;
    data = double(permute(kSpace,[1 2 4 5 3]));
    data = reshape(data,[sx*sy*sz*ns nc]);
    [coeff,~,~] = pca(data); %principal component analysis
    compressed_data = data*coeff(:,1:no_comp);
    compressed_data = reshape(compressed_data,[sx sy sz ns no_comp]);
    compressed_data = permute(compressed_data,[1 2 3 5 4]);   
    kSpace = single(compressed_data);
    clear data compressed_data coeff
    save(PCA_dir,'kSpace','RayPosition');

    para.CPUtime.PCA = toc;toc;fprintf('\n');
end

para.Recon.sy = sy;
para.Recon.sz = sz;

