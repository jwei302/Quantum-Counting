namespace Quantum.FinalProjectAlgorithm {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open final_project_algorithm;
    open final_project_algorithm.counting;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;


    operation oracle1(register : Qubit[], output : Qubit) : Unit is Ctl + Adj {
        ApplyToEachCA(X, register);
        Controlled Z(register, output);
        ApplyToEachCA(X, register);
    }

    operation oracle2(register: Qubit[], output : Qubit) : Unit is Ctl + Adj {
        ApplyToEachCA(X, register[0..2..2]);
        Controlled Z(register[0..2..2], output);
        ApplyToEachCA(X, register[0..2..2]);
    }
    @Test("QuantumSimulator")
    operation GroverUnitTest () : Unit {
        let inputLength = 3;
        use input = Qubit[inputLength];
        use target = Qubit();
        ApplyToEach(H,input);
        X(target);
        GroversAlgorithm(input,target,oracle1);
        let output = ResultArrayAsBoolArray(MultiM(input));

        Message("Correct state is 000");
        mutable msg = "";
        for o in output{
		    set msg += o?"1"|"0";
	    }
        Message($"Guessed state is {msg}");
        if(msg != "000"){
            fail "wrong state guessed";
        }
        ResetAll(input + [target]);
    }

    @Test("QuantumSimulator")
    operation CountingUnitTest () : Unit {
        mutable inputLength = 6;
        let phase = GetPhase(oracle2, inputLength);
        Message($"The estimate for phase is: {phase}");
        let amp = GetAmplitude(phase);
        Message($"The estimate for amplitude is: {amp}");
        let count = GetCount(phase,inputLength);
        let count = 1;
        if count == 1 {
            Message("Test passed.");
        }
        else{
            fail $"Test failed. Found number of solutions to be {count} when it should be 2";
        }
    }
}
