classdef CasiTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function TestCase1(testCase)
            %% CASO DI TEST 1
            % - Matrice A : Non Sparsa
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            [~,~,b,TOL,MAXITER] = Richiama_Parametri();
            A = rand(10);
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_NON_SPARSA');
            
        end
        
        function TestCase2(testCase)
            %% CASO DI TEST 2
            % - Matrice A : Non Quadrata
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            [~,~,~,TOL,MAXITER] = Richiama_Parametri();
            A = sprand(10,15,0.1);
            x = ones(15,1);
            b = A*x;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_NON_QUAD');
            
        end
        
        function TestCase3(testCase)
            %% CASO DI TEST 3
            % - Matrice A : Sparsa con Zero sulla Diagonale
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            [A,~,b,TOL,MAXITER] = Richiama_Parametri();
            A(1,1) = 0;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_SINGOLARE');
            
        end
        
        function TestCase4(testCase)
            %% CASO DI TEST 4
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Minore di eps
            % - MAXITER : Valido
            
            % Codice
            [A,~,b,~,MAXITER] = Richiama_Parametri();
            TOL = 10^-20;
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL,MAXITER),'Warn:TOL_PICCOLO');
            
        end
        
        function TestCase5(testCase)
            %% CASO DI TEST 5
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Minore di 0
            % - MAXITER : Valido
            
            % Codice
           [A,~,b,~,MAXITER] = Richiama_Parametri();
           TOL = -3;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:TOL_NON_VALIDO');
            
        end
        
        function TestCase6(testCase)
            %% CASO DI TEST 6
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Maggiore di 0
            % - MAXITER : Valido
            
            % Codice
           [A,~,b,~,MAXITER] = Richiama_Parametri();
           TOL = 1;
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL,MAXITER),'Warn:TOL_GRANDE');
            
        end
        
        function TestCase7(testCase)
            %% CASO DI TEST 7
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            % - Eccezione Lanciata: Il Numero di iterazioni e' pari a MAXITER
            
            % Codice
           [A,~,b,TOL,~] = Richiama_Parametri();
           MAXITER = 3;
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL,MAXITER),'Warn:NITER_MAGG_MAXITER');
            
        end
        
        function TestCase8(testCase)
            %% CASO DI TEST 8
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Negativo
            
            % Codice
           [A,~,b,TOL,~] = Richiama_Parametri();
           MAXITER = -1;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:MAXITER_NON_VALIDO');
            
        end
        
        function TestCase9(testCase)
            %% CASO DI TEST 9
            % - Matrice A : Valida
            % - Vettore B : Non un Vettore
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
           [A,~,~,TOL,MAXITER] = Richiama_Parametri();
           b = rand(10);            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:B_NON_VETTORE');
            
        end
        
        function TestCase10(testCase)
            %% CASO DI TEST 10
            % - Matrice A : Valida
            % - Vettore B : Un elemento di B non e' Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
           [A,~,b,TOL,MAXITER] = Richiama_Parametri();
           b(1) = Inf;            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:B_NON_VALIDO');
            
        end
        
        function TestCase11(testCase)
            %% CASO DI TEST 11
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Molto Grande
            
            % Codice
           [A,~,b,TOL,~] = Richiama_Parametri();
           MAXITER = 10500;
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL,MAXITER),'Warn:MAXITER_GRANDE');
            
        end
        
        function TestCase12(testCase)
            %% CASO DI TEST 12
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            % Eccezione Lanciata : Numero Parametri in Ingresso minore di 2
            
            % Codice
           [A,~,~,~,~] = Richiama_Parametri();
            
            testCase.verifyError(@()Jacobi(A),'Err:NARGIN_1');
            
        end
        
        function TestCase13(testCase)
            %% CASO DI TEST 13
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            % Eccezione Lanciata : TOL e MAXITER non specificati
            
            % Codice
           [A,~,b,~,~] = Richiama_Parametri();
            
            testCase.verifyWarning(@()Jacobi(A,b),'Warn:TOL_MAXITER_NON_SPEC');
            
        end
        
        function TestCase14(testCase)
            %% CASO DI TEST 14
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            % Eccezione Lanciata : MAXITER non specificato
            
            % Codice
           [A,~,b,TOL,~] = Richiama_Parametri();
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL),'Warn:MAXITER_NON_SPEC');
            
        end
        
        function TestCase15(testCase)
            %% CASO DI TEST 15
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            % Eccezione Lanciata : Nessun parametro in ingresso
            
            % Codice
            testCase.verifyError(@()Jacobi(),'Err:NESSUN_PARAM');
            
        end
        
    end
end

function [A,x,b,TOL,MAXITER] = Richiama_Parametri()
A = sprand(10,10,0.1) + speye(10,10);
x = ones(10,1);
b = A*x;
TOL = 10^-8;
MAXITER = 700;
end

