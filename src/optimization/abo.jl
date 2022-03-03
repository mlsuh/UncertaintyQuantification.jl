function get_new_exponent(H::Vector{Float64}, ν::Float64, α::Vector{Float64})
    stage = length(α)

    if sum(H .== minimum(H)) >= ν * length(H)
        if stage == 1
            return 0
        else
            if α[stage - 1] == 0
                return α[stage] * 5
            else
                return α[stage]^2 / α[stage - 1]
            end
        end
    else
        return find_zero(_S(H, ν, α[stage]), (α[stage], prevfloat(Inf)))
    end
end

function get_normalized_weights(H::Vector{Float64}, α::Vector{Float64})
    w = exp.((α[end] - α[end - 1]) * (minimum(H) .- H))
    return w ./ sum(w)
end

covariance_method = LinearShrinkage(DiagonalUnitVariance(), :lw)

function get_covariance(Z::Matrix, w::Vector{Float64}, β²::Float64)
    return β² * cov(covariance_method, Z .* w)
end

function _S(H::Vector{Float64}, ν::Float64, α::Float64)
    S = function (x::Float64)
        s1 = sum(exp.(2 * (minimum(H) .- H) * (x - α)))
        s2 = sum(exp.((minimum(H) .- H) * (x - α)))^2

        return s1 - s2 / (ν * length(H))
    end

    return S
end
