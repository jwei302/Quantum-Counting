from qiskit import QuantumCircuit, ClassicalRegister, QuantumRegister
from qiskit import execute
from qiskit import Aer


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
    

def pretest(circuit, register, output, oracle):
    phase = GET_PHASE(circuit, register, oracle)
def run_unit_tests():
    maxLength = 5
    for inputLength in range(2, maxLength+1):
        for oracle in [oracle1, oracle2]:
            register = QuantumRegister(inputLength, "register")
            output = QuantumRegister(1, "output")
            circuit = QuantumCircuit(register, output)
            pretest(circuit, register, output, oracle)

if __name__ == '__main__':
    run_unit_tests()