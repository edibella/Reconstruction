classdef MultiNufft
  properties
    adjoint = 0;
    kSize
    kSize_x
    kSize_y
    kSize_z
    imSize
    imSize_x
    imSize_y
    Kd
    kx
    ky
    Nd
    Jd
    n_shift
    w
    nufft_structs
  end
  methods
    function  self = MultiNufft(k, w, shift, imSize)
      self = determine_k_space_size(self, k);
      self = determine_image_size(self, imSize);
      self = determine_kx_ky(self, k);
      self = init_nufft_vars(self, imSize, w, shift);
      self = init_nufft_structs(self);
    end
    function self = determine_k_space_size(self, k)
      self.kSize = size(k);
      [self.kSize_x, self.kSize_y, self.kSize_z] = size(k);
    end
    function self = determine_image_size(self, imSize)
      self.imSize = imSize;
      self.imSize_x = self.imSize(1);
      self.imSize_y = self.imSize(2);
    end
    function self = determine_kx_ky(self, k)
      kxs = real(k);
      kys = imag(k);
      kxs = reshape(kxs, self.kSize_x, self.kSize_y, self.kSize_z);
      kys = reshape(kys, self.kSize_x, self.kSize_y, self.kSize_z);
      self.kx = kxs;
      self.ky = kys;
    end
    function self = init_nufft_vars(self, imSize, w, shift) %some parameters to play with
      Nd = imSize;
      self.Nd = Nd;
      self.Jd = [6,6];
      self.Kd = floor(Nd*1.5);
      self.n_shift = Nd/2 + shift;
      self.w = w;
    end
    function self = init_nufft_structs(self)
      for i = 1:self.kSize_z
        kxs = self.kx(:,:,i);
        kys = self.ky(:,:,i);
        om = [kxs(:), kys(:)]*2*pi;
        if i == 1
          self.nufft_structs = nufft_init_ye(om, self.Nd, self.Jd, self.Kd, self.n_shift,'kaiser');
        else
          self.nufft_structs(i) = nufft_init_ye(om, self.Nd, self.Jd, self.Kd, self.n_shift,'kaiser');
        end
      end
    end
  end % methods
end % classdef
