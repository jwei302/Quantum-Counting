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
    operation TestAE () : Unit{
        //If you want to see detailed output set this to true
        let debug = true;
        //Number of correct tries
        mutable numCorrect = 0;
        //Total tries
        mutable numTotal = 0;
        //Minimuim rate for success (should be 100 for non probabistic algorithms)
        let minRate = 100.0;
        //qubit with amp

        use j = Qubit[3];
        use ampQ = Qubit[1];
        ApplyToEach(H, j);
        
        for i in 0..PowI(2, Length(j))-1{
            use extrasY = Qubit[Length(j)];
            AreRegIntEqual(j,i,extrasY);
            Controlled Ry(extrasY, (IntAsDouble(i)*PI()/3.0, ampQ[0]));
            Adjoint AreRegIntEqual(j,i,extrasY);
        }

        //Controlled Ry(j, (2.0*ArcSin(Sqrt(0.0)),ampQ[0]));
        

        //Ry(2.0*ArcSin(Sqrt(0.0)),ampQ[0]);
        //H(ampQ[0]);
        //X(ampQ[0]);

       
        //counting qubits
        use c = Qubit[7];
        //target qubit
        use target = Qubit();
        //Make ampQ have 0.5 probablity for |1>
		//Controlled ApplyToEachCA(ampQ, (X, input));
	    
        //Apply amplitude estimator
        AmplitudeEstimator(j, target, c);
        //Measure counting register
        let cM = MeasureAndMessage("C",c, debug);

        MandMInt("j", j);
        //Calculate counting as int
        let cAsInt = BoolArrayAsInt(cM);
        Message("C:" + IntAsString(cAsInt));
        //Calc probablity based on c

        let amplitude = PowD(Sin((IntAsDouble(cAsInt)/PowD(2.0,IntAsDouble(Length(c)))) * PI() * 2.0),2.0);
        let prob = 1.0-PowD(Sin(IntAsDouble(cAsInt)*PI()/PowD(2.0,7.0)), 2.0);
        Message("Prob:" + DoubleAsString(prob));
        Message("Amplitude:" + DoubleAsString(amplitude));
        ResetAll(ampQ+c);
        ResetAll([target]+j);

    }

    operation IfOneFlipPhase(input : Qubit[], target: Qubit):Unit is Ctl + Adj{
        Controlled Z(input,target);
    }
    
	operation AmplitudeEstimator(input: Qubit[], target : Qubit, counting: Qubit[]): Unit is Ctl + Adj{
		X(target);
        //ApplyToEachCA(H,input);
        ApplyToEachCA(H,counting);
		for i in 0..(Length(counting)-1) {
			for j in 0..(PowI(2,i)-1) {
				Controlled GroverIteration([counting[i]], (input, target));
			}
		}

		Adjoint QFTLE(LittleEndian(counting));
		
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

    operation GroverIteration (input: Qubit[], target: Qubit) : Unit is Ctl + Adj{
        IfOneFlipPhase(input,target); //Apply the oracle
        DiffusionOperator(input, target); //Apply the diffusion operator
    }

    
}
