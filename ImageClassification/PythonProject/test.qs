namespace Qrng {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;

    operation SampleQuantumRandomNumberGenerator(test: Double[][]) : Result {
        use x = Qubit();
        Message(DoubleAsString(test[1][1]));
        if test[0][0] == 5.0 {
            X(x);
        }
        return M(x);
    }
}