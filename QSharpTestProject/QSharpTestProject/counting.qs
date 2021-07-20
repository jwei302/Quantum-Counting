namespace final_project_algorithm.counting {
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Arithmetic;
	open QSharpTestProject;

	operation Counting (oracle : (Qubit[], Qubit) => Unit, numberOfQubits : Int): Int {
		let n = numberOfQubits;
		let t = n;
		use ancilla = Qubit();

		use countingQubits = Qubit[t];
		use searchingQubits = Qubit[n];

		ApplyToEach(H, countingQubits);
		ApplyToEach(H, searchingQubits);

		for i in 0..t-1 {
			for j in 1..2^i {
				Controlled GroversAlgorithm([countingQubits[i]], (searchingQubits, ancilla, oracle));
			}
		}

		Adjoint QFT(BigEndian(countingQubits));
		return MeasureInteger(BigEndianAsLittleEndian(BigEndian(countingQubits)));
	}
}