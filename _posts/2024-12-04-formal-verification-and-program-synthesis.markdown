--
layout: post
title: "Winter School on Formal Vertification and Program Synthesis, IIT Delhi"
---

# Day 1 #

## Talk by Prof Sanjam Garg on his Research Journey

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

##  Lecture by Subodh Sharma on Symbolic Execution: Fundamentals and Applications

### How can we test a program?

**The more traditional approach : Concrete Execution** - Clasically, developers may try to ensure the correctness of their code by writing test cases, where different inputs and expected outputs of a program are jotted down, and the program is run on those inputs and the outputs are checked against those expected outputs. The program passes the tests if all the outputs match all the corresponding expected outputs. However, this approach is not appealing for many reasons. For one, passing test cases does not provide a *guarantee* that the program will work for *all* possible inputs. Even with a simple factorial program, a programmer may forget to account for the cases of negative input or for the case of a large input (which may cause integer overflow). What we would like to do is know *for sure* that all bugs in the program have been caught. How can we go about this?

**A systematic way to test : Symbolic Execution** - In the approach proposed in a paper by JC King in 1976 called **Symbolic Execution and Program Testing**, we do not actually *execute* the program. What we do is to assign the unknown/unfixed variables of the program with *symbols*, which are then traced through the different control flow pathways of the program. In each of these paths, the execution keeps track of the different properties that these symbolic variables have, and then finally checks for a certain criterion at the end of the program. Thus, symbolic execution is useful for guaranteeing state invariant properties, which must hold across all initial states and given inputs (since the symbols and the constraints generated never depend on any *concrete* value, as no actual execution is done). The symbolic execution generates different pathways by seeing what points in the programs depend on the pre-assigned symbols. The symbolic execution then generates different constraints for the pathways, called path constraints. These path constraints take the form of first order logic formulas involving the symbols and variables in the program. Let us look at an example.

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
- Path Explosion: How to hanndlee programs witha large number of control flow paths? How to handle loops?

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

# Day 2 #
