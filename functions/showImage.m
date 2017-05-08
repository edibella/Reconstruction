function showImage(Image,fNorm,tNorm,sNorm,Cost)
% adjust orintation
Image = rot90(Image,2);

[nx,ny,nof,~,nSMS,ns] = size(Image);
frame_num = floor(nof/4);
im = reshape(Image,[nx,ny,nof,nSMS*ns]);
if frame_num ~= 0
    im = im(:,:,[frame_num frame_num*2 frame_num*3],:);
    im = permute(im,[1 3 2 4]);
    im = reshape(im,[nx*3 ny*nSMS*ns]);
else
    im = im(:,:,1,:);
    im = squeeze(im);
    im = reshape(im,[nx ny*nSMS*ns]);
end

figure(1)
imagesc(abs(im))
colormap gray
brighten(0.3)
axis image
axis off
        
figure(100)
clf;
hold on;
plot(fNorm,'c*-')
plot(tNorm,'kx-');
plot(sNorm,'k.-');
plot(Cost);

legend('Fidelity Norm','Temopral TV Norm','Spatial TV Norm','Total Cost')
drawnow
end
