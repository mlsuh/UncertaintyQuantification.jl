# Simulations

## Monte Carlo

## Quasi Monte Carlo
Quasi Monte Carlo (QMC), is method of producing samples similar to those generated via Monte Carlo (MC).
The difference being, that QMC samples are generated deterministically in way to ensure they are evenly distributed across the sampling space, not forming clutters or voids as MC samples might.
This makes QMC more efficient than MC for lots of applications since fewer samples are needed in order to produce a sufficient density of samples throughout.
There are two types of QMC methods, digital nets and lattices.
There are multiple ways of QMC-sampling, included here are Lattice Rule Sampling and the digital nets Sobol Sampling, Halton Sampling, Faure Sampling and Latin Haypercube Sampling.

However, being deterministic, these QMC samples are missing the properties related to randomness that MC samples have.
To gain these properties it is possible to randomize QMC samples.
There are several randomization methods, useful in different cases, depending on the QMC method in use.

Implemented in this package are Owen-Scramble and Matousek-Scramble, two similar methods useful for Sobol and Faure Sampling aswell as Shift which can be used for Lattice Rule Sampling.
There also is an algorithm for Halton Sampling, that constructs builds samples from the ground up as opposed to randomizing existing samples which is what the aforementioned methods do.
