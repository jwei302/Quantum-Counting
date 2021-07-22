import qiskit;



def FlipPhaseIfAllZeros(circuit, register, target):
    circuit.x(register)
    cz_gate = ZGate().control(len(register))
    circuit.append(cz_gate,register+target)
    circuit.x(register)

def DiffusionOperator(circuit, register, target):
    circuit.h(register)
    FlipPhaseIfAllZeros(circuit,register,target)
    circuit.h(register)

def GroverIteration(circuit, input, target, oracle):
    oracle(circuit,input,target)
    DiffusionOperator(circuit,input,target)
