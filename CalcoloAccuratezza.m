%% Funzione di Calcolo dell'Accuratezza dell'Algoritmo
% La seguente funzione permette di calcolare quanto l'algoritmo di Jacobi
% implementato e' accurato rispetto alla soluzione, andando a calcolare
% l'indice di condizionamento della matrice A in ingresso, l'errore
% relativo in norma del massimo e il residuo relativo.

function uscita_str = CalcoloAccuratezza(A,x,TOL,MAXITER)
%% Controllo sui parametri di ingresso
switch nargin
    case 1
        error('Inserire minimo 2 parametri di ingresso');
    case 2
        warning('Specificati solo 2 parametri, TOL e MAXITER saranno settati di default');
        TOL = 10^-6;
        MAXITER = 500;
    case 3
        warning('Specificati solo 3 parametri, MAXITER viene settato di default');
        MAXITER = 500;
end
%% Procedura di calcolo della soluzione

b = A*x; % Ricavo b come prodotto righe per colonne tra A e x

% Richiamo l'algoritmo
[x_sol,niter,resrel] = Jacobi(A,b,TOL,MAXITER);

% Il comando "condest" permette di ricavare l'indice di condizionamento in
% norma 1 della matrice considerata come parametro di ingresso.
uscita_str.indice_cond = condest(A);

% L'errore relativo viene calcolato come norma del massimo rispetto alla
% soluzione di partenza data e quella calcolata dall'algoritmo
uscita_str.errore_rel = norm(x-x_sol,Inf)/norm(x_sol,Inf);

% Numero iterazioni e residuo relativo generati dall'algoritmo
uscita_str.numiter = niter;
uscita_str.resid_rel = resrel;

% Il comando "spy" produce un grafico di uscita della sparsita' della
% matrice in ingresso
spy(A);

end