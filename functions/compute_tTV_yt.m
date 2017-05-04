function tTV_update = compute_tTV_yt(image,weight,beta_square)

if weight~=0
    temp_a = diff(image,1,3);
    temp_b = temp_a./(sqrt(beta_square+(abs(temp_a).^2)));
    temp_c = diff(temp_b,1,3);
    tTV_update = weight * cat(3,temp_b(:,:,1,:,:,:),temp_c,-temp_b(:,:,end,:,:,:));
else
    tTV_update = 0;
end

end