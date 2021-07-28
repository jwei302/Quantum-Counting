# Quantum Counting
This is the repo for the final project for the Quantum Software Development course @ MIT Beaver Works Summer Institute. The final project involved selecting an algorithm to implement and then conducting a practicality assessment on that algorithm. Our team, made up of Sarthak Dayal, Shuhul Mujoo, and Jeffrey Wei chose to implement the Quantum Counting Algorithm.

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

The paper describes the follow complexities for the applications Quantum Counting:

| Syntax      | Quantum Complexity |  Classical Complexity |
| ----------- | ----------- | ---------------------
| Decision      |        |
| Searching   | Text        |
## Our Approach
