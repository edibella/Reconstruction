function [xcoor, ycoor] = get_k_coor(sx,theta,ifNUFFT,kCenter)

xcoor = (1:sx) - kCenter;
ycoor = xcoor;
xcoor = bsxfun(@times,xcoor',cos(theta));
ycoor = bsxfun(@times,ycoor',sin(theta));

if ifNUFFT == 1
    xcoor = xcoor/sx;
    ycoor = ycoor/sx;
end

end
