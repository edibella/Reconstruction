% Flip adjoint bit to determine how to handle multiplication
function res = ctranspose(a)
a.adjoint = xor(a.adjoint,1);
res = a;
