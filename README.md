# [Quantum Counting](https://www.youtube.com/watch?v=RtU7ojCMDsM&list=PLf9oKp0RkBIyPM41TOtJB2AD7QestBKQa)
![MIT License](https://img.shields.io/static/v1?label=license&message=mit&color=red&style=for-the-badge&link=https://github.com/jwei302/Quantum-Counting/blob/main/LICENSE)
![Built in 2 weeks](https://img.shields.io/badge/built%20in-2%20weeks-black?style=for-the-badge)
![Click for video on YouTube](https://img.shields.io/badge/Project%20Video-YouTube-red?style=for-the-badge&link=https://youtu.be/RtU7ojCMDsM?list=PLf9oKp0RkBIyPM41TOtJB2AD7QestBKQa&link=https://youtu.be/RtU7ojCMDsM?list=PLf9oKp0RkBIyPM41TOtJB2AD7QestBKQa)

This is the repo for the final project for the Quantum Software Development course @ MIT Beaver Works Summer Institute. The final project involved selecting an algorithm to implement and then conducting a practicality assessment on that algorithm. Our team, made up of [Sarthak Dayal](https://github.com/sarthak-dayal), [Shuhul Mujoo](https://github.com/shuhul), and [Jeffrey Wei](https://github.com/jwei302) chose to implement the Quantum Counting Algorithm.

![image](https://user-images.githubusercontent.com/63827830/127393159-4a479909-a144-4fab-aa8a-ab0143dc4dcf.png)


## The Problem
Given a blackbox function `f` that tells us whether or not a given input is a solution to the function, what is the fastest way to calculate the number of solutions to `f`? In classical computing, this would involve iterating over the input space and checking every input to check which ones are a solution. Then, by counting the number of these, we can get the total number of solutions to `f`. We can do much better with the tools of Quantum Computing...at least in theory.

 We set out to implement a paper describing this algorithm and determine it's practicality using resource estimation techniques. This allows us to understand the current state of Quantum Hardware and the practicality of many other algorithms that rely on Quantum Counting as a subroutine.

### Applications
There are many potential applications of solving this problem including:
- Reducing the search spaces
- Checking whether or not a function has a solution
- [Grover's search algorithm](https://en.wikipedia.org/wiki/Grover%27s_algorithm) which in turn forms the basis for many other quantum algorithms
- Determining the existence of [Hamiltonian Cycles](https://en.wikipedia.org/wiki/Hamiltonian_path). 

We also attempted to implement a version of the Quantum K-Nearest-Neighbors algorithm, which relies on Amplitude Estimation (whose Quantum parts are the same as Quantum Counting). You can learn more about that [here](https://github.com/jwei302/Quantum-K-Nearest-Neighbors/)!

## The Paper
The paper we used was:

Brassard, G., Hoyer, P., Mosca, M. & Tapp, A. Quantum Amplitude Amplification and Estimation. You can access the paper [here](https://arxiv.org/abs/quant-ph/0005055).

This paper describes the complete math and theory behind the implementation of quantum counting. It uses phase estimation with Grover's iteration as the unitary operator. This complete circuit allows us to estimate the probability that a picked solution will be correct after some clever math. Finally, we multiply this probability by 2^n, where n is the number of inputs to the blackbox function `f`, because this will give us a good estimate for the total number of solutions. While this algorithm is probabilistic, the chance of failing is very low. 

The paper describes the follow complexities for the applications Quantum Counting, where t is the number of counting Qubits and N is the total number of possible inputs:

| Problem      | Quantum Complexity |  Classical Complexity |
| ----------- | ----------- | ---------------------
| Decision      |   Θ(√(N/(t + 1)))      | Θ(N/(t + 1))
| Searching   | Θ(√(N/(t + 1)))         | Θ(N/(t + 1))
| Counting with error √t | Θ(√N) | N/A
| Exact counting | Θ(√((t + 1)(N − t + 1)) | Θ(N)

## Our Approach
We implemented the algorithm in Q# first to see if it was functional. Then we ported it over to Qiskit to assess its practicality because Qiskit had a more robust resource estimator.

### Q# Implementation
We started by parsing through the paper and taking notes, as well as searching for circuit diagrams. We found a few good circuit diagrams and implemented them in Q#. We faced issues with Unit Testing in Q# because we had to write a lot of individual tests to make sure that the algorithm worked for every possible Oracle. In the end, the Q# implementation succeeded for all oracles we could implemtn and we moved on to porting the code over to Qiskit.

### Qiskit Implementation
We translated the code to Qiskit and wrote new unit tests. We had trouble with doing controlled operations due to Qiskit's syntax and working with the Qiskit library's different measurement methods. Finally, we finished the code and moved on to analyzing the algorithm's resource requirements.

## Practicality Analysis
After creating implementations in Q# and Qiskit, we analysed the practicality and resource usage of the algorithm. The results proved to use that the algorithm is impractical for current Quantum computers given the high error rate. Below is a summary of our results.

![Quantum Counting Presentation](https://user-images.githubusercontent.com/63827830/128811689-9b99f4fc-7945-4a96-8056-d149b75997d2.png)

Here, t is the number of counting qubits and n is the number of measuring qubits. These two numbers are important metrics for the algorithm to work. The AER Backend was errorless and yet produced one wrong result due to the number of t qubits being too low. This proved to us that the accuracy increased with an increase in the number of counting qubits. Additionally, we can see that the other backends rarely produced a correct result, thereby showing us that Quantum Counting is impractical today.

## Resources
- [Quantum Counting in the Qiskit textbook](https://qiskit.org/textbook/ch-algorithms/quantum-counting.html)
- [Original Paper](https://arxiv.org/abs/quant-ph/0005055)
- [Wikipedia](https://en.wikipedia.org/wiki/Quantum_counting_algorithm)
