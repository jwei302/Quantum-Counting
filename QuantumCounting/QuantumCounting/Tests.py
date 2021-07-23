from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit import execute
from qiskit import Aer
import QuantumCounting
import numpy as np

def toffoli_chain(circuit, register, output, function):
    length = len(register)

    if length == 1:
        circuit.cz(register, output)

    else:
        ancilla = QuantumRegister(length-1, "ancilla")
        if not circuit.has_register(ancilla):
            circuit.add_register(ancilla)

        circuit.ccx(register[0], register[1], ancilla[0])
        
        if length > 2:
            for i in range(2, length):
                circuit.ccx(register[i], ancilla[i-2], ancilla[i-1])

        function(ancilla[-1], output)

        if length > 2:
            for i in range(length-1, 1, -1):
                circuit.ccx(register[i], ancilla[i-2], ancilla[i-1])

        circuit.x(register)

def oracle1(circuit, register, output):
    circuit.x(register)
    
    toffoli_chain(circuit, register, output, circuit.cz)

    circuit.x(register)

def oracle2(circuit, register, output):
    circuit.h(register[2,3])
    circuit.ccx(register[0],register[1],register[2])
    circuit.h(register[2])
    circuit.x(register[2])
    circuit.ccx(register[0],register[2],register[3])
    circuit.x(register[2])
    circuit.h(register[3])
    circuit.x(register[1,3])
    circuit.h(register[2])
    circuit.mct(register[0,1,3],register[2])
    circuit.x(register[1,3])
    circuit.h(register[2])
    

def num_sols(oracle, inputLength):
    num_sols = 0
    
    for i in range(2**inputLength):
        register = QuantumRegister(inputLength)
        output = QuantumRegister(1)
        circuit = QuantumCircuit(register, output)
        circuit.h(output)
        arr = np.bit_repr(i)

        for j in range(len(arr)):
            if arr[j]:
                circuit.x(input[j])
        oracle(input, output)
        circuit.h(output)
        simulator = Aer.get_backend('aer_simulator')
        simulation = execute(circuit, simulator, shots=1)
        result = simulation.result()
        counts = result.get_counts(circuit)

        for (measured_state, count) in counts.items():

            if measured_state == '1':
                num_sols+=1
    return num_sols


    return num_sols
def pretest(oracle, inputLength):
    phase = get_phase(oracle, inputLength)
    amplitude = get_amplitude(phase)
    count = get_count(phase, inputLength)
    real_count = num_sols(output, inputLength)
    return count == real_count
def run_unit_tests():
    maxLength = 5
    num_correct, total = 0, 0
    for inputLength in range(2, maxLength+1):
        for oracle in [oracle1, oracle2]:
            if pretest(oracle, inputLength):
                num_correct += 1
            total += 1
    if num_correct/total >= 0.9:
        print("Passed Successfully")
    else:
        print("Unsuccessful")

if __name__ == '__main__':
    run_unit_tests()