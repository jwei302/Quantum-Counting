from qiskit import *
from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit.providers.aer import AerSimulator
from qiskit import IBMQ
from qiskit.compiler import transpile
from time import perf_counter
from qiskit import Aer, transpile
from qiskit.circuit.library.standard_gates import *

def FlipPhaseIfAllZeros(circuit, register):
    circuit.x(register)
    cz_gate = ZGate().control(len(register)-1)
    circuit.append(cz_gate,register)
    circuit.x(register)

def DiffusionOperator(circuit, register):
    circuit.h(register)
    FlipPhaseIfAllZeros(circuit,register)
    circuit.h(register)

def GroverIteration(input, oracle, num_controlled_bits):
    qc = QuantumCircuit(len(input))
    oracle(qc,input)
    DiffusionOperator(qc,input)
    custom = qc.to_gate().control(num_controlled_bits)
    return qc


def UnitTest():
    qubits = QuantumRegister(3)
    measurement = ClassicalRegister(3)
    circuit = QuantumCircuit(qubits, measurement)
    FlipPhaseIfAllZeros(circuit,qubits)
    circuit.measure(qubits, measurement)
 
    simulator = Aer.get_backend('aer_simulator')
    simulation = execute(circuit, simulator, shots=1)
    result = simulation.result()

    counts = result.get_counts(circuit)
    for(measured_state, count) in counts.items():
        big_endian_state = measured_state[::-1]
        print(f"Measured {big_endian_state} {count} times.")


#UnitTest()