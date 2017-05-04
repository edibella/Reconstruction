function filt = designFilter(len, center_shift,type)
% filt = designFilter(len, center_shift,type)
% 'ram-lak'
% 'shepp-logan'
% 'cosine'
% 'hamming'
% 'hann'
filt = -0.5:1/(len-1):0.5;
filt = filt - (0.5+center_shift)/(len-1);
filt = 2*abs(filt);
filt(abs(filt)<1/(len-1)/10) = 2/(len-1);
filt = filt';

w = pi*(0:size(filt,1)/2-1)/(len/2);
w(1) = w(2);
w = fliplr(w);
w(len/2+1:len) = fliplr(w);
w = w';

switch type
    case 'ram-lak'
    case 'shepp-logan'
        filt = filt .* (sin(w/2)./(w/2));
    case 'cosine'
        filt = filt .* cos(w/2);
    case 'hamming'
        filt = filt .* (.54 + .46 * cos(w));
    case 'hann'
        filt = filt .*(1+cos(w)) / 2;
    otherwise
        error('Invalid filter selected.');
end

end
