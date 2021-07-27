import numpy as np
import math

# importing Qiskit
import qiskit
from qiskit import QuantumCircuit, transpile, assemble, Aer
from time import perf_counter
from qiskit import IBMQ
from qiskit.providers.aer import AerSimulator
from qiskit.test.mock import FakeToronto
from qiskit import execute


def example_grover_iteration():
    # Do circuit
    qc = QuantumCircuit(4)
    # Oracle
    qc.h([2,3])
    qc.ccx(0,1,2)
    qc.h(2)
    qc.x(2)
    qc.ccx(0,2,3)
    qc.x(2)
    qc.h(3)
    qc.x([1,3])
    qc.h(2)
    qc.mct([0,1,3],2)
    qc.x([1,3])
    qc.h(2)
    # Diffuser
    qc.h(range(3))
    qc.x(range(3))
    qc.z(3)
    qc.mct([0,1,2],3)
    qc.x(range(3))
    qc.h(range(3))
    qc.z(3)
    return qc



# Create controlled-Grover
grit = example_grover_iteration().to_gate()
grit.label = "Grover"
cgrit = grit.control()

def qft(n):
    """Creates an n-qubit QFT circuit"""
    circuit = QuantumCircuit(5)
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

qft_dagger = qft(5).to_gate().inverse()
qft_dagger.label = "QFT†"

# Create QuantumCircuit
t = 5   # no. of counting qubits
n = 4   # no. of searching qubits
start = perf_counter()
qc = QuantumCircuit(n+t, t) # Circuit with n+t qubits and t classical bits

# Initialize all qubits to |+>
for qubit in range(t+n):
    qc.h(qubit)

# Begin controlled Grover iterations
iterations = 1
for qubit in range(t):
    for i in range(iterations):
        qc.append(cgrit, [qubit] + [*range(t, n+t)])
    iterations *= 2
    
# Do inverse QFT on counting qubits
qc.append(qft_dagger, range(t))

# Measure counting qubits
qc.measure(range(t), range(t))
end = perf_counter()

active_qubits = {}

for op in qc.data:
    if op[0].name != "barrier" and op[0].name != "snapshot":
        for qubit in op[1]:
            active_qubits[qubit.index] = True
# resource estimation and practicality assessment

print(f"Circuit construction took {end-start} sec.")
print(f"Width: {len(active_qubits)}")
print(f"Depth: {qc.depth()}")
print(f"Gate count: {qc.count_ops()}")
# Execute and see results




backend = FakeToronto()
start = perf_counter()
circuit = transpile(qc, backend=backend, optimization_level=1)
end = perf_counter()
print(f"Compiling and Optimization: {end - start}")
start = perf_counter()
run = execute(circuit, backend, shots=1024)
end = perf_counter()
print(f"Simulation Time: {end-start}")
result = run.result()
counts = result.get_counts()


#simulator = Aer.get_backend('aer_simulator')
#start = perf_counter()
#simulation = execute(qc, simulator, shots=1024)
#end = perf_counter()
#print(f"Simulation time: {end-start}")
#result = simulation.result()
#counts = result.get_counts(qc)

for(measured_state, count) in counts.items():
    big_endian_state = measured_state[::-1]
    print(f"Measured {big_endian_state} {count} times.")

measured_str = max(counts, key=counts.get)

measured_int = int(measured_str,2)

def calculate_M(measured_int, t, n):
    """For Processing Output of Quantum Counting"""
    # Calculate No. of Solutions
    theta = (measured_int/(2**t))*math.pi*2
    N = 2**n
    M = N * (math.sin(theta/2)**2)
    numsols = round(N-M)
    print(f"No. of Solultions = {numsols}")

calculate_M(measured_int, t, n)
