function kSpace_cart_out = interp(kSpace_radial,G)

sx = G.siz(1);
nor = G.siz(2);
nof = G.siz(3);
nc = G.siz(4);


kSpace_radial = reshape(kSpace_radial,[sx*nor*nof,1,1,nc]);

kSpace_cart = zeros([(sx+2)*(sx+2) nof nc]);


G_all = G.Dict_r2c(G.indx_r2c,:,:);
G_all = reshape(G_all,[sx*nor*nof,1,nc,nc]);

k_target = bsxfun(@times,G_all,kSpace_radial);
k_target = sum(k_target,4);

k_target = reshape(k_target,[sx*nor,nof,1,nc]);

k_target = bsxfun(@times,k_target,G.weight1);

k_target = permute(k_target,[1 3 4 2]);
k_target = reshape(k_target,[sx*nor,nc,nof]);

for i=1:nof
    kSpace_cart(:,i,:) = single(G.rad2cart{i}*double(k_target(:,:,i)));
end
kSpace_cart = bsxfun(@times,kSpace_cart,G.weight2);
kSpace_cart = reshape(kSpace_cart,[sx+2 sx+2 nof nc]);
kSpace_cart_out = kSpace_cart(2:end-1,2:end-1,:,:);
