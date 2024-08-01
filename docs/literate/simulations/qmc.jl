#==
## Quasi Monte Carlo 

## Example

In this example, we will perform a semsitivity analysis using Quasi Monte Carlo.
Let's consider the ishigami function which is defined as $f(x_{1}, x_{2}, x_{3}) = sin(x_{1}) +  a * sin(x_{2})^2 + b * x_{3}^4 * sin(x_{1}) $
==#
using UncertaintyQuantification

x = RandomVariable.(Uniform(-π, π), [:x1, :x2, :x3])
a = Parameter(7, :a)
b = Parameter(0.05, :b)

inputs = [x; a; b]

ishigami = Model(
    df -> sin.(df.x1) .+ df.a .* sin.(df.x2) .^ 2 .+ df.b .* (df.x3 .^ 4) .* sin.(df.x1), :y
)

#==
Now, we'll sample 1000 points using scrambled Sobol-sampling.
==#

rqmc = sample(inputs, SobolSampling(1000, :owenscramble))

s_rqmc = sobolindices(ishigami, x, :y, rqmc)

σx = [1, 1.1, 0.9, 1.2, 0.8]
σω = [0.7, 1.3, 1.4, 0.6, 0.95]

X = RandomVariable.(Normal.(0, σx), [:X1, :X2, :X3, :X4, :X5])
ω = RandomVariable.(Normal.(0, σω), [:ω1, :ω2, :ω3, :ω4, :ω5])

B = Model(
    df ->
        df.X1 .* df.ω1 + df.X2 .* df.ω2 + df.X3 .* df.ω3 + df.X4 .* df.ω4 + df.X5 .* df.ω5,
    :B,
)

mc = MonteCarlo(10000)

s_mc = sobolindices(B, [X; ω], :B, mc)

# Compare with analytical solution
VB = sum(σx .^ 2 .* σω .^ 2)
analytical = (σx .^ 2 .* σω .^ 2) / VB

# Monte Carlo
@assert all(isapprox.(s_mc.FirstOrder, 0.0, atol=0.1))
@assert all(isapprox.(s_mc.TotalEffect[1:5], analytical, rtol=0.1))
@assert all(isapprox.(s_mc.TotalEffect[6:end], analytical, rtol=0.1))
