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
   
    operation FeaturesToQuantum(numTraining: Int, trainingFeatures: Double[], testingFeatures: Double[]) : Unit{
        // Using MS instead of M because M is reserved for measurement
        let MS = numTraining;
        let m = Ceiling(Lg(MS + 1));
        let N = Length(trainingFeatures);
        let n = Ceiling(Lg(N + 1));

        use A = Qubit[m];
        ApplyToEach(H, A);
        use flag = Qubit();
        let MBitLength = Floor(Lg(MS)) + 1;
        use Mrep = Qubit[MBitLength];
        for i in 0..Length(IntAsBoolArray(MS, MBitLength)) {
            if val == true {
                X(Mrep[i]);
            }
        }

_       QuantumComparator(A, Mrep, flag);

        

        use A_n = Qubit[m];
        ApplyToEach(H, A_n);
    }
    
}
