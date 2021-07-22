from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit import execute
from qiskit import Aer
import math
from Grovers import GroverIteration

# Helper QFT function
def qft(n, t):
    """Creates an n-qubit QFT circuit"""
    circuit = QuantumCircuit(t)
    def swap_registers(circuit, n):
        for qubit in range(n//2):
            circuit.swap(qubit, n-qubit-1)
        return circuit
    def qft_rotations(circuit, n):
        """Performs qft on the first n qubits in circuit (without swaps)"""
        if n == 0:
            return circuit
        n -= 1
        circuit.h(n)
        for qubit in range(n):
            circuit.cp(np.pi/2**(n-qubit), qubit, n)
        qft_rotations(circuit, n)
    
    qft_rotations(circuit, n)
    swap_registers(circuit, n)
    return circuit


def get_phase(oracle, num_qubits):
	counting_length = num_qubits+5
	
	counting = QuantumRegister(counting_length)
	input = QuantumRegister(num_qubits + 1)
	# target = QuantumRegister(1)
	out = ClassicalRegister()
	circuit = QuantumCircuit(counting, input)

	circuit.x(target)
	circuit.h(counting)
	circuit.h(input)

	grover_gate = GroverIteration.to_gate()
	cgrover_gate = grover_gate.control()

	IQFT = qft(num_qubits, counting_length).to_gate().inverse()

	for i in range(counting_length):
		for j in range(2**i):
			circuit.append(cgrover_gate, [i] + [*range(countingLength, num_qubits+countingLength)])
	
	circuit.append(IQFT, range(counting_length))

	# num = MeasureInteger(LittleEndian(counting))

	## TODO: Run the program on a simulator and parse number as an integer

	return num/2.0**counting_length * math.pi * 2.0;

def get_amplitude(phase):
	return math.sin(phase) ** 2.0


def get_count(phase, num_qubits):
	N = 2.0 ** num_qubits;
	return math.round((1.0 - math.sin(phase/2.0) ** 2) * N)
	