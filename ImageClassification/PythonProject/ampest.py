import cv2
import os
import matplotlib.pyplot as plt
from math import *
import math
from ImageHandler import *
import numpy as np


from qiskit.aqua.algorithms import AmplitudeEstimation
from qiskit import *

ampQ = QuantumRegister(1)
circuit = QuantumCircuit(ampQ)

AmplitudeEstimation(num_eval_qubits=7, objective_qubits = [0])
