struct ContinuousDesignVariable <: RandomUQInput
    lb::Real
    ub::Real
    name::Symbol
end

function sample(cdv::ContinuousDesignVariable, n::Int=1)
    return sample(RandomVariable(Uniform(cdv.lb, cdv.ub), cdv.name), n)
end

function to_physical_space!(cdv::ContinuousDesignVariable, x::DataFrame)
    to_physical_space!(RandomVariable(Uniform(cdv.lb, cdv.ub), cdv.name), x)
    return nothing
end

function to_standard_normal_space!(cdv::ContinuousDesignVariable, x::DataFrame)
    to_standard_normal_space!(RandomVariable(Uniform(cdv.lb, cdv.ub), cdv.name), x)
    return nothing
end

dimensions(cdv::ContinuousDesignVariable) = 1
