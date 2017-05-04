function res = ctranspose(a)
% set adjoint to true, this is reset
% to 0 in mtimes since transpose is only meant
% to be used in conjunction with multiplication
a.adjoint = 1;
res = a;

