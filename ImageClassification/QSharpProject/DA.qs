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

        for ind in 0..10{
            let lengthY = 3;
            let lengthC = 3;
            let numY = PowI(2,lengthY);
            let numC = PowI(2,lengthC);
            use y = Qubit[lengthY];
            use c = Qubit[lengthC];
            mutable vals = [7,1,1,1,1,1,1,0];

            ApplyToEach(H,y);
        
            for i in 0..numY-1{
                    use extrasM = Qubit[Length(y)];
                    PrepBE(extrasM,i);
                    Xor(y,extrasM);
                    ApplyToEach(X,extrasM);
                    Controlled PrepBE(extrasM, (c, vals[i]));
                    ResetAll(extrasM);
            }
            
            DurrsAlgorithm(y, c);
            let yM = MeasureAndMessage("y", y, false);
            let cM = MeasureAndMessage("c", c, false);
            let yNum = BoolArrayAsIntBE(yM);
            let cNum = BoolArrayAsIntBE(cM);
            Message($"yNum: {yNum}");
            //Message($"cNum: {cNum}");
            ResetAll(y+c);
	    }
	    
       
    }
    operation DurrsAlgorithm(y : Qubit[], c : Qubit[]) : Unit{
        
    }
    
}
