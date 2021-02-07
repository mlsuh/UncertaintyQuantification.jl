mutable struct LineSampling
    lines::Integer
    points::Vector{<:Real}
    direction::DataFrame

    function LineSampling(
        lines::Integer,
        points::Vector{<:Real}=collect(0.5:0.5:5),
        direction::DataFrame=DataFrame()
    )
        new(lines, points, direction)
    end
end

function sample(inputs::Array{<:UQInput}, sim::LineSampling)
    random_inputs = filter(i -> isa(i, RandomUQInput), inputs)
    deterministic_inputs = filter(i -> isa(i, DeterministicUQInput), inputs)

    n_rv = count_rvs(random_inputs)
    n_samples = length(sim.points) * sim.lines

    α = vec(Matrix(sim.direction))
    α /= norm(α)

    θ = rand(Normal(), n_rv, sim.lines)

    θ = θ - α * (α' * θ)
    θ = repeat(θ, outer=[length(sim.points), 1])

    θ = θ[:] + repeat(α * sim.points', outer=[1, sim.lines])[:]

    samples = reshape(θ, n_rv, n_samples) |> transpose
    samples = DataFrame(names(random_inputs) .=> eachcol(samples))

    if !isempty(deterministic_inputs)
        samples = hcat(samples, sample(deterministic_inputs, n_samples))
    end

    to_physical_space!(inputs, samples)

    return samples
end
