function Valuta_Performance(A,b,TOL,MAXITER)
%% Funzione di Valutazione delle Performance
%La seguente funzione mette alla luce le differenze del metodo implementato
%di Jacobi con la funzione del Matlab "bicg", entrambe richiedono i stessi
%parametri di ingresso e allo stesso modo restituiscono i stessi parametri
%di uscita. Le differenze tra i vari metodi vengono poi mostrate su di un
%grafico.

switch nargin
    case 0
        error('Nessun valore in ingresso');
    case 1
        error('Inserire anche il vettore B');
    case 2
        warning('Warn:TOL_MAXITER_NON_SPEC','Attenzione: TOL e MAXITER non specificati, uso valori di default');
        TOL=[10^-1 10^-2 10^-3  10^-4 10^-5 10^-6 10^-7 10^-8 10^-9 10^-10 10^-12 10^-13 10^-14 eps];
        MAXITER = 500;
    case 3
        warning('Warn:MAXITER_NON_SPEC','Attenzione: MAXITER non specificato, uso valore di default MAXITER=500');
        MAXITER = 500;
end

%Inizializzazione Variabili
RisultatiJacobi = zeros(1,14);
RisultatiBicg = zeros(1,14);

%Calcolo dei risultati effettivi
for(i = 1:14)
    [x,niter,resrel] = Jacobi(A,b,TOL(i),MAXITER);
    RisultatiJacobi(i) = niter;
    options = optimset('TolX',TOL(i));
    [x,~,~,iter] = bicg(A,b,TOL(i),MAXITER);
    RisultatiBicg(i) = iter;
end
% Creazione grafico Numero iterazioni
figure('Renderer', 'painters', 'Position', [100 100 900 1600])
subplot(3,3,[1 3]);
plot(categorical(TOL),(RisultatiJacobi),'r--*',categorical(TOL),(RisultatiBicg),'b--*');
grid on;
title('Metodo di Jacobi VS Bicg');
legend('Risultati Jacobi','Risultati Bicg','Location','northwest');
set(gca,'Xdir','reverse'); %cambia la direzione dell'asse x
xlabel('TOL') ;
ylabel('Numero di iterazioni')

% Creazione grafico Indice Condizionamento,Errore Relativo e Residuo Relativo

for(k=2:200)
    A = sprand(k,k,0.1) + speye(k,k);
    x = 2*ones(k,1);
    b = A*x;
    c(k) = condest(A); %condizionamento per matrici sparse
    %N.B : ho dato dei valori arbitrari per la tolleranza qui piu preciso
    [y1,~,resid] = Jacobi(A,b,10^-12,MAXITER);
    re_1(k) = resid;
    er_1(k) = norm(x-y1)/norm(x);
    [y2,~,resrel] = bicg(A,b,10^-12,MAXITER);
    re_2(k) = resrel;
    er_2(k) = norm(x-y2)/norm(x);
end
x = 1:200;
subplot(3,3,4);
plot(x,log10(c));
xlabel('Numero di righe matrice A')
ylabel('Esponente di 10')
title('Indice di Condizionamento')
hold on
subplot(3,3,[5 6]);
plot(x,log10(re_1),'g',x,log10(er_1),'m')
legend('Residuo Jacobi','Errore Jacobi')
xlabel('Numero di righe matrice A')
ylabel('Esponente di 10')
title('Confronto Errore Residuo Jacobi')
subplot(3,3,[7 9]);
plot(x,log10(re_2),'g',x,log10(er_2),'m')
legend('Residuo Bicg','Errore Bicg')
xlabel('Numero di righe matrice A')
ylabel('Esponente di 10')
title('Confronto Errore Residuo Bicg')
sgtitle('Grafico degli indici di condizionamento, Errore, Residuo e Numero Iterazioni per Jacobi/Bicg')

end