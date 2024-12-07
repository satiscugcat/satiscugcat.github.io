---
layout: post
title: "Winter School on Formal Vertification and Program Synthesis, IIT Delhi"
---
# Table of Contents #
1. [**Day 1**](#day1)
   1. [**Talk by Prof Sanjam Garg on his Research Journey**](#sanjam)
   2. [**Lecture by Subodh Sharma on Symbolic Execution: Fundamentals and Applications**](#symbolic)
2. [**Day 2**](#day2)
   1. [**Talk by Ravindra Metta on Formal Verification and Synthesis at TCS Research**](#tcs)
   2. [**Lecture+Tutorial by Aalok Thakkar on Introduction to Enumerative Synthesis**](#as)
   3. [**Lecture by Kumar Madhukar on Neural Network Verification Part I**](#dnn)
3. [**Day 3**](#day3)
   1. [**Lecture by Kumar Madhukar on Neural Network Verification Part II**](#dnn2)
   2. [**Talk by Silvia Ghilezan Proofs as Programming Paradigms: From Logic to AI**](#lambda)
   3. [**Tutorial by Priyanka Golia on SAT Solvers**](#sat)
4. [**Day 4**](#day4)
   1. [**Lecture by Priyanka Golia on SAT Solving Algorithms**](#sat2)
   2. [**A Final Interaction**](#end)

# Day 1 <a name="day1"></a> #

## Talk by Prof Sanjam Garg on his Research Journey <a name="sanjam"></a> ##

We began the day with a presentation by [Prof. Sanjam Garg](https://people.eecs.berkeley.edu/~sanjamg/) of UC Berkeley and alumnus of IITD, about his learnings as a researcher, titled **"Your Research Career"**. (His presentation largely drew fron ["You and Your Research" by Richard Hamming](https://www.cs.virginia.edu/~robins/YouAndYourResearch.html)). 

For him, the main motivating question for cryptography has been, "What is Possible?", how can you encrypt, how can you work with encrypted data, etc. Success over the past two decades has included FHE, Obfuscation, etc. However, following success, it becomes necessary to move into newer directions (quantum computers, real world needs, practical efficiency), constantly asking, "What is Possible?". Now, how does one make progress in answering that question? For him, the most important question a researcher should ask themselves is "What are the most important problems in my field?". At the end of the day, a researcher is responsible for their own career, their advisor is just their advisor. The question of what an important problem is thus something every researcher should ask for themselves, considering various variable factors such as location, timespan, etc.

He emphasises that it is important not to fear. Fear may prevent a reseacher to take on important problems, expecting to waste time, however, most important problems see significant progress in a decade. It's thus important to have courage to work consistently on things that one thinks are difficult and important. He backed his words by showing a lisit of open problems he had jotted down a decage ago. Open problems to which no approach existed at the time which he wrote them. However, most of them turned out to either be solved or have significant progress in the next decade, winning best paper awards in STOC, EUROCRYPT, and CRYPTO. Once a researcher has chosen a problem, he feels that it is important that they take that problem as something to guide them. It is important to find smaller goals to guide oneself to that bigger problem, working persistently in small (publishable steps), working on new techniques and seizing the opportunity when those ideas mature.

He emphasises that it is very important to **communicate technical ideas clearly**. If this is not done, then any results obtained from one's work are prone to be forgotten, giving way for a future researcher to work on the same problem and publish their work again, all because they couldn't understand your work. Communication also allows one to get feedback from other people, letting one get gain new perspectives on the topic. Talking to people a lot is in general something that helps, not only in solving problems, but also in finding opportunities for further exploration. While doing good research is important, it's also good to have fun along the way.

Summary on how to research well
- What is the most important problem of my field?
- Why don't I work on it? If someone will solve it in the next decade?
- Can I make the tiniest progress on this problem?
- Can I expand it to an interesting paper?
- If not, revisit anytime you find a new technique to attack the problem
- The more you work, the bigger the compounding effect

##  Lecture by Subodh Sharma on Symbolic Execution: Fundamentals and Applications <a name="symbolic"></a> ##

### How can we test a program?

**The more traditional approach : Concrete Execution** - Clasically, developers may try to ensure the correctness of their code by writing test cases, where different inputs and expected outputs of a program are jotted down, and the program is run on those inputs and the outputs are checked against those expected outputs. The program passes the tests if all the outputs match all the corresponding expected outputs. However, this approach is not appealing for many reasons. For one, passing test cases does not provide a *guarantee* that the program will work for *all* possible inputs. Even with a simple factorial program, a programmer may forget to account for the cases of negative input or for the case of a large input (which may cause integer overflow). What we would like to do is know *for sure* that all bugs in the program have been caught. How can we go about this?

**A systematic way to test : Symbolic Execution** - In the approach proposed in a paper by JC King in 1976 called **Symbolic Execution and Program Testing**, we do not actually *execute* the program. What we do is to assign the unknown/unfixed variables of the program with *symbols*, which are then traced through the different control flow pathways of the program. In each of these paths, the execution keeps track of the different properties that these symbolic variables have, and then finally checks for a certain criterion at the end of the program. Thus, symbolic execution is useful for guaranteeing state invariant properties, which must hold across all initial states and given inputs (since the symbols and the constraints generated never depend on any *concrete* value, as no actual execution is done). The symbolic execution generates different control flow pathways according to different possible executions given the variability of the symbols. The symbolic execution then generates different constraints for the pathways, called path constraints. These path constraints take the form of first order logic formulas involving the symbols and variables in the program. Let us look at an example.

``` C
int factorial(int n){
	if (n < 0) {
		perr("Error: Negative Input");
		return -1;
	}
	int result = 1;
	for(int i = 1; i<n; i++){
		result *= i;
	}
	return result;
}


int main(){
	int n;
	make_symbolic(&n, sizeof(n), "n");
	int result = factorial(n);
	assert(result >=1 || n<0);
	return result;
}
```

The **Symbolic Execution Engine (SEE)** assigns the symbol $$n_0$$ to the variable *n* (instead of assigning a specific value like concrete execution). On reaching the first conditional, it branches the execution into two paths. In the path  where the conditional is satisfied, it generates the constraint $$n_0 < 0$$ (since this is the condition for the execution to happen) and then exits the function. In the other path, it generates the constraint $$n_0 \ge 0$$. With the assignment and the for loop, the SEE is also able to generate the constraint $$result \ge 1$$. Upon exiting the factorial, in both paths, the SEE then conjuncts the constraint generated on the path with the **negation** of the statement in the assertion (which is the state invariant for the program, since we want the assert to pass regardless of the input or initial state). In the first case, this finally generates the constraint $$n_0 < 0 \land \neg(result \ge 1 \lor n_0 < 1)$$ while it generates the constraint $$n_0 \ge 0 \land result \ge 1 \land \neg(result \ge 1 \lor n_0 < 1)$$. In either case, it is obvious that the final result can never be true, thus the assertion must always pass. Thus we have used symbolic execution to prove the correctness of the program.

Notice what we have done, however. After we negate the state invariant and obtain a first order logic formula over boolean values, we are interested in either showing a case where it turns out to be true (ie. the state invariant doesn't hold for some input or initial state) or showing that it is false regardless of the values of the booleans (ie. the state invariant always holds). Hwever, is nothing but the [Boolean Satisfiability Problem](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem)!!! Thus, we have used Symbolic Execution to reduce the problem of program verification into the well studied SAT problem, for which we can use any existing SAT solver. Not only do we get to know if the program has errors, we also get to know what input would cause an error in the program. This is something that deserves a moment of appreciation. Let us now express these notions a little formally.

For a given program, let $$\sigma$$ represent the symbolic store (as opposed to the usual store a program has) it is a map from the set of variables $$V$$, to the set of symbolic expressions $$SymExp$$. Let $$\mu$$ represent a first order boolean logic formula, where the booleans may contain expressions which may contain both symbols and variables. Let $$pc$$ represent the program counter. The state of the Symbolic Execution Engine can thus be represented as the thruple:

$$\Sigma = (pc, \sigma, \pi)$$

The points of interest lie whenever the program assigns a value or branches. In the case of the assignment, $$x:=e$$ results in the symbolic store getting updated as $$\sigma[x \rightarrow e_s]$$, where $$e_s$$ is the equivalent symbolic expression under $$\sigma$$. In the case of a branching statement of the form   if $$e$$ then $$s_t$$ else $$s_e$$, the SEE maintains the constraint $$\pi \land e_s$$ for the then branch and the constraint $$\pi \land \neg e_s$$ for the else branch.

A state invariant for a program holds if and only if, at the end of every control flow pathway, the boolean formula resulting from $$\pi \land \neg S$$ is **unsatisfiable** (where $$\pi$$ corresponds to the state at the end of the CFP and $$S$$ is the state invariant expressed as a boolean formula). 

### Symbolic Execution in the here and now

The above sections up the basics of Symbolic Execution. In modern applications, it is worth noting that instead of SAT solvers, SMT solvers like Z3, CVC4, and STP are used allowing verification for a wider range of programs (although, there are still troubles with multiplicative expressions and transcendental functions, which are hard to reason with using an automated solver). Aside from that, there are multiple challenges in SEE implementations like

- Memory: How do you handle pointers, arrays, and complex data structures?
- Environment: How do SEEs interact with side effecting system calls or libraries?
- Path Explosion: How to handle programs with a large number of control flow paths? How to handle loops?

One of the key ideas that helps with the last problem is mixing symbolic execution with concrete execution. This popular approach is known as dynamic symbolic execution (or combolic execution), where concrete executions are used to dictate the control flow paths that the symbolic execution would investigate. While this leads to a lack of soundness, the way one implements the SEE can still lead to a large range of effectiveness, allowing one to cover a good majority of cases in practical use. Some such design decisions that can go into the making of an SEE are -
- Control Flow Graph Traversal - Aside from DFS and BFS, one may also traverse the control flow graph by assigning different weights to the different vertices in the graph based on their length from the source or the number of outgoing edges (ie. the number of branching outcomes) at that point and prioritise traversal based on that.
- Online vs Offline executors - One may use an online executors to traverse multiple CFPs in parallel, or an offline executor for a single path at a time
- Adding features for different language constructs - Professor Subodh had mentioned working on SKLEE, a modification of KLEE that allowed support for the kinds of functions used in Solidity to write immutable etherium contracts. Such things can be done for other language constructs.
- Modelling Memory - One way to model memory is Fully Symbolic Memory, where every pointer, every element of an array is considered a symbolic variable. This leads to state forking, where whenever an array is considered with an operation on a variable index, the SEE must consider the possible executions at every possible array location. An alternate approach is using Heap Analysis to figure things out using the shape of the memory in the heap. However, this is an active research problem.

If all of this interests you, you may try your hands on [KLEE](https://klee-se.org/), a symbolic execution engine using the clang LLVM. It is excessively documented, and is easy to install using Docker (and other methods). Play around! You can try the following problems that Professor Subodh gave us during the talk if you wish to test your understanding.

**Exercises**
- Write a bubble sort program in C and test the postcondition of the sort using KLEE
- Verify the correctness of Binary Search w.r.t. edge cases $$key < arr[0]$$ or $$key > arr[sz-1]$$.

That is all for Symbolic Execution!

# Day 2 <a name="day2"></a>

## Talk by Ravindra Metta on Formal Verification and Synthesis at TCS Research <a name ="tcs"></a>

### Introduction

We started the day with a talk by [Ravindra Metta](https://www.linkedin.com/in/ravindra-metta-00b2b75/) on his experience with formal methods at TCS research.

Nowadays, while there are many kinds of research branches at TCS research, for AI, Smart Cities, Data Analysis, for him the beginnings of TCS research has always been with program analysis and code verification. He says that in the normal industrial picture, there are only a few places where formal specifications for how programs should behave are even *available*. Most stuff is just chaotic and glued together with API tests, user feedback, other testing scripts, and more. However, when working with critical technologies, like biomedical devices, nuclear fission reactors, or even if you want to ensure that your code does work, he feels the only way forward is by using formal specification and correctness. 

The ultimate goal with formal verification is Autonomous Software Engineering. At TCS Research, people are interested in using formal tools like bounded model checking and PROTON (a termination verifier), along with generative AI techniques to build programs. The formal verification tools builds constraints for the programs to follow, through proofs and tests, for not only fixing buggy programs and generating tests, but also synthesising programs. While, purely logical methods *can* be used for these purposes, for computationally hard problems, they have found success in using genrative AI to guess solutions. The output of this formal verifier can then be used to provide feedback to the generative AI to modify its output.

Another thing they're interested is in partial verification. In the real world there are many applications where code interacts with external code which it has no access to. Thus, TCS research is working on partial verification tools, which try to generate the *maximal* set of constraints that can be applicable to the partial system. There's also work in synthesising bank database queries according to specifications, work in synthesising oracles and tests for insurance policies especially in the context of generating different insurance policies according to the different laws in different regions, and even in ensuring correctness in automative, security, and IoT industries. One of the key takeaways from all this to him, is that formal verification is something that is applicable in many places everywhere. There are many successful industrial applications to be built and many top tier papers and patents to be made.

### A Deeper Look
After giving us a brief summary, he provided us a more detailed walkthrough over the kind of formal verification work TCS Research has been doing across different fields.
- **Requirement Engineering** - Companies tend to provide different written specifications for how code should work, the idea of Requirement Engineering is to be able to automatically convert these written specifications using Natural Language Processors into automata over which formal verification tools could operate. Thus automating the task of generating the test cases according to written specifications.
- **Software Engineering** - In software engineering applications, there's an exponential blow up of possible execution paths. Fo this, the ISO standard (ISO26262) requires MCDC testing for certain critical software. Now, manually writing the tests for MCDC thing is difficult, so using Pushdown Automata, Monotone Flow Analysis, and SAT + SMT solvers, people at TCS Research have developed a tool called AutoGen that has been used to find bugs in a wide variety of code.
- **Hardware Engineering** - They have been very successful at bug hunting in hardware chips using automated tools.
- **Systems Engineering** - In timing sensitive applications, it is of high interest to analyse things such as race conditions and worst case execution times (like the airbag in a car for example). Using Timed Automata, and Hybrid Model Checking, they have developed tool flows that are able to not only generate tighter benchmarks, but also generate actual traces for the runs with worst case execution time.
- **Business Engineering** - An automotive company once gave a problem to TCS research. The problem was that they had different constraints of budget and resources, but figuring out what they could build from this. To solve this resource allocation problem, TCS Research built a solution that converted all these constraints to a boolean logic formula (in Conjunctive Normal Form), and then used a #SAT solver to figure out the number of possible solutions to those resource constraints.
- **Production Engineering** - When giving out cars for test drives, one needs to ask how to allocate those that car for what different tests. Many constraints come up because of this. Tests cannot happen at the same time, must end before due dates, some tests must be done, the tests should start as soon as the car gets manufactured, etc. Plugging these solvers into an SMT solver that also optimises for factors such as minimising the number of vehicles used, has led to upto tens of millions of dollars when this solution was used by a certain company, outperforming their previous solution on both cost and time.

## Lecture+Tutorial by Aalok Thakkar on Introduction to Enumerative Synthesis <a name="as"></a>

A lecture was given by [Aalok Thakkar](https://aalok-thakkar.github.io/) introducing us to the problem of program synthesis along with the solution of enumerative synthesis. He starts with a notion of thinking of program synthesis that converts dreams into programs (as introduced in [this paper](https://ieeexplore.ieee.org/document/1702636) from 1979). Here, dreams are formal specifications representing user intent, and the job of program synthesis is to generate a program that follows this specification (which can be verified by a verification algorithm). One way to describe this specification is by using mathematical specification which while precise, can be complicated. The other is natural language, which while being easy to follow, is much too vague. The area that Aalok is interested in is using input-output examples. Users specify different pairs of inputs and outputs (which can serve both as examples of correct and incorrect behaviour). The input-output problem thus becomes the problem of searching a program that satisfies those input output examples, which also makes it a supervised learning problem.

This raises a challenge however. How do we ensure that our test cases completely capture the behaviour of our program? And how do we ensure that we do not overfit to the examples?

The rest of the session was spent on a tutorial where we tried a problem like this hand on. The problem was, given a set of boolean variables, and given the input-output behaviour of a first order logic formula *f* that returns either a 1 or a 0 for some cases of the input variables, how do you construct the formula for *f* in such a manner that it satisfies all the test cases while minimising the number of logical connectives (OR, NOT, AND) used in the formula? (Try this problem for yourself!) The algorithm showcased in the tutorial was one where first all formulae of size 0 were tried, then all formulae of size 1, then all of size 2, and so on until a valid formula was found (here size is simply the number of logical connectives). This is the approach for enumerative synthesis, and the core idea is to looking into how we could further optimise these kinds of algorithms.

## Lecture by Kumar Madhukar on Neural Network Verification Part I<a name="dnn"></a>

In this talk by [Kumar Madhukar](https://kumarmadhukar.github.io/) of IIT Delhi, to be continued in the following day, we looked at the problem of Deep Neural Network Verification. In traditional program verification, given a program of a certain form we want to be able to prove a ceetain property about it mathematically, or give a counterexample if it does not work. 

```C
int fac(int c){
	int y = 1;
	int z = 0;
	while(z!=x){
		z = z+1;
		y=y*z;
	}
	return y;
}
```
For example, for this program, a simple loop invariant argument holds to prove that if *(x > 0) then fac(x) = x!*, thus we can reason about the factorial program as a mathematical object.

However, how do we this for neural networks? Let us consider the task of recognising digits from images. There is no simple formal rule that can distinguish 2 from 7 in human writing styles, since human writing styles do not follow any easy to understand formal set of rules. This is why we use neural networks! But then without a functional notion of correctness, how can we verify that the neural network works? This problem came up once when researchers were working on **aircraft collision avoidance systems**. At first, they used to use lookup tables with different cases for countless scenarios, but due to the amount of memory of the operations involved, it became appealing to try to use trained neural networks to solve the same problem. But then, how do we *guarantee* that **airplanes do not crash?**.

So, considering this is a serious problem, what are some properties of Deep Neural Networks (DNNs) that we can think about? Some are
- **Safety** - Our network shouldn't do anything undesirable.
- **Privacy** - The network shouldn't *memorise* the training examples.
- **Robustness** - Small changes shouldn't wildly affect the output of the network.
- **Consistency** - Network's predictions are reasonable with what's physically possible.

We can define and study these properties formally! Let us take robustness for example. One way to model it is, "Is there an image classified as a cat by network N, such that the same image with reduced brightness is classified as something else by N?". Now, this can be modelled as an SMT query! How do we go about verifying it? Networks are large in size, and are non-linear activation functions, which means traditional SMT solvers might not work! Let us consider a toy network as below:

``` C
float toy-network(float v11){
	float v21, v22, v31;
	
	v21 = 1.0 * v11;
	if (v21<=0) v21 = 0;
	
	v22 = -1.0 * v11;
	if (v22 <= 0) v22 = 0;
	
	v31 = (1.0*v21 + 1.0 + v22);
	return v31;
}
```

This program represents a simple neural network with one input node and one output node and two hidden nodes with [RELU](https://www.dremio.com/wiki/relu-activation-function/) activation function. Upon converting this program to the SMT-LIB2 format, we may run any SMT solver on it and get the desired proofs.

Now, let us consider Recurrent Neural Networks (RNNs). RNNs have some memory associated with certain nodes which is written to and later read from during the **operation** of the neural network. Since the state gets affected by the input, and the state can affect output, we need to be able to talk about how many times an input is given to the neural network. If we know how many times the RNN will be given inputs, it can be transformed into a Feed Forward Neural Network (FFNN) with equivalent behaviour. In the case of Deep Reinforcement Learning, we can verify the policies by making multiple copies into FFNNs to verify.

Now, considering this techique, what are the problems we face in this method? Active research areas are:
- Minimising DNNs without affecting their functionality
- Abstraction Refinement techniques for verification (can we classify and sacrifice some "irrelevant" functionality?)
- Repairing Networks to follow some formal parameters
- Explainability of DNNs

[Marabou](https://github.com/NeuralNetworkVerification/Marabou) and [NeuralSAT](https://github.com/dynaroars/neuralsat) are tools that have their own implementations for neural network verification.. 

This is a difficult problem, however. Trying to simply use SAT solvers to solve these properties for neural networks can be extremely time consuming. One other approach that was proposed in 2017 was [Reluplex](https://arxiv.org/pdf/1702.01135), which is based on extending the [Simplex](https://en.wikipedia.org/wiki/Simplex_algorithm) method in linear programming to handle FFNNs using RELU activation function, and shows that even verifying simple things about them is NP-complete. Also, since Simplex only works for linear constraints (as it is an algorithm for linear programming), it can only prove properties about the neural network that take the form of linear constraints.  The lecture closely follows the paper from this point on. This approach while simple and not very elegant at first glance, turned out to be much more efficient than SAT solvers for this kind of problem, verifying properties in within a minute which SAT solvers weren't able to in 14400. This is a big deal, especially when the problem is (as the very same paper shows) NP-complete.

That was all for the the day, with the rest to be touched upon in the following day.

# Day 3 <a name="day3"></a>

## Lecture by Kumar Madhukar on Neural Network Verification Part II <a name="dnn2"></a>

### Abstraction Refinement

Today, we explored the strategy of [Abstraction Refinement for Neural Networks](https://arxiv.org/pdf/1910.14574), where we try to analyse if a neural metwork can be replaced by a smaller network. Suppose we have a neural network **N**, we construct  a smaller network **N'**, such that if **N'** violates the specification, so does **N**. If **N'** meets the specification, then all good! If not, there must be a counterexample *x*. Now, if *x* violates the specification for **N** also, then the original neural network violates the specification, and we have proven that it does not. Otherwise (ie. if the counterexample is spurious), we can refine **N'** more to make it more accurate, and "larger". Thus we use the **Counterexample-Guided Abstraction Refinemenet** strategy, where we use counterexamples to either refine the neural network, or prove that a specification does not hold.

Now, let us look at the strategy proposed in the paper deeper. Let us say we have a precondition **P**. postcondition **Q**, and network **N**. A neural network is safe if for every input **x** such that **P(x)** and **Q(N(x))** hold. The paper assumes that
- there is only one output neuron, and only ReLU activation function are used.
- the property of interest is that the output is never greater than some constant

In the transformation, the neural network **N'** is such that **N(x) <= N'(x)**. If **N'** is safe, then so must **N** because of the nature of the postconditiion. Now how do we do construct such a network? We follow the general abstraction-refinement strategy and merging and splitting neurons in an equivalent network **N''**. Now, here is the general strategy -
- If a neuron has only positive outgoing edges,  we classify it as **pos**
- If a neuron has only negative outgoing edges,  we classify it as **neg**
- Otherwise, we split the neuron into two neurons, such that one has all the positive outgoing edges of the original neuron, while the other has all the negative outgoing edges of the original neuron, such that they both have all the incoming edges of the original neuron.

After this is done, all neurons are marked **inc** or **dec**, if increasing the value of the neuron increases the output, and if decrementing the value of the neuron decreases the input. The algorithm for this is as follows -
- The output is marked **inc** (increasing the output increases the output)
- Now, until all neurons are marked
  - All vertices in the layer about to be marked are split, sharing incoming edges, such one neuron only connects to **inc** neurons, and the other only connects to **dec** neurons
  - All neurons with positive weight edges to **inc** neurons, and all neurons with negative weight edges to **dec** neurons are marked **inc**
  - All neurons with positive weight edges to **dec** neurons, and all neurons with negative weight edges to **inc** neurons are marked **dec**

Now after doing all the splitting, we start merging.
- We merge neurons in the same layer. We merge neurons only in with the same pair of **pos/neg** and **inc/dec** tags.
- There are two cases when merging two neurons
  - They share **inc** tags: For every vertex with incoming edges from both the neurons, we sum the edges for the new neuron. For every vertex with outgoing edges to both the neurons, we take the maximum value for the edge of the new neuron. (This will only increase the possible output, preserving **N(x) <= N'(x)**.)
  - They share **dec** tags: For every vertex with incoming edges from both the neurons, we sum the edges for the new neuron. For every vertex with outgoing edges to both the neurons, we take the nimimum value for the edge of the new neuron.  (This will only increase the possible output, preserving **N(x) <= N'(x)**.)
It is possible to show that regardless of the order of merging, we always get the same final neural network by the above algorithm.

Now, this abstraction can be too coarse. If suppose we come across a spurious example (as discussed earlier), we pick a concrete neuron from an absract neuron , and put it back into the network until we come across an abstraction that does not generate spurious examples. (An question: Is the **pos/neg** split really needed? It is also worth thinking about how limiting the constraints on the postcondition and the output layers are, the paper discusses further about this. Go read it!) There are other kinds of refinement techniques too, some which merge two neurons together depending on if they have similar enough inputs, following a k-means clustering strategy.

### Some Hands on Work

Sanya Mittal, a student of Professor Kumar Madhukar, ended the session on neural network verification with an hour long workshop where we explored the verifiers [Marabou](https://github.com/NeuralNetworkVerification/Marabou) and [NeuralSAT](https://github.com/dynaroars/neuralsat). It's hard to reproduce the content covered during the workshop in this format, but do explore these tools on your own! They are extensively documented enough to be useful. Although, before starting to play with them, it might be useful to know what .onnx files are and how to produce them using pytorch.

## Talk by Silvia Ghilezan Proofs as Programming Paradigms: From Logic to AI<a name="lambda"></a>

### The Curry-Howard Isomorphism

*(If the title of this sounds interesting to you, but you the stuff discussed below, you may find this video on [Propositions as Types by Philip Wadler](https://youtu.be/IOiZatlZtGU) useful, appealing, and possibly funny.)*

This was a talk held by [Silvia Ghilezan](https://imft.ftn.uns.ac.rs/silvia/Main) on the correspondence between logical systems and programming languages, and the applications it has in our day to day lives. This correspondence is famously called the **Curry-Howard Isomorphism**. The Curry-Howard isomorphism was stated in reflection of the fact that throughout history, logicians and computer scientists have kept coming up with logical systems and programming languages (or models of computation) that are suspiciously similar. Some such examples are-

- **The Axiomatic System and Combinatory Logic** - The axiomatic system (also referred to as intuitionistic logic) is a system of logic which fixes some axioms, and claims that any object constructed in the system must be from those axioms. For example, the **Peano axiomatisation of natural numbers**. (If one wants to prove anything about natural numbers, they can only do so by constructing proofs with *these axioms* and nothing else.)

    > 
	- There is a natural number 0.
	- Every natural number n has a successor, denoted by Sn.
	- There is no natural number whose successor is 0.
	- Distinct natural numbers have distinct successors.
    - If a property is possessed by 0, and if it is possesed by Sn any given n, then it is possessed by all natural numbers (induction).

The [Combinatory Logic](https://en.wikipedia.org/wiki/Combinatory_logic) is constructed in the same way, as the terms available in it are variables, and only three *primitive functions* (or "combinators") using which all other terms are built.
- **Natural Deduction and The Lambda Calculus** - Natural Deduction is similar to the axiomatic system, except it also allows one to make *assumptions*. If you've taken a course in Discrete Math, you must have come across the method for proving an implication, which tends to go by "Assuming p, we prove q". The lambda calculus corresponds this with the introduction of oh-so familiar (anonymous) functions, which take a single argument (corresponding to the assumption) and contain an expression (corresponding to the right hand size of the implication).

This kind of correspondence has been seen and commented upon throughout history in different shapes and forms-
- In the 1950s, Curry noticed that the types in the combinatory logic correspond to axiomatic schemes in the axiomatic system.
- In 1968, Howard wrote Formulae as Types, writing on this correspondence, formalising the notion, and showing how cut elimination in proofs corresponded to reduction during term evaluation.
- In the 1970s, Lambek showed that intuitionistic proofs and combinatory logic combinators share an equational logic called Cartesian Closed Categories.
- In the 1970s, De Bruijn developed AUTOMATH, a formal system for verifying proofs, the first practical system exploiting the Curry-Howard Isomorphism, being highly influential in the development of proof assistants.
- In the 1970s 1970s Martin-Löf developed the Type Theory, which had constructs for inductive proofs and universal quantifiers too.

Some concrete examples of further such correspondences are -
- Intuitionistic Logic -> The λ-calculus and Combinatory Logic
- Second-Order Logic -> Polymorphic Lambda Calculus, or [Girard's System F](https://en.wikipedia.org/wiki/System_F) 
- Predicate Logic -> Different Vertices of the [Lambda Cube](https://en.wikipedia.org/wiki/Lambda_cube)
- Classical Logic -> [λμ-calculus](https://en.wikipedia.org/wiki/Lambda-mu_calculus) (Models continuations, which models constructs like async and await.)
- Theory of Communication -> Process Calculi 

Now while all these correspondences between Logical Systems and Theoretical Programming Languages are interesting, especially given how many were discovered independently of each other, how does this have any practical application? Well, when we are dealing with things in computer science, we want to know, "What is computable?". The most famous model of computability is the Turing Machine, and it turns out, that it is *completely* equivalent to the λ-calculus (and also to [Kleene's Recursive Functions](https://en.wikipedia.org/wiki/General_recursive_function).) That is, a function is computable by a computer if and only if it can be expressed as a term of the λ-calculus! (You can replace the constructs in a programming language (assuming it only has natural numbers) with the equivalent λ-calculus terms ant it still works!)

### The Lambda Calculus - A Theory of Functions

Now, what *is* the λ-calculus? It is at its very core, the simplest programming language, built entirely out of functions. Its grammar is below, the first term is variable, the second represents a function application, and the third represents abstraction (or function creation).

$$ M ::= x | (M M) | (\lambda x.M)$$

The λ-calculus has two reduction rules. The first one, also called α-conversion, is simply a renaming rule. It is equivalent to taking a function, and changing the name of the argument while substituting all instances of the argument in the body of the function with that name. The seocnd rule is called β-reduction, and is the process of function application, where upon applying a function, all instances of the argument are substituted with instances of the λ-term that the function is being applied to. (Notice how there is no specification on the *order* of evaluation. If we have a λ-term *(M N)* where both *M* and *N* are β-reducible, then which do we reduce first? Try to convince that yourself that it doesn't matter, and come up with a counterexample otherwise.)


$$ \lambda x.M \rightarrow_{\alpha} \lambda y.M[x:=y], y \not \in FV(M)$$

$$ (\lambda x.M)N \rightarrow_{\beta} M[x:=N]$$

With only these two rules, we can see how proofs may correspond to programs (ie. λ-terms). If we suppose that the type of a variable correspond to a proposition, then an abstraction in the λ-calculus corresponds to implications (as disussed before)! This is the primary idea. To be able to more cleanly map other constructs (like quantifies, for example) we may want to *extend* the calculus accordingly. However, the basic idea still remains the same. That is, **proofs as programs, and proof normalisation as term reduction, thus, a formula is only provable if its corresponding type is inhabited by a term**. (Note, due to the constructivist nature of most programming languages, cannot make a program that proves Pierce's law. That is, that the proposition $$((P \rightarrow Q) \rightarrow P) \rightarrow P$$ is always true. The λμ-calculus does allow a proof of Pierce's law, however, and it allows us to model continuations!)

Now, what kinds of extensions are there? Well, considering Intuitionistic Logic as our base, let us consider the following logical systems that build ontop of the intuitionistic logic.
- Proposition Logic
- Second-Order proposition Logic
- Weakly Higher Order Proposition logic
- Higher-Order Proposition Logic
- Predicate Logic
- Second-order predicate logic
- Weakly Higher-Order Logic

As it turns out, there is a corresponding calculus for all of these! Collectively, along with the simply typed λ-calculus, they form the [λ-Cube](https://www.youtube.com/playlist?list=PLNwzBl6BGLwOKBFVbvp-GFjAA_ESZ--q4). (I won't go into the details of these correspondences in the interest of keeping this blog post concise, but do check out the linked playlist! It should be a helpful introduction to the topic). Now, we know how to make programming languages and type-checkers. If proofs are programs, to check if a proof is correct, **we just need to check that the corresponding program is well-typed!** This is the basis of proof assistants like Coq and Isabelle, which have had tremendous application ever since they've been made. Using automated proving techniques, we could prove the fundamental theorem of algebra, the four colour map theorem, and even build a formally verified C compiler, which is used to verify the functioning of an Airbus! 

The properties of the calculi that make them so useful as correspondences to proof systems are the following -
- **Uniqueness of Types** - Every well-typed term has only one possible typing (We would like to be able to know that our proofs prove one specific proposition!)
- **Confluence (Church-Rosser property)** - In a language like Python, evaluation of $$f(x)+g(x)$$ might depend on the order in which we evaluate the operands due to mutation. However, for the mentioned calculi, the order of reduction does not matter. This is also helpful, since we would not want the order in which we establish say, the lemmas of a proof and use them to matter for the complete proof.
- **Type Preservation under Reduction (Subject Reduction)** - When we simplify a proof, or use a reduction rule, we do not want the theorem we are proving to change.
- **Termination (Strong Normalisation)** - All proofs are reducible to a simplest canonical form.
- **Expressiveness** - With the varying calculi, we have the ability to express different kinds of constructs. Python, for example, does not have Sum types, so we cannot say that a term is one of two different types.
Thus, with the help of these properties, well typed programs cannot "go wrong"! A famouse adage in Type Theory is that **Safety = Progress + Preservation**.

Now, what is the application of all this in Federated Learning? Federated Learning is a machine learning setting where clients keep training data decentralised between computers. This is a completely new field, and is an intersection between machine learning and formal verification! However, there is AI Engineers  and for Formal Verification scientists use completely different modes of communication. Thus there is interest in developing a common language for the both of them. Some related work has been

- [A Python Testbed for Federated Learning Algorithms](https://ieeexplore.ieee.org/document/10173859)
- Communicating Sequential Processes Calculus (CSP)
- [The Process Analysis Toolkit for Model Checking](https://pat.comp.nus.edu.sg/resources/OnlineHelp/htm/)


If you found all this interesting, here are some papers to read, and some resources to learn from!
- **Papers**
  - [Lambda Calculi with Types](https://home.ttic.edu/~dreyer/course/papers/barendregt.pdf)
  - [The Formulae as Types Notions of Construction](https://www.cs.cmu.edu/~crary/819-f09/Howard80.pdf)
  - [Lectures on the Curry Howard Isomorphism](https://disi.unitn.it/~bernardi/RSISE11/Papers/curry-howard.pdf)
- **Resources**
  - [OPLSS](https://www.youtube.com/@OPLSS) (you can go to their website too)
  - [International School on Proof Theory](https://proofsociety2024.com)

## Tutorial by Priyanka Golia by on SAT Solvers <a name="sat"></a>


Finally, as the last topic for the winter school, [Priyanka Golia](https://priyanka-golia.github.io/) started her tutorial on SAT Solvers.

In a very informal sense, logic is about inferring conclusions from a given set of premises. For very simple conclusions this is an easy thing to do. (Quite a few of us would be a familiar with the "All men are mortal, Plato is a man, therefore Plato is a mortal" kind of example). However, what about decisions a self driving car should make? How do we formalise the conditions required for the car to recognise if a stop sign is real, or if it is broken or damaged? Deciding on an appropriate formalisation is not easy as a human, thuse we need to have automated reasoning. We also need to be able to verify other things about neural networks. How can we make sure that a face recognition model does not discriminate by racial division? How do we try to analyse *why* a model fails at classifying certain inputs when it does? For all these kinds of formal verification problems, we use SAT and SMT solvers. Now, it is well known that this is an NP-complete problem. If that's the case, how do we build solvers that are still efficient when it comes to modern day application? Let us start to learn these things by first establishing the basics.

**Satisfiability** - The question of satisfiability is very simple. Given a first order boolean formula over a set of boolean variables, does there exist an assignment for all the boolean variables such that the value of the boolean formula becomes one? SAT solvers revolve around finding this satisfying assignment, or telling us if one does not exist, and they operate purely in the doman of boolean theory. SMT solvers are like SAT solvers, except they have formulae in different theory like Linear Integer Arithmetic, Linear Real Arithmetic, Bit Vectors, Strings, etc. (One may also want to ask, how do we know what boolean formula we need to try to satisfy? This is the problem of boolean encoding!)

Now, in the same way that high school algebra becomes more generally useful once we start using symbolic variables, let us establish some notation that we may use to better generalise what we speak about.

We say that $$\tau$$ represents a function that maps each variable in a propositional formula to either 0 or 1. There are $$2^n$$ possible such functions for n boolean variables. If $$F$$ is a boolean formula, $$F(\tau)$$ represents the value obtained by replacing each boolean variable $$x$$ in $$F$$ by $$\tau(x)$$, and then evaluating the formula. We say that $$\tau$$ satisfies $$F$$ if $$F(\tau) = 1$$. *F* is satisfiable if there exists such a $$\tau$$ such that $$\tau$$ satisfies *F*. We call it valid if for every $$\tau, F(\tau) = 1$$, and unsatisfiable if for every $$\tau, F(\tau) = 0$$. 

The set of all of all satisfying assignments of *F* is called the Models of *F*, ie. $$ Models(F) = \{\tau ~\arrowvert ~F(\tau)=1\}$$, and it has the following properties -
- Negation: $$Models(\neg F) = (Set ~of ~all ~\tau) \setminus Models(F)$$
- Or: $$Models(F \lor G) = Models(F) \cup Models(G)$$
- And: $$Models(F \land G) = Models(F) \cap Models(G)$$
Two models are said to be **equivalent** if they have the same Models set.

Let us try some hands on work! SAT solvers take inputs in Conjuction Normal Form (ANDs of ORs). They do this because reasoning about a boolean formula in CNF is much easier than if it were something random, and every propositional formula is reducible to CNF! Consider the following formula:

$$ (x_1 \land y_1) \lor (x_2 \land y_2)... (x_n \land y_n)$$

Now, how can we convert this to CNF? If we just try to use De Morgan's (distributive) laws, the final CNF formula will have $$2^n$$ clauses. Which means we will have a non-polynomial time algorithm for just converting to CNF. Can we do better? Try to reason for yourself before reading on. (**Hint:** Two formulae *F*, *G* are equisatisfiable iff *F* is satisfiable if and only if *G* is satisfiable. For example, $$ F = (p \lor \alpha) \land (\neg p \lor \beta), G + (\alpha \lor \beta)$$).

As it turns out, yes, we can do better! We can do this by adding variables. For each $$(x_k \land y_k)$$, we add 

$$(t_k \leftrightarrow (x_k \land y_k))$$ 

which gets reduced to 

$$(t_k \lor \neg x_k \neg y_k) \land (\neg t_k \lor (x_k \land y_k))$$

$$(t_k \lor \neg x_k \neg y_k) \land (\neg t_k \lor  x_k) \land (\neg t_k \lor y_k)$$

Doing this, the original formula can be reduced to $$(t_1 \lor t_2  \lor t_3 ... t_n)$$, and we can just take the conjunction of that with all the other clauses. Thus, reducing the formula to CNF in 3n+1 time, which is a very big improvement from our non-polynomial time algorithm! Having a polynomial time algorithm to convert boolean formulae to CNF is great, because every formula *F* can be represented in CNF, say $$F_{CNF}$$ in polynomyal time such that *F* is satisfiable if and only if $$F_{CNF}$$ is satisfiable. (Although, do we really need the implication to hold both ways?)


**The K-SAT Problem** - The K-Sat problem involves checking the satisfiability of a boolean formula in CNF, such that every "clause" (wherethe clause takes the form $$(x_1 \lor x_2 \lor .. x_k)$$) has k literals. As it turns out, the 2-SAT problem can be solved in polynomial time, but we do not have a polynomial time algorithm for solving 3-SAT! (It also turns out that every N-SAT problem where N > 3 can be converted to the 3-SAT problem in polynomial time, but there currently isn't a way to convert 3-SAT to 2-SAT. Try to reason why for yourself! You can start by trying to convert a 4-SAT problem to a 3-SAT problem.)

Not only is trying to solve the satisfiability problem, but how easy is it to even convert problems into SAT problems? You can try your hand at it for the k-colouring problem, that is, is it possible to colour each vertex of a graph using k-colours (where every vertex is coloured with one colour) such that there is no edge with the same colour on either vertex. You may first want to try to to encode the 3-colouring constraint for an undirected simple graph with 3 edges and 3 vertices . (**Hint:** It will take 9 boolean variables. Try to encode the constraints "Each vertex has atleast one colour", "Each vertex has atmost one colour", and "An edge cannot have the same colour for both vertices". Don't worry about the answer being too long.)

The rest was covered on the next day!

# Day 4 <a name="day4"></a> #

## Lecture by Priyanka Golia on SAT Solving Algorithms <a name="sat2"> </a>

We say that a partial model $$\psi$$ is a **partial** function from the set of boolean variables to {0,1} (unlike $$\tau$$, which is a **total** function). For a given boolean formula *F* in **CNF form**, we say that the state of a clause *C* under a partial model $$\psi$$ is -
- **True**, if there exists a literal e in C such that $$\psi(e)=1$$,
- **False**, if for all e in C, $$\psi(e)=0$$,
- **Undetermined**, otherwise.
Thus, we say a boolean formula *F* (in CNF form)is true under partial model $$\psi$$ if **all** the clauses are true. We also define a unit clause to be a clause with only one literal unassigned by the partial function, with the rest of the literals false. We call the unassigned literal of the unit clause to be the unit literal. Having established these terms, we can now investigate the algorithms for SAT solving.

### The Davis-Putnam-Loveland-Logemann Algorithm (DPLL)
The DPLL algorithm for solving the SAT problem forms the basic structure for all SAT solvers today. The primary difference comes through the heuristics involved in some of its steps and some other ways in which it is implemented. We will not take minute to look at the algorithm, as it was originally proposed.

1. Throughout the algorithm, we maintain a partial model, which is initially empty (ie. all boolean variables are unassigned under it).
2. We pick an unassigned variable, and assign it the value 1 or 0. At this step, we take a **decision**.
3. If this decision creates any unit clauses, for each unit clause, the boolean variable corresponding to the literal is assigned 0 if the literal is of the form $$\neg x$$ and 1 otherwise (this is done to make the clause **True**). We repeat this until there are no more unit clauses.
4. If we ever make an opposing assignment to a variable that is alreadya assigned, creating a **conflict**, we backtrack on the last **decision** we made and choose the other value. If we have already choosen the other value before, we backtrack further to the decision before that.
5. The algorithm terminates when all the clauses are true, proving **satisfiability** or when we cannot backtrack further (that is, when we have explored both the branches from the first decision point), **proving unsatisfiability**.

Let us try to work this out through the following boolean formula

$$ F = (\neg x_1 \lor \neg x_2 \lor \neg x_3) \land (\neg x_3 \lor x_2) \land (\neg x_2 \lor x_1)$$

A trace of the DPLL algorithm running on this formula might look like this.
1. $$x_3$$ is assigned 1. The second clause becomes a unit clause and thus, $$x_2$$ is assigned 1. Now both the first and third clauses become unit clauses, but we now have a **conflict**, because by the first clause we assign $$x_1$$ the value 0, while in the third clause we assign the value 0.
2. We now have to backtrack, the last (and only) decision we made was regarding $$x_3$$, so we assign it the value 0.
3. There are no unit clauses, therefore, we randomly assign the value 0 for $$x_1$$. This makes the last clause a unit clause, and we thus assign $$x_2$$ the value 1.
4. All the clauses are true! Thus the formula is satisfiable.

If you are futher interested, you may want to read the **Handbook of Satisfiability**.

### Conflict Driven Clause Learning (CDCL)

While the DPLL algorithm is guaranteed to work, it is not very efficient. One the things we can do to optimise it, is by observing the trace during the execution of the algorithm, and using information gained from it to avoid unnecessary backtracking. The data structure used by the algorithms built around CDCL to store this information is called an **Implementation Graph**. Here is a [paper](https://www.cs.princeton.edu/courses/archive/fall13/cos402/readings/SAT_learning_clauses.pdf) that explains the concept (along with Unique Implication Points! UIPs come up later). Whenever a decision leads to a conflict, we gain a conflict clause by taking the decisions that  contributed to that conflict clause and negating them. For example, if assigning 1 to $$x_1$$ and 0 to $$x_2$$ leads to a conflict, we add the conflict clause $$(\neg x_1 \lor x_2)$$ to our clauses in CNF. Then, we backtrack to the second latest decision that caused the conflict. (Note, this decision to backtrack to the second latest decision is just a heuristic in the CDCL algorithm, as we'll see later, there are other kinds of heuristics that we can use to optimise our algorithm).

### Heuristics

So, what are these heuristics? The CDCL algorithm (which is the layout of modern SAT solvers) has 3 major components

1. **Unit Propagation** - Without unit propagation, DPLL would be much more like a depth first search, and would be much more inefficient.
2. **Decision Making** - Deciding on a variable to assign, and what value to assign to it, is something which has a lot of variability.
3. **Conflict Analysis** - Deciding on the conflict clause to learn after a conflict is something to optimise too, where more often than not, we want to learn a smaller clause to minimise our search space better.

There is some research going on in how to use machine learning models in trying to find better heuristics. There are also optimisations made for specific kinds of clauses. Crypto-MiniSAT, for example, has optimisations for XOR clauses which are usually very difficult for SAT solvers to deal with (since we can only decide on a XOR clause's state once **all or one less than all** of its values have been assigned). If you want to explore different kinds of SAT solvers more, you can use [PySAT](https://pysathq.github.io/) to do so!

#### Conflict Analysis Heuristics - UIP

Professor Priyanka talked about UIPs and learning clauses from them, and I think it'd be very difficult for me to explain them properly using text on this blogpost, so please check out the paper linked earlier!

#### Decision Making Heuristics - DLIS and VSIDS

There are a lot ways one could make a decision about what variable to assign to, such as -
1. Number of variable occurences in remaining unsatisfied clauses.
2. Dynamic heuristics - Focus on variables which were useful recently in deriving learned clauses, can be interpreted as reinforcement learning (VSIDS, which will see shortly, follows this).
3. Look Ahead - Spends more time looking for good variables (this doesn't work that well in practice).

One such method proposed in 1996 was the Dynamic Largest Individual Sum (or DLIS) method, where at each decision point, all the unassigned clauses were searched to find the literal that occured the most, and that literal was used for the basis of the decision (if the literal is *x*, then *x* is assigned 1, and if the literal is $$\neg x$$, then *x* is assigned 0). However, while this method leads to better decisions, it leads to inefficiency when it goes through every single clause to count all the literals. A SAT solver may be dealing with lakhs of variables and clauses, so this counting takes a lot of time!

To improve over this, the Variable State Independent Decaying Sum (VSIDS) method was invented. Instead of searching every single time, the occurence of each clause is counted once at the start. Then, whenever a new conflict clause is added, the counters of the literals in the conflict clause is incremented appropriately. At each decision point, the unassigned variable with polarity corresponding to the highest counter is chosen. The advantage of VSIDS over DLIS is that it has very low overhead comparatively, dynamically learns from new conflict clauses, and focuses the search based on what its learned locally. To allow newer conflict clauses to more easily affect the search, every 256 decisions, the values of all the counters are *halved*, allowing other variables to "catch up" (hence the "Decaying Sum").

At the end of the day, SAT Solving involves Algorithms, Science, and Art. Algorithms are central to making SAT solvers, science and experimentation are necessary in the selection of different heuristics, and there is an art in investigating the different reasons for why an approach works.

## A Final Interaction <a name="end"></a>

With this, the winter school concluded with a final interaction session with the Formal Methods faculty in IIT Delhi, where we discussed research, the importance of good communication, and the importance of having fun.


That concludes the blog! I hope it was useful. I will be maintaining this blog and might add to it even in the future, so if you have any corrections or addendums, feel free to reach me!
