function G = init(kSpace_radial,kx,ky)

sx  = size(kSpace_radial,1);
[Gx,Gy] = GROG.get_Gx_Gy(kSpace_radial, kx, ky);

skx = size(kx,1);
nor = size(kx,2);
nof = size(kx,3);
nc  = size(Gx,1);

max_shift_x = 1/2;
max_shift_y = 1/2;

GxDict_size = max_shift_x*200 + 1;
GyDict_size = max_shift_y*200 + 1;
GxDict = single(zeros([1 nc nc GxDict_size]));
GyDict = single(zeros([nc nc 1 1 GyDict_size]));

dx = -max_shift_x:0.01:max_shift_x;
dy = -max_shift_y:0.01:max_shift_y;

for di=1:GxDict_size
    GxDict(1,:,:,di) = Gx^dx(di);
    GyDict(:,:,1,1,di) = Gy^dy(di);
end

G_r2c_Dict = bsxfun(@times,GxDict,GyDict);
G_r2c_Dict = squeeze(sum(G_r2c_Dict,2));
G_r2c_Dict = reshape(G_r2c_Dict,[nc nc GxDict_size*GyDict_size]);
G_r2c_Dict = permute(G_r2c_Dict,[3 1 2]);

GxDict = permute(GxDict,[2 3 1 4]);
GyDict = permute(GyDict,[3 1 2 4 5]);
G_c2r_Dict = bsxfun(@times,GxDict,GyDict);
G_c2r_Dict = squeeze(sum(G_c2r_Dict,2));
G_c2r_Dict = reshape(G_c2r_Dict,[nc nc GxDict_size*GyDict_size]);
G_c2r_Dict = permute(G_c2r_Dict,[3 1 2]);

x_cart = round(kx);
y_cart = round(ky);

dx = round((x_cart - kx)*100)/100;
dy = round((y_cart - ky)*100)/100;

xDict_r2c = round((dx+max_shift_x)*100)+1;
yDict_r2c = round((dy+max_shift_y)*100)+1;

index_Dict_r2c = sub2ind([GxDict_size GyDict_size],xDict_r2c,yDict_r2c);

xDict_c2r = round(-dx+max_shift_x)*100+1;
yDict_c2r = round(-dy+max_shift_y)*100+1;

index_Dict_c2r = sub2ind([GxDict_size GyDict_size],xDict_c2r,yDict_c2r);

x_cart = x_cart+sx/2+1;
y_cart = y_cart+sx/2+1;

indx = sub2ind([(sx+1+1),(sx+1+1),nof],x_cart,y_cart);

rad2cart = cell(1,nof);
rad_num = (1:skx*nor).';

weight_scale = sqrt(max_shift_x^2+max_shift_y^2)*1.00001;
weight = weight_scale - sqrt(dx.^2 + dy.^2);

weight = permute(weight,[1,2,4,3]);
weight = reshape(weight,sx*nor,nof);

weight_cart = single(zeros((sx+1+1)*(sx+1+1),nof));

for i=1:nof
    indx_temp = indx(:,:,i,:);
    indx_temp = indx_temp(:);
    if mod(1,2) == 0
        rad2cart{i} = sparse(indx_temp,rad_num,1,(sx+1)*(sx+1),skx*nor);
    else
        rad2cart{i} = sparse(indx_temp,rad_num,1,(sx+1+1)*(sx+1+1),skx*nor);
    end

    weight_cart(:,i) = rad2cart{i} * weight(:,i);
    
    weight_temp = full(sum(rad2cart{i},2));
    weight_temp(weight_temp ==0) = 1;
    weight3(:,i) = 1./weight_temp;
    clear indx_temp
end


G.rad2cart = rad2cart;
G.Dict_r2c = G_r2c_Dict;
G.Dict_c2r = G_c2r_Dict;
G.indx_r2c = index_Dict_r2c;
G.indx_c2r = index_Dict_c2r;

G.siz = [skx nor nof nc];
G.weight = weight3;
G.weight1 = reshape(weight,[skx*nor,1,nof]);
G.weight1 = permute(G.weight1,[1 3 2]);
weight_cart(weight_cart==0)=1;
G.weight2 = 1./weight_cart;

