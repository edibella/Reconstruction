function N = init(kSpace_radial,kx,ky)

sx  = size(kSpace_radial,1);
skx = size(kx,1);
nor = size(kx,2);
nof = size(kx,3);
nc  = size(kSpace_radial,4);

max_shift_x = 0.5;
max_shift_y = 0.5;

x_cart = zeros(skx,nor,nof,1);
y_cart = zeros(skx,nor,nof,1);

x_cart(:,:,:,1) = round(kx);
y_cart(:,:,:,1) = round(ky);

x_cart = reshape(x_cart,skx,nor,nof,1);
y_cart = permute(y_cart,[1,2,3,5,4]);
y_cart = reshape(y_cart,skx,nor,nof,1);

dx = round((x_cart - kx)*100)/100;
dy = round((y_cart - ky)*100)/100;

x_cart = x_cart+sx/2+1;
y_cart = y_cart+sx/2+1;

indx = sub2ind([(sx+2),(sx+2),nof],x_cart,y_cart);

rad2cart = cell(1,nof);
rad_num = (1:skx*nor).';

weight_scale = sqrt(max_shift_x^2+max_shift_y^2)*1.00001;
weight = weight_scale - sqrt(dx.^2 + dy.^2);
weight = permute(weight,[1,2,4,3]);
weight = reshape(weight,sx*nor,nof);

weight_cart = single(zeros((sx+2)*(sx+2),nof));

for i=1:nof
    indx_temp = indx(:,:,i,:);
    indx_temp = indx_temp(:);
    rad2cart{i} = sparse(indx_temp,rad_num,1,(sx+2)*(sx+2),skx*nor);
    
    weight_cart(:,i) = rad2cart{i} * weight(:,i);
    
    weight_temp = full(sum(rad2cart{i},2));
    weight_temp(weight_temp ==0) = 1;
    weight3(:,i) = 1./weight_temp;
    clear indx_temp
end

%%%

N.rad2cart = rad2cart;
N.siz = [skx nor nof nc];
N.weight = weight3;
N.weight1 = reshape(weight,[skx*nor,1,nof]);
N.weight1 = permute(N.weight1,[1 3 2]);
weight_cart(weight_cart==0)=1;
N.weight2 = 1./weight_cart;
