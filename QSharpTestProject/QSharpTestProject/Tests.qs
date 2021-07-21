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
        Controlled Z(register[0..1], output);
    } 

    operation oracle3(register: Qubit[], output: Qubit) : Unit is Ctl + Adj {
        Controlled Z(register, output);
    }

    operation oracle4(register: Qubit[], output: Qubit) : Unit is Ctl + Adj{
        X(register[0]);
        Controlled Z(register[0..1], output);
        Controlled Z([register[0]], output);
        X(register[0]);
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
    operation TestCounting(inputLength : Int, oracle: ((Qubit[],Qubit)=>Unit is Ctl + Adj)): Bool{
        let phase = GetPhase(oracle, inputLength);
        //Message($"The estimate for phase is: {phase}");
        let amp = GetAmplitude(phase);
        //Message($"The estimate for amplitude is: {amp}");
        let count = GetCount(phase,inputLength);
        //Message($"The estimate for count is: {count}");
        let numSols = findNumSols(inputLength,oracle);
        //Message($"The number of correct solutions is: {numSols}");
        if count == numSols {
            //Message("Test passed.");
            return true;
        }else{
            //Message("Test failed.");
            return false;
        }
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
        let oracleList = [oracle1,oracle2,oracle3,oracle4];
        mutable numTestsPassed = 0;
        let maxLen = 5;
        for inputLength in 2..maxLen{
            for oracle in oracleList{
                if(TestCounting(inputLength,oracle)){
                    set numTestsPassed += 1;
                }
            }
        }
        let successRate = 100.0*IntAsDouble(numTestsPassed)/IntAsDouble(Length(oracleList)*(maxLen-1));
        Message($"Rate of Success: {successRate}%");
        
        if(successRate < 90.0){
            fail "Success rate was too low";
        }
    }
}
