using UncertaintyQuantification

"""
Inputs
"""

N = 1000
numberOfStages = 2

x1 = ContinuousDesignVariable(-3, 3, :x1)
x2 = ContinuousDesignVariable(-3, 3, :x2)

inputs = [x1, x2]

g = Constraint(
    design ->
        0.1 +
        (sin(design.x1^2 - design.x2^2)^2 - 0.5) / (1 + 0.001(design.x1^2 - design.x2^2))^2,
)

"""
Stage 0
"""

α = [0.0]
ν = 0.5
β² = (2.4 / sqrt(length(inputs)))^2

samples = sample(inputs, MonteCarlo(N))

G = g(samples)

H = max.(0, G)

"""
Stage 1
"""

α = [α..., get_new_exponent(H, ν, α)]

w = get_normalized_weights(H, α)

to_standard_normal_space!(inputs, samples)
Z = Matrix(samples[:, names(inputs)])
Σ = get_covariance(Z, w, β²)
