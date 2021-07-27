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
        for ind in 0..5{
            
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
                AreRegIntEqual(y,i,extrasY);
                Controlled PrepBE(extrasY, (c, vals[i]));
                Adjoint AreRegIntEqual(y,i,extrasY);
            }
            use targ = Qubit();
            use f = Qubit();
            use flags = Qubit[Length(c)+2];
            use m = Qubit[Length(c)];
            use k = Qubit[Length(y)];
            //PrepBE(m,3);
            X(targ);
            
            
            DurrsAlgorithm(y, c, k, m, flags, f, targ);
            //DumpRegister((),y);
            
            X(targ);
            //MandMInt("m",m);
            MandMInt("y",y);
            ResetAll(y+c+m+flags+[f]+[targ]+k);
	    }
	    
       
    }
    operation DurrsAlgorithm(y: Qubit[], c : Qubit[], k: Qubit[], m: Qubit[], r: Qubit[], f : Qubit, target : Qubit) : Unit{

        //for i in 0..Round(Sqrt(IntAsDouble(PowI(2,Length(y)))))-1{
    //            QuantumComparator(c, m, f, r);
    //            Controlled PhaseFlip([f],(y,target));
    //            Adjoint QuantumComparator(c, m, f, r);
    //            DiffusionOperator(y, target);
    //        }
       // QuantumComparator(c, m, f, r);
        Controlled Z(y,target);
        //Controlled Z([f], target);
        //Controlled PhaseFlip([f],(y,target));
        ApplyToEach(H,y);
        //DiffusionOperator(y, target);

        //If c is higher then m swap (m and c)
        //need to run this mutiple times
        //for i in 0..PowI(2,Length(y))-1{
    //            AreRegIntEqual(y,i,k);
    //            Controlled QuantumComparator(k, (c, m, f, r));
    //            Controlled SwapReg([f], (m,c));
    //            Controlled Adjoint QuantumComparator(k, (c, m, f, r));
    //            Adjoint AreRegIntEqual(y,i,k);
    //	    }
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
