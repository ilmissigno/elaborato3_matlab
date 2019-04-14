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
%% Avvertenze
% Se la function non converge stampa un messaggio di warning con il numero
% di iterazioni raggiunto ed il residuo relativo. Si testi il software su
% matrici sparse di notevoli dimensioni, generate usando funzioni Matlab, che siano
% non singolari e ben condizionate.

switch nargin
    case 1
        error('Un solo parametro specificato, inserire anche il vettore b');
    case 2
        warning('Attenzione: TOL e MAXITER non specificati, uso TOL=10^-6 e MAXITER=500 valori di default');
        controllo_MatrixA(A);
        n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
        controllo_VectorB(b,n);
        TOL = 10^-6;
        MAXITER = 500;
    case 3
        warning('Attenzione: MAXITER non specificato, uso valore di default MAXITER=500');
        controllo_MatrixA(A);
        n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
        controllo_VectorB(b,n);
        TOL = controllo_Tolleranza(TOL);
        MAXITER = 500;
    case 4
        controllo_MatrixA(A);
        n = size(A,1); % Ricavo la dimensione di A che serve per il controllo del vettore b
        controllo_VectorB(b,n);
        TOL = controllo_Tolleranza(TOL);
        controllo_MaxIter(MAXITER);
    otherwise
        error('Specificare il numero corretto di parametri in ingresso');
end

%% Inizializzazione Variabili


numiter = 0; % Contatore numero iterazioni
errore = Inf; % Errore assoluto di riferimento

% Il metodo iterativo di Jacobi richede che la matrice di ingresso sia una
% matrice sparsa di grandi dimensioni. Inoltre nella formula di risoluzione
% compaiono i seguenti termini:
%% Formula : x^(k+1) = Bj * x^k + D^-1 * b
% Il termine x e' la soluzione al passo k e k+1 successivo
% D e' la matrice diagonale ottenuta da A (la formula effettua un
% inversione di D)
% Bj e' la matrice ottenuta andando a effettuare la differenza tra la
% matrice identita' della stessa dimensione di A e il prodotto tra
% l'inversa della matrice diagonale D per A.
% Ovviamente le matrici, essendo dipendenti da A, devono essere sparse.

%% Ricavo i parametri necessari
%%
% Matrice diagonale di A (ottenuta con il comando diag(A)

D = diag(A);

%%

% Inversa sparsa della matrice D ottenuta andando a specificare nel comando
% 'sparse' del Matlab le righe e le colonne e gli elementi la quale 
% deve assumere. Ovviamente nella stessa istruzione
% immettiamo 1:n per le righe e per le colonne in modo tale da effettuare
% un ciclo for doppio, di riempimento. (Si veda il comando matlab 'sparse'
% per ulteriori informazioni.

Dinv = sparse(1:n,1:n,1./D);

%%
% Matrice Bj di iterazione (necessariamente sparsa) utilizzata per ricavare
% la risoluzione ad ogni iterazione. Ottenuta andando a utilizzare il
% comando 'speye' che ottiene una matrice identita' di dimensione n della
% matrice A.

Bj = speye(n,n) - Dinv*A;

%%
% Il metodo di Jacobi essendo iterativo richiede che sia soddisfatto un
% criterio di arresto per garantire la convergenza del metodo. Questo deve
% essere effettuato andando a verificare il Teorema di Convergenza. Nel
% senso che numericamente, se il valore di Tolleranza immessa e' tale che
% la norma della differenza delle soluzioni ai passi k+1 e k e' minore o
% uguale al valore di tolleranza per la norma della soluzione al passo k.
% Quindi, effettuiamo un controllo di ammissibilita' per TOL andando a
% specificare una soluzione vettore colonna iniziale del metodo, nulla.

x0 = zeros(n,1);
tolleranza = check_UnderflowTOL(TOL,x0);

%% Criterio di Arresto di Convergenza e Iterazione
% Appena viene verificato il Criterio di Arresto di Convergenza
% (errore k-esimo assoluto�[associato alla soluzione al passo k+1 e k] 
% minore o uguale al valore di tolleranza k-esimo 
% associato alla soluzione k), il ciclo viene arrestato. Tutto in accordo
% con la condizione di emergenza che il numero di iterazioni contate non
% superino o siano uguali al valore massimo di iterazioni immesso in
% ingresso.

% Assegno il valore di x0 a x per il calcolo iniziale.

x_sol = x0;

while ((errore > tolleranza) && (numiter < MAXITER))
    x_temp = x_sol;
    x_sol = Bj*x_sol + Dinv*b; % Formula di Jacobi specificata prima.
    errore = norm(x_sol-x_temp,Inf);
    tolleranza = check_UnderflowTOL(TOL,x_sol);
    numiter = numiter + 1;
end

% Il residuo relativo viene calcolato solo se l'utente specifica il
% parametro di output oppure se l'algoritmo raggiunge il massimo numero
% di iterazioni.
if (MAXITER==numiter)
    resrel = norm(b-A*x_sol,Inf)/norm(b,Inf);
    warning('Il numero di iterazioni effettuate non � sufficiente per raggiungere l''accuratezza desiderata. niter=%d, residuo_relativo=%s',numiter,resrel);
end

switch nargout
    case 1
        disp('Specificato solo soluzione x come uscita');
        x = x_sol;
    case 2
        disp('Specificati x e numero iterazioni come uscita');
        x = x_sol;
        niter = numiter;
    case 3
        disp('Specificati tutti i parametri come uscita');
        x = x_sol;
        niter = numiter;
        resrel = norm(b-A*x,Inf)/norm(b,Inf);
end

end

%% Funzione di verifica del Teorema di Convergenza
function tolleranza = check_UnderflowTOL(TOL,solk)
    tolleranza = TOL*norm(solk,Inf);
    if (tolleranza < realmin)
        tolleranza = realmin;
    end
end

%% Check della Matrice A
% Controllo se A e' sparsa di numeri reali senza contenere elementi nulli
% sulla diagonale principale.
function controllo_MatrixA(A)
if (~issparse(A))
    error('Matrice A non sparsa.');
end

if (size(A,1) ~= size(A,2))
    error('Matrice A non quadrata.');
end

if ((~isnumeric(A)) || (any(find(isinf(A)))) || (any(find(isnan(A)))) || (~isreal(A)) || (isempty(A)))
    error('Uno o pi� valori inseriti in A non sono validi');
end
%Controllo di verifica se ci sono elementi nulli sulla diagonale principale
if ((any(find(abs(diag(A)) < eps(norm(A,Inf)))))==1)
    error('Non ci possono essere elementi nulli sulla diagonale di A.');
end
end

%% Check del Vettore B
% Controllo se il vettore B e' dello stesso numero di righe di A, che B
% non contenga valori non ammessi e non reali e che abbia numero di colonne unitario.
function controllo_VectorB(b,dim)
if ((size(b,1) ~= dim) || (size(b,2))~=1)
    error('Dimensione del vettore errata.');
end

if ((~isnumeric(b)) || (any(find(isinf(b)))) || (any(find(isnan(b)))) || (~isreal(b)) || (isempty(b)))
    error('Uno o pi� valori inseriti nel vettore non sono validi');
end
end

%% Check della Tolleranza
% Controllo se il valore di Tolleranza immesso rispetta i criteri di una
% tolleranza.
function TOL = controllo_Tolleranza(TOL)
% TOL � un intero positivo
if ((~isscalar(TOL)) || (~isnumeric(TOL)) || (isinf(TOL)) || (isnan(TOL)) || (TOL <= 0))
    error('TOL deve essere un numero positivo');
end

% Segnalo (eventualmente) che il TOL specificato � troppo piccolo
if (TOL < eps)
    warning('Il valore di TOL specificato � troppo piccolo. Verr� usato il valore di default TOL = 10^-6');
    TOL = 10^-6;
end

if (TOL >= 1)
    warning('Il valore di TOL specificato � troppo grande. Il risultato fornito potrebbe essere molto inaccurato. Si guardi la documentazione.');
end
end

%% Check del Numero Massimo di Iterazioni
% Controllo se il valore del numero massimo di iterazioni rispetta i
% criteri di un valore numerico adeguato.
function controllo_MaxIter(MAXITER)
% MAXITER deve essere un intero positivo
% N.B : La funzione mod serve a valutare il valore del resto della
% divisione del dividendo specificato in corrispondenza al divisore.
% in questo caso se la divisione restituisce un numero grande allora vuol
% dire che MAXITER e' molto piccolo. Viceversa indica che MAXITER e' un
% valore grande.
if ((~isscalar(MAXITER)) || (~isnumeric(MAXITER)) || (isinf(MAXITER)) || (isnan(MAXITER)) || (MAXITER <= 0) || (mod(MAXITER,1) > eps))
    error('MAXITER deve essere un intero positivo');
end

% Segnalo se NMAX � piccolo
if (MAXITER < 10)
    warning('Il numero di iterazioni specificato � molto piccolo, l''errore di calcolo potrebbe essere elevato');
end

% Segnalo se NMAX � abbastanza grande.
if (MAXITER > 10000)
    warning('Il numero di iterazioni specificato � molto alto, l''esecuzione potrebbe essere pi� lenta');
end
end