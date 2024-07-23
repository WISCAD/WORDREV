# WORDREV
Word-RevEng: Word-Level Identification using Control Signals in A Gate-Level Netlist

This project investigates the effects of identifying and evaluating control signals to aid in structural matching. Structural matching is used in netlist reverse engineering to group bits in a circuit together based on matching input structure. The goal is for these groups to contain the bits corresponding to the high-level words of a circuit. In order for bits to be grouped together, they require an identical structural match for part of their input cone. We have found that it is often not the case that all bits of a word will have this identically matching structure. However, in some cases they will match if we apply values to control signals and simplify the circuit. In this way, we can more accurately group together bits that belong to the same word. This work seeks to demonstrate that we can find these control signals and use them to group more of a words' bits together in our resulting solution.

There are two main ways you can make use of this project. First, we have manually constructed reference files for several of the itc99 benchmarks. These reference files contain a "golden reference" to compare word identification solutions with. You can use these for evaluating your own word identification techniques. Second, you can use the existing code as a base to compare with your own word identification projects.

**Related Publication:**

E. Tashjian, and A. Davoodi, "On using control signals for word-level identification in a gate-level netlist", Design Automation Conf. (DAC'15), 6 pages, June 2015.
