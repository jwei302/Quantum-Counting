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
    } // 1 solution

    operation oracle2(register: Qubit[], output : Qubit) : Unit is Ctl + Adj {
        Controlled Z(register[0..1], output);
    } // 2 solution

    operation oracle3(register: Qubit[], output: Qubit) : Unit is Ctl + Adj {
        Controlled Z(register, output);
    } // 1 solution

    operation oracle4(register: Qubit[], output: Qubit) : Unit is Ctl + Adj{
        Controlled Z(register[0..1], output);
    }

    operation findNumSols(inputLength: Int,oracle: ((Qubit[],Qubit)=>Unit is Ctl + Adj)): Int{
        mutable numSols = 0;
        for i in 0..PowI(2,inputLength)-1{
            use input = Qubit[inputLength];
            use output = Qubit();
            H(output);
            let arr = BigIntAsBoolArray(IntAsBigInt(i));
            for j in 0..Length(arr)-1{
                if(arr[j]){
                    X(input[j]);
                }
            }
            oracle(input,output);
            H(output);
            if(M(output) == One){
                set numSols += 1;
            }
            ResetAll(input+[output]);
        }
        return numSols;
    }
    @Test("QuantumSimulator")
    operation GroverUnitTest () : Unit {
        let inputLength = 3;
        use input = Qubit[inputLength];
        use target = Qubit();
        ApplyToEach(H,input);
        X(target);
        GroversAlgorithm(input,target,oracle3);
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

        let chosenOracle = oracle2;
        mutable inputLength = 3;
        let phase = GetPhase(chosenOracle, inputLength);
        Message($"The estimate for phase is: {phase}");
        let amp = GetAmplitude(phase);
        Message($"The estimate for amplitude is: {amp}");
        let count = GetCount(phase,inputLength);
        Message($"The estimate for count is: {count}");
        let numSols = findNumSols(inputLength,chosenOracle);
        Message($"The number of correct solutions is: {numSols}");
        if count == numSols {
            Message("Test passed.");
        }else{
            fail $"Test failed. ";
        }
    }
}
