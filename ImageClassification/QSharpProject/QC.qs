namespace QSharpExercises {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
   
    //Test for Quantum Comparator
    @Test("QuantumSimulator")
    operation TestQC () : Unit {
        //If you want to see detailed output set this to true
        let debug = false;
        //Number of correct tries
        mutable numCorrect = 0;
        //Total tries
        mutable numTotal = 0;
        //Minimuim rate for success (should be 100 for non probabistic algorithms)
        let minRate = 100.0;
        //For all lengths from 1 to 5
        for length in 1..5{
            //For all states of register1 and register2
            for reg2State in 0..PowI(2,length)-1{
                for reg1State in 0..PowI(2,length)-1{
                    //Init two registers
                    use reg1 = Qubit[length];
                    use reg2 = Qubit[length];
                    //Init target qubit
                    use target = Qubit();
                    //Prep reg1 and reg2 in their respective states
                    PrepBE(reg1, reg1State);
                    PrepBE(reg2, reg2State);
                    //Compare reg1 and reg2 and flip target if reg1 > reg2
                    QuantumComparator(reg1,reg2,target);
                    //Measure all the qubits
                    let reg1M = MeasureAndMessage("Reg1", reg1, debug);
                    let reg2M = MeasureAndMessage("Reg2",reg2, debug);
                    let targetM = MeasureAndMessage("Target",[target], debug);
                    //Guess state of target
                    let guess = targetM[0];
                    //Correct state
                    let real = (reg1State > reg2State);
                    //Output debugging results
                    MessageAndDebug($"Reg1State: {reg1State}", debug);
                    MessageAndDebug($"Reg2State: {reg2State}", debug);
                    if(guess == real){
                        MessageAndDebug("Correct comparison made", debug);
                        set numCorrect += 1;
                    }else{
                        MessageAndDebug($"Incorrect compasison made, guess: {guess}, real:{real}", debug);
                    }
                    //Reset all qubits
                    ResetAll(reg1+reg2+[target]);
                    //Increment total number of tries
                    set numTotal += 1;
		        }
		    }
	    }
        //Rate of success as a percentage
        let rateOfSuccess = 100.0*IntAsDouble(numCorrect)/IntAsDouble(numTotal);
        Message($"Rate of success: {rateOfSuccess}%");
        if (rateOfSuccess < minRate){
            fail "Rate of success was too low";
        }
    }

    //Accepts input as Big Endian Registers and flips o if r > p
    //Algorithm is O(log(n)) worst case
    operation QuantumComparator(r: Qubit[], p: Qubit[], o : Qubit): Unit{
        //Flag qubit
        use f = Qubit();
        //Set to |1>
        X(f);
        //For each qubit in r and p
        for i in 0..Length(r)-1{
            //Ancillia qubit to get the comparison result of bits
            use s = Qubit();
            //Compare bits
            Controlled FlagAndOut([f], (r[i],p[i],s,o));
            //Move comparison into f
            CNOT(s,f);
           
            Reset(s);
        }
        Reset(f);
    }

    //Compares bits r and p 
    operation FlagAndOut(r: Qubit, p: Qubit, f : Qubit, o : Qubit): Unit is Ctl + Adj{
        //If r > p then f = |1> and o = |1>
        //If r < p then f = |1> and o = |0>
        //If r == p then f = |0> and o = |0>
        X(r);
        CCNOT(r,p,f);
        X(r);
        X(p);
        CCNOT(r,p,f);
        CCNOT(r,p,o);
        X(p);
    }

    
}
