namespace QSharpExercises {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
	open Microsoft.Quantum.Arithmetic;
   

    //Problem with AE becuase can only determine probablity of correct state by using
    //Correct States/Total states
    // not probalbity of the correct state by acutall probalbity



    @Test("QuantumSimulator")
    operation TestAE () : Unit {
        //If you want to see detailed output set this to true
        let debug = true;
        //Number of correct tries
        mutable numCorrect = 0;
        //Total tries
        mutable numTotal = 0;
        //Minimuim rate for success (should be 100 for non probabistic algorithms)
        let minRate = 100.0;

        use ampQ = Qubit();
        use c = Qubit[7];
        //Ry(2.0*ArcSin(0.8),ampQ);
        H(ampQ);
        AmplitudeEstimator(ampQ, c);
        //DumpRegister((),[ampQ]+c);
        let cM = MeasureAndMessage("C",c, debug);
        let cAsInt = BoolArrayAsInt(cM);
        let prob = 1.0-PowD(Sin(IntAsDouble(cAsInt)*PI()/PowD(2.0,7.0)), 2.0);
        Message(DoubleAsString(prob));
        let ampM = MeasureAndMessage("ampQ",[ampQ], debug);
        ResetAll([ampQ]+c);

    }

    operation IfOneFlipPhase(ampQ : Qubit, input : Qubit, target: Qubit):Unit is Ctl + Adj{
        //CZ(input,target);
        use flag = Qubit();
        CX(ampQ, flag);
        CX(input, flag);
        CX(flag, input);
        CZ(input, target);
        CX(flag, input);
        CX(ampQ, flag);
        CX(input, flag);
       // ApplyToEachCA(X,[ampQ]+[input]);
    //        Controlled Z([ampQ]+[input],target);
    //        ApplyToEachCA(X,[ampQ]+[input]);
    }
    
	operation AmplitudeEstimator(ampQ: Qubit, counting: Qubit[]): Unit {
		use input = Qubit();
		use target = Qubit();
		X(target);
		H(input);
        ApplyToEach(H,counting);
		

		for i in 0..(Length(counting)-1) {
			for j in 0..(PowI(2,i)-1) {
				Controlled GroverIteration([counting[i]], (ampQ,input, target));
			}
		}

		Adjoint QFTLE(LittleEndian(counting));
		
		ResetAll([target] + [input]);
		
	}
	//This operation flips the phase of the target qubit if the register is in the 0 state
    operation FlipPhaseIfAllZeros (register : Qubit[], target : Qubit) : Unit is Ctl + Adj{
        ApplyToEachCA(X,register); //If all 0s then make all 1s
        Controlled Z(register, target); //If all 1s flip phase of target
        ApplyToEachCA(X,register); //Reset qubits to inital state
    }

    //This is the diffusion operation in Grovers algorithm
    operation DiffusionOperator (
        register : Qubit[],
        target : Qubit
    ) : Unit is Ctl + Adj{
        ApplyToEachCA(H,register); //Apply H all
        FlipPhaseIfAllZeros(register,target); //Apply flip phase of 0 state
        ApplyToEachCA(H,register); //Apply H all
    }

    operation GroverIteration (ampQ: Qubit, input: Qubit, target: Qubit) : Unit is Ctl + Adj{
        IfOneFlipPhase(ampQ, input,target); //Apply the oracle
        DiffusionOperator([input], target); //Apply the diffusion operator
    }

    
}
