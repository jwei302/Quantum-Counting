from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit import execute
from qiskit import Aer
import math

def get_phase(oracle, num_qubits):
	countingLength = num_qubits+5
	circuit = QuantumCircuit()
	counting = QuantumRegister(num_qubits)
	input = QuantumRegister(num_qubits)
	target = QuantumRegister(1)
	circuit.x(target)
	circuit.h(counting)
	circuit.h(input)

	for i in range(0,countingLength-1):
		for j in range(0, (2**i-1)):
			# Controlled GroverIteration([counting[i]], (input, target, oracle));
			pass

	# Adjoint QFTLE(LittleEndian(counting));
	# num = MeasureInteger(LittleEndian(counting))

	## TODO: Run the program on a simulator and parse number as an integer

	return num/2.0**countingLength * math.pi * 2.0;

def GetAmplitude(phase):
	return math.sin(phase)**2.0


def GetCount(phase, num_qubits):
	N = 2.0 ** num_qubits;
	return math.round((1.0 - math.sin(phase/2.0) ** 2) * N)
	