# MultiNufft

The MultiNufft tool is a multidimensional implementation of Jeffrey Fessler's popular NUFFT algorithm. It is multidimensional in the sense that any dimensions above the first two are considered to simply store more sets of 2D data. This means that instead of needing to explicitly loop through a 3D or 4D dataset to perform an NUFFT on each frame, you can simply transform the entire dataset:

```matlab
image4D = nufftObj * data4D;
```

Because this class relies heavily on Fessler's original implementation, it uses a mixture of his original style-guide and the one that the rest of the fftTools package relies on, it has a mixture of variable naming styles and this short guide to names is provided:

```
k - trajectory
w - densityCompensation
```

There are many other non-standard names but they don't overlap with the standard ones so I won't try to explain them.

## Creation

```
Inputs:
	k      -  2DxN non uniform k-space coordinates (complex values)
	          from -0.5 to 0.5. real part is kx imaginary is ky. The N
           dimensions contain unique trajectories.
	w      -  Density weighting vector
	shift  - 	shifts the center of the image [dx,dy]
	imSize - 	2D image size
```

## Use

Function returns a non-uniform FFT taken along each 2D slice of kSpace or imageSpace when multiplying:

```matlab
obj = MultiNufft(k, w, shift, imSize);
kSpace = obj*imageSpace;
imageSpace = obj'*kSpace;
```

You must permute image/k-space to put redundant dimensions at the end.
for example let's say your trajectory is Nro x Nrays x Ntimes then your multi-coil data happens to be stored in the order: Nro x Nrays x Ncoils x Ntimes. Since coils are the redundant dimension (the trajectory does not change coil-to-coil) you must rearrage:

```matlab
nuData = permute(nuData, [1,2,4,3]);
imageData = obj'*nuData;
```

or to go coil by coil:

```matlab
for i = 1:Ncoils
  imageData(:,:,i,:) = obj'*nuData(:,:,i,:);
end
```
