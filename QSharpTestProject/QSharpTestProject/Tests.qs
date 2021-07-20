namespace Quantum.FinalProjectAlgorithm {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open QSharpTestProject;
    
    
    @Test("QuantumSimulator")


    operation oracle1(register : Qubit[], output : Qubit) : Unit {
        ApplyToEach(X, register);
        Controlled Z(register, output);
        ApplyToEach(X, register);
    }
    operation CountingUnitTest () : Unit {
        mutable inputLength = 3;
        let val1 = QuantumCounting(oracle1, inputLength);
        if val1 == 1 {
            Message("Test passed.");
        }
        else{
            Message($"Test failed. Found number of solutions to be {val1} when it should be 1");
        }
    }
}
