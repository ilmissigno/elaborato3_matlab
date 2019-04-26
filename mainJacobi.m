%% FUNZIONAMENTO ALGORITMO
A = gallery('poisson',10);
b = sprand(length(A),1,0.2);
%TOL = 10^-14;
TOL=[10^-1 10^-2 10^-3  10^-4 10^-5 10^-6 10^-7 10^-8 10^-9 10^-10 10^-12 10^-13 10^-14 eps];
MAXITER = 900;
%[x,niter,resrel] = Jacobi(A,b,TOL,MAXITER)

%% VALUTAZIONE PERFORMANCE
Valuta_Performance(A,b,TOL,MAXITER);

%% CASI DI TEST
result = runtests('CasiTest.m');
table(result);
%aaaaa
%aaa2
