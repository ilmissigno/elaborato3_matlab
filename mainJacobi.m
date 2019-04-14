A = gallery('poisson',10);
b = sprand(length(A),1,0.2);
TOL = 10^-14;
MAXITER = 900;
[x,niter,resrel] = Jacobi(A,b,TOL,MAXITER)