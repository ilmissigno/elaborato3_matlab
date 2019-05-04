%% FUNZIONAMENTO ALGORITMO
A = sparse([2 0 0 1; 4 -1 -1 0; 0 0 1 0; -2 0 0 2]);
b = sparse([8; -1; -18; 8]);
%TOL = 10^-14;
MAXITER = 900;
[x,niter,resrel] = Jacobi(A,b)

%% VALUTAZIONE PERFORMANCE
TOL=[10^-1 10^-2 10^-3  10^-4 10^-5 10^-6 10^-7 10^-8 10^-9 10^-10 10^-12 10^-13 10^-14 eps];
Valuta_Performance(A,b,TOL,MAXITER);

%% CASI DI TEST
result = runtests('CasiTest.m');
table(result)

