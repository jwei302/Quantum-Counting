namespace Quantum.QSharpTestProject {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    
    @Test("QuantumSimulator")
    operation counting_unit_test () : Unit {

        Message("Test passed.");
    }
}
