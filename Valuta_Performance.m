function Valuta_Performance()
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

end