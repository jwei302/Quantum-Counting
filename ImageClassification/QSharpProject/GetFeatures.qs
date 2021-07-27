namespace QSharpExercises {
    
    open QSharpExercises;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
   
    operation FeaturesToQuantum(numTraining: Int, trainingFeatures: Double[][], testingFeatures: Double[]) : Unit{
        /// Prepare initial qubit state |B0>
        // Using MS instead of M because M is reserved for measurement
        //let MS = numTraining;
    //        let m = Ceiling(Lg(MS + 1));
    //        let N = Length(trainingFeatures);
    //        let n = Ceiling(Lg(N + 1));
    //
    //        use A = Qubit[m];
    //        ApplyToEach(H, A);
    //        use flag = Qubit();
    //        let MBitLength = Floor(Lg(MS)) + 1;
    //        use Mrep = Qubit[MBitLength];
    //        for i in 0..Length(IntAsBoolArray(MS, MBitLength)) {
    //            if val == true {
    //                X(Mrep[i]);
    //            }
    //        }
    //
    //_       QuantumComparator(A, Mrep, fla    //
    //        use MRegister = Qubit[m];
    //        use MOutput = Qubit();
    //        use Mrep = Qubit[m];
    //        use MFlags = Qubit[m + 2];
    //        use MFlag = Qubit();
    //
    //        let flagResult = One;
    //        let outputResult = One;
    //
    //        repeat {
    //            ApplyToEach(H, MRegister);
    //            for i in 0..Length(IntAsBoolArray(MS, m)) {
    //                if val == true {
    //                    X(Mrep[i]);
    //                }
    //            }
    //            ApplyToEach(X, MRegister);
    //            Controlled X(MRegister, MFlag);
    //            ApplyToEach(X, MRegister);
    //
    //            set flagResult = M(MFlag);
    //            set outputResult = M(MOutput);
    //
    //    _       QuantumComparator(MRegister, Mrep, MOutput, MFlags);
    //            
    //        } until flagResult == Zero and outputResult == Zero;
    //
    //        use NRegister = Qubit[n];
    //        use NOutput = Qubit();
    //        use Nrep = Qubit[n];
    //        use NFlags = Qubit[n + 2];
    //        use NFlag = Qubit();
    //
    //        set flagResult = One;
    //        set outputResult = One;
    //
    //        repeat {
    //            ApplyToEach(H, NRegister);
    //            for i in 0..Length(IntAsBoolArray(MS, m)) {
    //                if val == true {
    //                    X(Nrep[i]);
    //                }
    //            }
    //            ApplyToEach(X, NRegister);
    //            Controlled X(NRegister, NFlag);
    //            ApplyToEach(X, NRegister);
    //
    //            set flagResult = M(NFlag);
    //            set outputResult = M(NOutput);
    //
    //    _       QuantumComparator(NRegister, Nrep, NOutput, NFlags);
    //            
    //        } until flagResult == Zero and outputResult == Zero;
    //
    //        /// USE NEQR TO ENCODE DESIRED AMPLITUDES
    //        let imageVectors = CreateDouble2d(Length(trainingFeatures), Length(trainingFeatures[0]));
    //        for i in 0..Length(trainingFeatures) {
    //            for j in 0..Length(trainingFeatures[i]) {
    //                SetDouble2d(i , j, trainingFeatures[i][j], imageVectors);
    //            }
    //        }
    //        let NLength = Length(NRegister);
    //        use ancillas = Qubit[NLength];
    //        NEQR(NRegister, ancillas, NLength, NLength, r: Qubit, imageVectors);
    //        NEQR(MRegister, NRegister, NLength, Length(MRegister), r: Qubit, imageVectors);
    //_
    //    }
    //  
    }
}
