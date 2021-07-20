namespace final_project_algorithm.counting {
	open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
	open Microsoft.Quantum.Arithmetic;
	open final_project_algorithm;


	operation GetPhase(oracle : (Qubit[], Qubit) => Unit is Ctl + Adj, numberOfQubits : Int): Double {
		use counting = Qubit[numberOfQubits];
		use input = Qubit[numberOfQubits];
		use target = Qubit();
		X(target);
		ApplyToEach(H,counting);
		ApplyToEach(H,input);
		

		for i in 0..(numberOfQubits-1) {
			for j in 0..(PowI(2,i)-1) {
				Controlled GroverIteration([counting[i]], (input, target, oracle));
			}
		}

		Adjoint QFT(LittleEndianAsBigEndian(LittleEndian(counting)));
		
		let num = MeasureInteger(LittleEndian(counting));
		ResetAll(counting + [target] + input);
		
		return IntAsDouble(num)/PowD(2.0,IntAsDouble(numberOfQubits)) * PI() * 2.0;
	}

	operation GetAmplitude(phase: Double): Double{
		return PowD(Sin(phase),2.0);
	}

	operation GetCount(phase: Double, numberOfQubits: Int): Int {
		return Round(PowD(Sin(phase/2.0),2.0)*PowD(2.0, IntAsDouble(numberOfQubits)));
	}
}