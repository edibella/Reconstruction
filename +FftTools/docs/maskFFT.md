# MaskFft

The `MaskFft` operator, like the NUFFT operator, uses multiplication and adjoint multiplication to perform forward and backward Fourier transforms (respectively).

The mask part is where the operator uses a binary mask in k-space in order to restrict the data only to acquired k-space points. As long as the mask's first two dimensions match the data's first two dimensions then the mask's other dimensions can be made to match. Internally `MaskFft` uses `repmat` to copy the mask in as many dimensions as needed to match. It does not however handle the case where the mask is larger than the input data.

## Use

You use a MaskFft object by multiplication:

```matlab
obj * x	  	% multiplication
obj' * x		% transposed multiplication
```

Multiplication performs a masked `fft2c` and adjoint multiplication performs a masked `ifft2c`.

## Creation

To create a MaskFft object you just need to hand it the binary logical mask for the data you'll be transforming.

```matlab
obj = MaskFft(kSpaceMask)
```
