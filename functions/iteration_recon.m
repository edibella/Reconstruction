function [Image,para] = iteration_recon(first_est,kSpace,sens_map,mask,para,varargin)
% [Image,para] = iteration_recon(first_est,kSpace,sens_map,phase_mod,para,varargin)
disp('Performing iterative STCR reconstruction...');
disp('Showing progress...')


ifNUFFT        = para.ifNUFFT; 

ifplot         = para.plot;
ifGPU          = para.ifGPU;
noi            = para.noi;
weight_tTV     = para.weight_tTV;
weight_sTV     = para.weight_sTV;
beta_sqrd      = para.beta_square;

step_size      = para.step_size;

img = single(first_est);
clear first_est

sens_map_conj = conj(sens_map);

if ifGPU
    img = gpuArray(img);
    sens_map = gpuArray(sens_map);
    kSpace = gpuArray(kSpace);
    mask = gpuArray(mask);
    sens_map_conj = gpuArray(sens_map_conj);
    beta_sqrd = gpuArray(beta_sqrd);
end


for iter_no = 1:noi
   
    t1 = tic;
    fprintf('%.2f%%...',iter_no/noi*100);

%%%%% fidelity term/temporal/spatial TV
   
    tic; fidelity_update = compute_fidelity_yt(ifNUFFT,img,kSpace,sens_map,sens_map_conj,mask,varargin);para.CPUtime.fidelity(iter_no) = toc;
    tic; tTV_update = compute_tTV_yt(img,weight_tTV,beta_sqrd);  para.CPUtime.tTV(iter_no) = toc;
    tic; sTV_update = compute_sTV_yt(img,weight_sTV,beta_sqrd);  para.CPUtime.sTV(iter_no) = toc;
    update_term  = fidelity_update + tTV_update + sTV_update;

    tic;
    
    [fidelityNorm(iter_no), temporalNorm(iter_no), spatialNorm(iter_no), totalCost(iter_no)] = NormCalculation(fidelity_update, img, weight_sTV, weight_tTV);
    if iter_no>1
        if totalCost(iter_no)>totalCost(iter_no-1)
            step_size = step_size*0.5;
        end
    end
    para.step_size(iter_no) = step_size;
    
    img = img + step_size * update_term; clear update_term
    para.CPUtime.update(iter_no) = toc;

%%%%% plot part 

    if ifplot ==1
        showImage(img,fidelityNorm,temporalNorm,spatialNorm,totalCost)
    end

    toc(t1);
end

Image = squeeze(img);
para = get_CPU_time(para);
fprintf(['Iterative STCR running time is ' num2str(para.CPUtime.interative_recon) 's' '\n'])
disp('Reconstruction done');fprintf('\n')
disp('Saving image into Results...')
Image = gather(Image);

% crop Image to be saved
sx = size(Image,1);
sx4 = round(sx/4);
Image = Image(sx4+1:3*sx4,sx4+1:3*sx4,:);

% adjust orintation of Image
Image = rot90(Image,2);

% save Image
save_dir = strcat(para.Recon.save_dir,para.time);
save([save_dir,'.mat'],'Image','para','-v7.3');

temporalNorm = gather(temporalNorm);
spatialNorm = gather(spatialNorm);
fidelityNorm = gather(fidelityNorm);
totalCost = gather(totalCost);
save([save_dir,'.mat'],'temporalNorm','spatialNorm','fidelityNorm','totalCost','-append')

disp('All done.');fprintf('\n')