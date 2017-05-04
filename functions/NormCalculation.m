function [fNorm, tNorm, sNorm, Cost] = NormCalculation(fUpdate, Image, sWeight, tWeight)

fNorm = sum(abs(fUpdate(:)).^2);

if tWeight ~= 0
    tNorm = abs(diff(Image,1,3));
    tNorm = tWeight * sum(tNorm(:));
else
    tNorm = 0;
end

if sWeight ~= 0
    sx_norm = abs(diff(Image,1,2));
    sx_norm(end,:,:,:,:)=[];
    sy_norm = abs(diff(Image,1,1));
    sy_norm(:,end,:,:,:)=[];
    sNorm = sqrt(abs(sx_norm).^2+abs(sy_norm).^2);
    sNorm = sWeight * sum(sNorm(:));
else
    sNorm = 0;
end

Cost = sNorm + tNorm + fNorm;

end