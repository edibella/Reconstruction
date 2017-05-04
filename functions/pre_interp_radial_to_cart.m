function kSpace_cart_out = pre_interp_radial_to_cart(kSpace_radial,x_coor,y_coor)

[sx,nor,nf,nc,nSMS,ns] = size(kSpace_radial);
data = double(reshape(kSpace_radial,[sx*nor,nf*nc*nSMS*ns]));

x = reshape(x_coor,[sx*nor,nf]);
y = reshape(y_coor,[sx*nor,nf]);

x = repmat(x,[1 nc*nSMS*ns]);
y = repmat(y,[1 nc*nSMS*ns]);

Xr = round(x);
Yr = round(y);

kSpace_cart = single(zeros((sx+1)*(sx+1),nf*nc*nSMS*ns));
kSpace_r = single(zeros(sx*nor,nf*nc*nSMS*ns));

parfor k=1:nf*nc*nSMS*ns
    warning off
    kSpace_r(:,k) = griddata(x(:,k),y(:,k),data(:,k),Xr(:,k),Yr(:,k));
end

kSpace_r(isnan(kSpace_r)) = 0;

indx = sub2ind([sx+1,sx+1,nf*nc*nSMS*ns],Xr+sx/2+1,Yr+sx/2+1);

for i=1:nf*nc*nSMS*ns
    kSpace_cart(indx(:,i),i) = kSpace_r(:,i);
end

kSpace_cart = reshape(kSpace_cart,[sx+1,sx+1,nf,nc,nSMS,ns]);
kSpace_cart_out = kSpace_cart(2:end,2:end,:,:,:,:);

end