classdef CasiTest < matlab.unittest.TestCase
    
    methods(Test)
        
        function TestCase1(testCase)
            %% CASO DI TEST 1
            % - Matrice A : Non Sparsa
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            A = rand(10);
            x = ones(10,1);
            b = A*x;
            TOL = 10^-8;
            MAXITER = 700;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_NON_SPARSA');
            
        end
        
        function TestCase2(testCase)
            %% CASO DI TEST 2
            % - Matrice A : Non Quadrata
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            A = sprand(10,15,0.1);
            x = ones(15,1);
            b = A*x;
            TOL = 10^-8;
            MAXITER = 700;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_NON_QUAD');
            
        end
        
        function TestCase3(testCase)
            %% CASO DI TEST 3
            % - Matrice A : Non Sparsa con Zero sulla Diagonale
            % - Vettore B : Valido
            % - TOL : Valido
            % - MAXITER : Valido
            
            % Codice
            A = sprand(10,10,0.1);
            A(1,1) = 0;
            x = ones(10,1);
            b = A*x;
            TOL = 10^-8;
            MAXITER = 700;
            
            testCase.verifyError(@()Jacobi(A,b,TOL,MAXITER),'Err:A_SINGOLARE');
            
        end
        
        function TestCase4(testCase)
            %% CASO DI TEST 4
            % - Matrice A : Valida
            % - Vettore B : Valido
            % - TOL : Minore di eps
            % - MAXITER : Valido
            
            % Codice
            A = sprand(10,10,0.1) + speye(10,10);
            x = ones(10,1);
            b = A*x;
            TOL = 10^-20;
            MAXITER = 700;
            
            testCase.verifyWarning(@()Jacobi(A,b,TOL,MAXITER),'Warn:TOL_PICCOLO');
            
        end
        
    end
end

