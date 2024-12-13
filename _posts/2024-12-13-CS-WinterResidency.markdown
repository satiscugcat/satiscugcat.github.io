---
layout: post
title: "CS Theory Winter Residency: Investigations Into Automated Theorem Proving and Verification"
---
# Introduction

From the 9th to the 13th of December, I stayed in IIT Delhi to start working with [Professor Vaishnavi Sundararajan](https://vaishs.github.io/) on a project involving automated theorem proving, specifically using the proof assistant Coq. 
# Some Context

But, what is a proof assistant/automated theorem prover? Well, proof assistants like Coq are based on the Curry-Howard Correspondence, where logical systems correspond to language semantics, propositions correspond to types, and constructing a proof of a proposition is the corresponds to constructing a term/program that inhabits the corresponding type. Thus, by formalising theorems in a type system of a language, we can use the language to build a proof of the theorem, and use the typechecker to verify our proof! 

# The Problem Statement

Thus, the goal of the project was to formalise the proof system about assertions discussed in [this paper](https://www.cmi.ac.in/~spsuresh/pdfs/csf24-techrep.pdf), and then experiment it within Coq to try and prove some metatheoretic properties about it, and to possibly extend it and see if certain properties still hold. Since this is a long term project, expect less frequent but more technical updates!

(PS: If this sounds interesting to you and you want to learn more about Coq, one great source is the series of books/programs called [Software Foundations](https://softwarefoundations.cis.upenn.edu/). Completing the first two volumes should give you a good grasp!)
