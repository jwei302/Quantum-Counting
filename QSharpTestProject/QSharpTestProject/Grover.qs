namespace QSharpTestProject {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    
    //This operation flips the phase of the target qubit if the register is in the 0 state
    operation FlipPhaseIfAllZeros (register : Qubit[], target : Qubit) : Unit {
        ApplyToEach(X, register); //If all 0s then make all 1s
        Controlled Z(register, target); //If all 1s flip phase of target
        ApplyToEach(X, register); //Reset qubits to inital state
    }
    //This is the diffusion operation in Grovers algorithm
    operation DiffusionOperator (
        register : Qubit[],
        target : Qubit
    ) : Unit {
        ApplyToEach(H,register); //Apply H all
        FlipPhaseIfAllZeros(register,target); //Apply flip phase of 0 state
        ApplyToEach(H,register); //Apply H all
    }
    //Grovers algorithm (input and target must be in 0 state)
    operation GroversAlgorithm (input: Qubit[], target: Qubit, oracle: ((Qubit[],Qubit)=>Unit)) : Unit {

        let iterations = Round(PowD(2.0, IntAsDouble(Length(input)) / 2.0)); //Num of iterations (only valid for 1 solution)

        ApplyToEach(H,input); //Apply H all
        X(target); //Flip target to 1 state

        //Run grover iteration 
        for i in 0..iterations-1{ 
            oracle(input,target); //Apply the oracle
            DiffusionOperator(input,target); //Aply the diffusion operator
        }

    }
}
