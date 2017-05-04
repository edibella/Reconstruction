# Fatrix

A Fatrix object  is a 'fake matrix' system object, designed to generalize matrices by representing any linear operator. The caller can provide a variety of (overloaded) "methods" for this object, particularly multiplication and transposed multiplication.

The utility of this "meta object" is that it allows the object designer
to focus on the key methods, rather than reinventing basic stuff like "size"
and "disp" etc. for each new object.

## Use

You can use a Fatrix object for normal matrix operations like multiplication.
```matlab
ob * x		% multiplication
ob' * x		% transposed multiplication
```
It is up to the caller to provide function handles for both types of multiplication!

## Creation

A Fatrix class is created by passing a Fatrix struct into the constructor:

```matlab
fatrixObj = Fatrix(FatrixStruct);
```

A Fatrix struct is created using the class's Static `create_fatrix_struct` method which requires 2 or more arguments:

1. `dim` - 2 dimensional array giving the dimensions of the Fatrix.
2. `arg` - arguments passed to handle functions (cell or struct)
3. `varargin` - The rest of the arguments are optional pairs speficying function handles or options as described:

```
 handles (all optional): 'name1', handle1, 'name2', handle2, ...
	'forw'		forw(arg, x)	ob * x
	'back'		back(arg, x)	ob' * x
	'gram'		build_gram(ob, W, reuse), build G' * W * G
	'free'		free(arg)
	'abs'		ob = abs(ob): absolute value operation
	'ufun'		out = ufun(ob, varargin) : user-defined function
	'block_setup'	ob = block_setup(ob, varargin)
	'blockify_data'	cell_data = blockify_data(ob, array_data, varargin)
	'mtimes_block'	mtimes_block(arg, is_transpose, x, iblock, nblock)
	'power'		ob = power(ob, sup)	ob.^sup

 options
	'caller', string	name of calling routine ("meta class")
	'cascade_after', thing		ob * x -> thing * forw(arg, x)
	'cascade_before', thing		ob * x -> forw(arg, thing * x)
		these "things" can also be function handles (see mtimes_block.m)
```

To see an example of this class being used internally look at `+fftTools/@MultiNufft/private/Gsparse.m` line 140.

## Author Credit

 Copyright 2004-6-29, Jeff Fessler, The University of Michigan
 Updated and annotated a bit by a guy who doesn't actually understand what the heck a Fatrix is: KC Erb 2015.
