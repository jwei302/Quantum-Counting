namespace Quantum.FinalProjectAlgorithm {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open final_project_algorithm;
    open final_project_algorithm.counting;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;


    operation oracle1(register : Qubit[], output : Qubit) : Unit is Ctl + Adj {
        ApplyToEachCA(X, register);
        Controlled Z(register, output);
        ApplyToEachCA(X, register);
    }

    @Test("QuantumSimulator")
    operation CountingUnitTest () : Unit {
        mutable inputLength = 3;
        let phase = GetPhase(oracle1, inputLength);
        Message($"The estimate for phase is: {phase}");
        let amp = GetAmplitude(phase);
        Message($"The estimate for amplitude is: {amp}");
        let count = GetCount(phase,inputLength);
        if count == 1 {
            Message("Test passed.");
        }
        else{
            fail $"Test failed. Found number of solutions to be {count} when it should be 1";
        }
    }
}
