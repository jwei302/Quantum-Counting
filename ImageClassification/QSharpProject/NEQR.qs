namespace QSharpExercises {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
   
    //THIS IS REALLLLLLLLLLLLLLLLLLLLLLLLY SLOW FIND A FASTER WAY TO DO THIS PLS

    @Test("QuantumSimulator")
    operation TestNEQR () : Unit {
        //If you want to see detailed output set this to true
        let debug = false;
        //Number of correct tries
        mutable numCorrect = 0;
        //Total tries
        mutable numTotal = 0;
        //Minimuim rate for success (should be 100 for non probabistic algorithms)
        let minRate = 100.0;
        //For all lengths of M from 1 to 5
        for lengthM in 1..3{
            for lengthN in 1..6{
                //Create two registers
                use m = Qubit[lengthM];
                use n = Qubit[lengthN];
                //Length of acutal data
                let numM = PowI(2,lengthM); //In real code this is smaller
                let numN = PowI(2,lengthN);
                //Qubit to store result
                use r = Qubit();
                //Array of amplitudes 
                mutable amps = CreateDouble2d(numM,numN);
                //Set all values with even indexes to 1
                for i in 0..numM-1{
                    for j in 0..numN-1{
                        if (i%2 == 0 and j%2 == 0){
                            set amps = SetDouble2d(i,j,1.0,amps);
						}
					}
			    }
                //If the length of m is larger than 1 then apply hadamard to all
                if (lengthM > 1){
                    ApplyToEach(H,m);
			    }
                //Hall to n 
                ApplyToEach(H, n);   
                //Run NEQR on it to encode the states into r
                NEQR(m,n,numM, numN,r,amps);
                //Measure everything
                let mM = MeasureAndMessage("|M>",m,debug);
                let nM = MeasureAndMessage("|N>",n,debug);
                let rM = MeasureAndMessage("|r>",[r],debug);
                //If the result is correct then add 1 to correct count
                if((BoolArrayAsIntBE(mM)%2 == 0 and BoolArrayAsIntBE(nM)%2 == 0) == rM[0]){
                    MessageAndDebug("Correct Amplitude for this state", debug);
                    set numCorrect += 1;
                }else{
                    MessageAndDebug("Incorrect Amplitude for this state", debug);
                }

                ResetAll(n+m+[r]);
                set numTotal += 1;
	        }
	    }
        //Rate of success as a percentage
        let rateOfSuccess = 100.0*IntAsDouble(numCorrect)/IntAsDouble(numTotal);
        Message($"Rate of success: {rateOfSuccess}%");
        if (rateOfSuccess < minRate){
            fail "Rate of success was too low";
        }
    }




    operation NEQR(m: Qubit[], n: Qubit[], numM: Int, numN: Int, r: Qubit, amps: Double2d): Unit{
        mutable iter = 0..0;
        if(Length(m) > 1){
            //For real code make 1..numM
            set iter = 0..numM-1;
        }
        //Go through all is and js
        for i in iter{
            for j in 0..numN-1{
                //Make quantum versions of i and j
                use extrasM = Qubit[Length(m)];
                use extrasN = Qubit[Length(n)];
                AreRegIntEqual(m, i, extrasM);
                AreRegIntEqual(n, j, extrasN);
                //If m == i and n == i then rot(r)
                Controlled rot (extrasM+extrasN,(GetDouble2d(i,j,amps),r));
                Adjoint AreRegIntEqual(n, j, extrasN);
                Adjoint AreRegIntEqual(m, i, extrasM);
            }
		}
        
    }
    //Rotate r so that the amplitude is encoded into the state
    operation rot(amp: Double, qb: Qubit):Unit is Ctl + Adj{
        Ry(2.0*ArcSin(Sqrt(amp)), qb);
    }

  
}
