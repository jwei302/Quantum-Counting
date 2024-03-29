﻿namespace final_project_algorithm {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
 
  
    // Flips the phase of the target qubit if the register is in the 0 state
    operation FlipPhaseIfAllZeros (register : Qubit[], target : Qubit) : Unit is Ctl + Adj{
        ApplyToEachCA(X,register); //If all 0s then make all 1s
        Controlled Z(register, target); //If all 1s flip phase of target
        ApplyToEachCA(X,register); //Reset qubits to inital state
    }

    // Diffusion operater in Grovers algorithm
    operation DiffusionOperator (
        register : Qubit[],
        target : Qubit
    ) : Unit is Ctl + Adj{
        ApplyToEachCA(H,register); //Apply H all
        FlipPhaseIfAllZeros(register,target); //Apply flip phase of 0 state
        ApplyToEachCA(H,register); //Apply H all
    }
    
    // Grover's algorithm (input and target must be in 0 state)
    operation GroversAlgorithm (input: Qubit[], target: Qubit, oracle: ((Qubit[],Qubit)=>Unit is Ctl + Adj)) : Unit is Ctl + Adj{

        let iterations = Round(PowD(2.0, IntAsDouble(Length(input)) / 2.0)); //Num of iterations (only valid for 1 solution)

        ApplyToEachCA(H,input); //Apply H all
        X(target); //Flip target to 1 state

        //Run grover iteration 
        for i in 0..iterations-1{ 
            oracle(input,target); //Apply the oracle
            DiffusionOperator(input,target); //Aply the diffusion operator
        }

    }
    
    // Grover's iteration (subrouting for main algorithm)
    operation GroverIteration (input: Qubit[], target: Qubit, oracle: ((Qubit[],Qubit)=>Unit is Ctl + Adj)) : Unit is Ctl + Adj{
        oracle(input,target); //Apply the oracle
        DiffusionOperator(input,target); //Aply the diffusion operator
    }
}
