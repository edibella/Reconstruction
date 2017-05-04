classdef MaskFft
  properties
    adjoint = 0;
    maskSize
    xSize
    ySize
    zSize
    mask
  end
  methods
    function self = MaskFft(mask)
      % Get original dimensions mask
      self.maskSize = size(mask);
      % Put rest of dimensions into zSize
      [self.xSize, self.ySize, self.zSize] = size(mask);
      self.mask = reshape(mask, self.xSize, self.ySize, self.zSize);
    end
  end
end
