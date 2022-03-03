struct Constraint
    g::Function
end

function (obj::Constraint)(df::DataFrame)
    return map(obj.g, eachrow(df))
end

function (obj::Constraint)(row::DataFrameRow)
    return obj.g(row)
end
