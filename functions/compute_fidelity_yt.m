function fidelity_update = compute_fidelity_yt(ifNUFFT,image,kSpace,sens_map,sens_map_conj,mask,varargin)

if ifNUFFT == 1

    NUFFT = varargin{1}{1};
    kSpace_update = NUFFT * bsxfun(@times,image,sens_map);

    kSpace_update = kSpace - sum(bsxfun(@times,kSpace_update,mask),5);
    kSpace_update = bsxfun(@times,kSpace_update,mask);

    fidelity_update = NUFFT'* kSpace_update;
    %fidelity_update = NUFFT'* kSpace_update(:,RayIndex_A3J,:,:,:,:);
    %fidelity_update = fidelity_update*7.9134; % number need to test
    %fidelity_update = kSpace - fidelity_update;
        
else

    kSpace_update = bsxfun(@times,image,sens_map);
    kSpace_update(:,:,:,1:2,:,:) = fft2(kSpace_update(:,:,:,1:2,:,:)); % I think only 1% difference in time if split into 2 on CPU.
    kSpace_update(:,:,:,3:4,:,:) = fft2(kSpace_update(:,:,:,3:4,:,:));
    kSpace_update(:,:,:,5:6,:,:) = fft2(kSpace_update(:,:,:,5:6,:,:));
    kSpace_update(:,:,:,7:end,:,:) = fft2(kSpace_update(:,:,:,7:end,:,:));
    

    fidelity_update = kSpace - kSpace_update; clear kSpace_update;
    fidelity_update = bsxfun(@times,fidelity_update,mask);
    fidelity_update(:,:,:,1:2,:,:) = ifft2(fidelity_update(:,:,:,1:2,:,:));
    fidelity_update(:,:,:,3:4,:,:) = ifft2(fidelity_update(:,:,:,3:4,:,:));
    fidelity_update(:,:,:,5:6,:,:) = ifft2(fidelity_update(:,:,:,5:6,:,:));
    fidelity_update(:,:,:,7:end,:,:) = ifft2(fidelity_update(:,:,:,7:end,:,:));

end

fidelity_update = sum(bsxfun(@times,fidelity_update,sens_map_conj),4);
    
end