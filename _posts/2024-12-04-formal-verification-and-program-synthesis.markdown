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
- Adding features for different language constructs - Subodh Sir had mentioned working on SKLEE, a modification of KLEE that allowed support for the kinds of functions used in Solidity to write immutable etherium contracts. Such things can be done for other language constructs.
- Modelling Memory - One way to model memory is Fully Symbolic Memory, where every pointer, every element of an array is considered a symbolic variable. This leads to state forking, where whenever an array is considered with an operation on a variable index, the SEE must consider the possible executions at every possible array location. An alternate approach is using Heap Analysis to figure things out using the shape of the memory in the heap. However, this is an active research problem.

If all of this interests you, you may try your hands on [KLEE](https://klee-se.org/), a symbolic execution engine using the clang LLVM. It is excessively documented, and is easy to install using Docker (and other methods). Play around! You can try the following problems that Sir gave us during the talk if you wish to test your understanding.

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

[Marabou](https://github.com/NeuralNetworkVerification/Marabou) and [NeuralSAT](https://github.com/dynaroars/neuralsat) are tools that have their own implementations for neural network implementation. 

This is a difficult problem, however. Trying to simply use SAT solvers to solve these properties for neural networks can be extremely time consuming. One other approach that was proposed in 2017 was [Reluplex](https://arxiv.org/pdf/1702.01135), which is based on extending the [Simplex](https://en.wikipedia.org/wiki/Simplex_algorithm) method in linear programming to handle FFNNs using RELU activation function, and shows that even verifying simple things about them is NP-complete. Also, since Simplex only works for linear constraints (as it is an algorithm for linear programming), it can only prove properties about the neural network that take the form of linear constraints.  The lecture closely follows the paper from this point on. This approach while simple and not very elegant at first glance, turned out to be much more efficient than SAT solvers for this kind of problem, verifying properties in within a minute which SAT solvers weren't able to in 14400. This is a big deal, especially when the problem is (as the very same paper shows) NP-complete in terms of computational complexity..
