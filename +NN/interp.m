function kSpace_cart = interp(kSpace_radial,N)

sx = N.siz(1);
nor = N.siz(2);
nof = N.siz(3);
nc = N.siz(4);

kSpace_radial = reshape(kSpace_radial,[sx*nor*nof,1,1,nc]);

kSpace_cart = zeros([(sx+2)*(sx+2) nof nc]);

kSpace_radial = reshape(kSpace_radial,[sx*nor,nof,1,nc]);

kSpace_radial = bsxfun(@times,kSpace_radial,N.weight1); % change weight here

kSpace_radial = permute(kSpace_radial,[1 3 4 2]);
kSpace_radial = reshape(kSpace_radial,[sx*nor,nc,nof]);

for i=1:nof
    kSpace_cart(:,i,:) = single(N.rad2cart{i}*double(kSpace_radial(:,:,i)));
end
kSpace_cart = bsxfun(@times,kSpace_cart,N.weight2); % weight by distance +
%number of points
%kSpace_cart = bsxfun(@times,kSpace_cart,N.weight); % weight by number of points

kSpace_cart = reshape(kSpace_cart,[sx+2 sx+2 nof nc]);
kSpace_cart = kSpace_cart(2:end-1,2:end-1,:,:);

