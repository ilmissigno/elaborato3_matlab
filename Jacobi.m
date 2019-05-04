function [x,niter,resrel] = Jacobi(A,b,TOL,MAXITER)
%% Algoritmo di Jacobi
% L' algoritmo di Jacobi per la risoluzione di un sistema lineare Ax=b con A sparsa.
%%
%%
%% Parametri di input:
%%
% A = matrice dei coefficienti di grandi dimensioni e di tipo sparso
% b = vettore dei termini noti
% TOL = facoltativo,tolleranza gestita dall'utente,se omessa TOL=10^-6
% MAXITER = facoltativo,numero massimo di iterazioni,se omesso e' 500
%%
%%
%% Parametri di output:
% x = soluzione calcolata dal sistema
% niter = facoltativo, numero di iterazioni
% resrel = facoltativo, residuo relativo pari a norm(b-A*x)/norm(b)
%%
%%
%% Sintassi
% x = Jacobi(A,b)
% x = Jacobi(A,b,TOL)
% x = Jacobi(A,b,TOL,MAXITER)
% [x,niter] = Jacobi(A,b)
% [x,niter] = Jacobi(A,b,TOL)
% [x,niter] = Jacobi(A,b,TOL,MAXITER)
% [x,niter,resrel] = Jacobi(A,b)
% [x,niter,resrel] = Jacobi(A,b,TOL)
% [x,niter,resrel] = Jacobi(A,b,TOL,MAXITER)
%%
%% Descrizione
% x = Jacobi(A,b) risolve il sistema di equazioni lineari A*x = b.
% A deve essere una matrice quadrata sparsa, b deve essere un vettore colonna
% avente lo stesso numero di righe di A. La soluzione � corretta
% a meno di un errore dovuto al malcondizionamento della matrice A.
% x = Jacobi(A,b,TOL) usa TOL per determinare l'accuratezza della
% soluzione. Se non specificato TOL = 10^-6
% x = Jacobi(A,b,TOL,MAXITER) usa TOL per determinare l'accuratezza
% della soluzione e MAXITER per individuare il numero massimo di iterazioni
% che l'algoritmo puo' compiere. Se non specificati, TOL = 10^-6
% e MAXITER=500.
%%
%% Avvertenze
% Se la function non converge stampa un messaggio di warning con il numero
% di iterazioni raggiunto ed il residuo relativo. Si testi il software su
% matrici sparse di notevoli dimensioni, generate usando funzioni Matlab, che siano
% non singolari e ben condizionate.

if(nargin==1)
    error('Err:NARGIN_1','Un solo parametro specificato, inserire anche il vettore b');
elseif(nargin==2)
    warning('Warn:TOL_MAXITER_NON_SPEC','Attenzione: TOL e MAXITER non specificati, uso TOL=10^-6 e MAXITER=500 valori di default');
    controllo_MatrixA(A);
    n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
    controllo_VectorB(b,n);
    TOL = 10^-6;
    MAXITER = 500;
elseif(nargin==3)
    warning('Warn:MAXITER_NON_SPEC','Attenzione: MAXITER non specificato, uso valore di default MAXITER=500');
    controllo_MatrixA(A);
    n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
    controllo_VectorB(b,n);
    TOL = controllo_Tolleranza(TOL);
    MAXITER = 500;
elseif(nargin==4)
    controllo_MatrixA(A);
    n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
    controllo_VectorB(b,n);
    TOL = controllo_Tolleranza(TOL);
    controllo_MaxIter(MAXITER);
else
    error('Err:NESSUN_PARAM','Specificare il numero corretto di parametri in ingresso');
end

%% Inizializzazione Variabili

iterazioni = 0; % Contatore numero iterazioni
errore_ass = Inf; % Errore assoluto di riferimento

%% Calcolo parametri necessari

D = diag(A); %Matrice diagonale

Dinv = sparse(1:n,1:n,1./D); %Inversa sparsa della matrice D

Bj = speye(n,n) - Dinv*A; %Matrice di iterazione Bj = I - D^-1 * A

x0 = zeros(n,1);

%% VERIFICA DEL TEOREMA DI CONVERGENZA DEL METODO ITERATIVO
tolleranza = TOL*norm(x0,Inf);
if (tolleranza < realmin)
    tolleranza = realmin;
end

%% Criterio di Arresto di Convergenza e Iterazione

x_sol = x0; % Assegno il valore di x0 a x per il calcolo iniziale.

while ((errore_ass > tolleranza) && (iterazioni < MAXITER))
    x_temp = x_sol;
    x_sol = Bj*x_sol + Dinv*b; % Formula di Jacobi in forma matriciale. x^k+1=Bj*x^k+D^-1*b
    errore_ass = norm(x_sol-x_temp,Inf);
    %% VERIFICA DEL TEOREMA DI CONVERGENZA DEL METODO ITERATIVO PER OGNI SOLUZIONE
    tolleranza = TOL*norm(x_sol,Inf);
    if (tolleranza < realmin)
        tolleranza = realmin;
    end
    iterazioni = iterazioni + 1;
end

residuo_rel = norm(b-A*x_sol)/norm(b);

if (MAXITER==iterazioni)
    warning('Warn:NITER_MAGG_MAXITER','Il numero di iterazioni effettuate non � sufficiente per raggiungere l''accuratezza desiderata. niter=%d, residuo_relativo=%s',iterazioni,residuo_rel);
end

switch nargout
    case 1
        %Specificato solo soluzione x come uscita
        x = x_sol;
    case 2
        %Specificati x e numero iterazioni come uscita
        x = x_sol;
        niter = iterazioni;
    case 3
        %Specificati tutti i parametri come uscita
        x = x_sol;
        niter = iterazioni;
        resrel = residuo_rel;
end

end

%% Check del Numero Massimo di Iterazioni
% Controllo se il valore del numero massimo di iterazioni rispetta i
% criteri di un valore numerico adeguato. MAXITER deve essere un intero positivo
function controllo_MaxIter(MAXITER)

if ((~isscalar(MAXITER)) || (~isnumeric(MAXITER)))
    error('Err:MAXITER_NON_VALIDO','MAXITER deve essere un intero positivo');
end
if((isinf(MAXITER)) || (isnan(MAXITER)))
    error('Err:MAXITER_NON_VALIDO','MAXITER deve essere un intero positivo');
end
if((MAXITER <= 0) || (mod(MAXITER,1) > eps))
    error('Err:MAXITER_NON_VALIDO','MAXITER deve essere un intero positivo');
end

% Segnalo se NMAX � piccolo
if (MAXITER < 10)
    warning('Warn:MAXITER_PICCOLO','Il numero di iterazioni specificato � molto piccolo, l''errore di calcolo potrebbe essere elevato');
end

% Segnalo se NMAX � abbastanza grande.
if (MAXITER > 10000)
    warning('Warn:MAXITER_GRANDE','Il numero di iterazioni specificato � molto alto, l''esecuzione potrebbe essere pi� lenta');
end
end

%% Check della Matrice A
% Controllo se A e' sparsa di numeri reali senza contenere elementi nulli
% sulla diagonale principale.
function controllo_MatrixA(A)
if (~issparse(A))
    error('Err:A_NON_SPARSA','Matrice A non sparsa.');
end

if (size(A,1) ~= size(A,2))
    error('Err:A_NON_QUAD','Matrice A non quadrata.');
end

if ((~isnumeric(A)) || (~isreal(A)) || (isempty(A)))
    error('Err:A_NON_VALIDA','Uno o pi� valori inseriti in A non sono validi');
end
if((any(find(isinf(A)))) || (any(find(isnan(A)))))
    error('Err:A_NON_VALIDA','Uno o pi� valori inseriti in A non sono validi');
end
%Controllo di verifica se ci sono elementi nulli sulla diagonale principale
if ((any(find(abs(diag(A)) < eps(norm(A,Inf)))))==1)
    error('Err:A_SINGOLARE','Non ci possono essere elementi nulli sulla diagonale di A.');
end
end

%% Check della Tolleranza
% Controllo se il valore di Tolleranza immesso rispetta i criteri di una
% tolleranza.
function TOL = controllo_Tolleranza(TOL)
% TOL � un intero positivo
if ((~isscalar(TOL)) || (~isnumeric(TOL)))
    error('Err:TOL_NON_VALIDO','TOL deve essere un numero positivo');
end
if((isinf(TOL)) || (isnan(TOL)) || (TOL <= 0))
    error('Err:TOL_NON_VALIDO','TOL deve essere un numero positivo');
end

% Segnalo (eventualmente) che il TOL specificato � troppo piccolo
if (TOL < eps)
    warning('Warn:TOL_PICCOLO','Il valore di TOL specificato � troppo piccolo. Verr� usato il valore di default TOL = 10^-6');
    TOL = 10^-6;
end

if (TOL >= 1)
    warning('Warn:TOL_GRANDE','Il valore di TOL specificato � troppo grande. Il risultato fornito potrebbe essere molto inaccurato. Si guardi la documentazione.');
end
end

%% Check del Vettore B
% Controllo se il vettore B e' dello stesso numero di righe di A, che B
% non contenga valori non ammessi e non reali e che abbia numero di colonne unitario.
function controllo_VectorB(b,dim)
if ((size(b,1) ~= dim) || (size(b,2))~=1)
    error('Err:B_NON_VETTORE','Dimensione del vettore errata.');
end

if ((~isnumeric(b)) || (any(find(isinf(b)))))
    error('Err:B_NON_VALIDO','Uno o pi� valori inseriti nel vettore non sono validi');
end
if((any(find(isnan(b)))) || (~isreal(b)) || (isempty(b)))
    error('Err:B_NON_VALIDO','Uno o pi� valori inseriti nel vettore non sono validi');
end
end