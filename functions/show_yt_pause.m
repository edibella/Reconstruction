function show_yt_pause(img)
figure
for i=1:size(img,3)
    imagesc(abs(img(:,:,i)))
    colormap gray
    axis image
    title(i)
    %drawnow
    pause
end
end