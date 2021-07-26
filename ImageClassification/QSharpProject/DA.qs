namespace QSharpExercises {
    

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
   
   
    @Test("QuantumSimulator")
    operation TestDA () : Unit {
        let debug = true;

        for ind in 0..0{
            
            let lengthY = 3;
            let lengthC = 3;
            let numY = PowI(2,lengthY);
            let numC = PowI(2,lengthC);
            use y = Qubit[lengthY];
            use c = Qubit[lengthC];
            mutable vals = [0,1,2,3,4,5,6,7];

            use extrasY = Qubit[Length(y)];
            ApplyToEach(H,y);
            for i in 0..numY-1{
                    PrepBE(extrasY,i);
                    Xor(y,extrasY);
                    ApplyToEach(X,extrasY);
                    Controlled PrepBE(extrasY, (c, vals[i]));
                    ApplyToEach(X,extrasY);
                    Adjoint Xor(y,extrasY);
                    Adjoint PrepBE(extrasY,i);
            }


            use targ = Qubit();
            use f = Qubit();
            use flags = Qubit[Length(c)+2];
            use m = Qubit[Length(c)];
            X(targ);
            DurrsAlgorithm(y, c, m, flags, f, targ);
   
            //DumpRegister((),y);
            MandMInt("y",y);
           
            ResetAll(y+c+m+flags+[f]+[targ]);
	    }
	    
       
    }
    operation DurrsAlgorithm(y: Qubit[], c : Qubit[], m: Qubit[], r: Qubit[], f : Qubit, target : Qubit) : Unit{

		for i in 0..Round(Sqrt(IntAsDouble(PowI(2,Length(y)))))-1{
            QuantumComparator(c, m, f, r);
            CZ(f, target);
            DiffusionOperator(y, target);
        }
    }

    operation PhaseFlip(reg : Qubit[], target : Qubit):Unit is Ctl+Adj{
        use aux = Qubit();
        X(aux);
        SWAP(reg[0], aux);
        CZ(reg[0],target);
        SWAP(reg[0], aux);
        X(aux);

    }
    
}
