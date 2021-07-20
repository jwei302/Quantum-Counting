namespace final_project_algorithm.counting {
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Arithmetic;
	open final_project_algorithm;

	operation GetPhase(oracle : (Qubit[], Qubit) => Unit is Ctl + Adj, numberOfQubits : Int): Double {
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

		ResetAll(countingQubits + searchingQubits + [ancilla]);
		let num = MeasureInteger(BigEndianAsLittleEndian(BigEndian(countingQubits)));
		return IntAsDouble(num)/PowD(2.0,IntAsDouble(numberOfQubits));
	}

	operation GetAmplitude(phase: Double): Double{
		return PowD(Sin(phase),2.0);
	}

	operation GetCount(phase: Double, numberOfQubits: Int): Int {
		return Round(PowD(Sin(phase)/2.0,2.0)*IntAsDouble(numberOfQubits));
	}
}