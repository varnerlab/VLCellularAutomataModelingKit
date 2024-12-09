abstract type AbstractWorldModel end
abstract type AbstractPolicyModel end
abstract type AbstractLearningModel end

"""
    mutable struct MyOneDimensionalElementarWolframRuleModel <: AbstractPolicyModel

The `MyOneDimensionalElementarWolframRuleModel` mutable struct represents a one-dimensional elementary Wolfram rule model.

### Required fields
- `index::Int`: The index of the rule
- `radius::Int`: The radius, i.e, the number of cells that influence the next state for this rule
- `colors::Int`: The number of colors in the rule, i.e., the number of states a cell can exist in
- `rule::Dict{Int,Int}`: A dictionary that holds the rule where the `key` is the binary representation of the neighborhood and the `value` is the next state
"""
mutable struct MyOneDimensionalElementarWolframRuleModel <: AbstractPolicyModel
    
    # data
    index::Int
    radius::Int
    colors::Int
    rule::Dict{Int,Int}

    # constructor -
    MyOneDimensionalElementarWolframRuleModel() = new();
end


mutable struct MyTwoDimensionalElementaryWolframRuleModel <: AbstractPolicyModel
    
    # data -
    index::Int
    radius::Int
    colors::Int
    rule::Dict{Int,Int}

    # constructor
    MyTwoDimensionalElementaryWolframRuleModel() = new()
end


mutable struct MyOneDimensionalTotalisticWolframRuleModel <: AbstractPolicyModel
    
    # data
    index::Int
    radius::Int
    colors::Int
    Q::Dict{Float64, Int64}
    rule::Dict{Int,Int}

    # constructor -
    MyOneDimensionalTotalisticWolframRuleModel() = new();
end

"""
    mutable struct MyTwoDimensionalTotalisticWolframRuleModel <: AbstractPolicyModel

The `MyTwoDimensionalTotalisticWolframRuleModel` mutable struct represents a two-dimensional totalistic Wolfram rule model.

### Required fields
- `index::Int`: The index of the rule
- `radius::Int`: The radius, i.e, the number of cells that influence the next state for this rule
- `colors::Int`: The number of colors in the rule, i.e., the number of states a cell can exist in
- `rule::Dict{Int,Int}`: A dictionary that holds the rule where the `key` is index of the neighborhood state and the `value` is the next state
- `neighborhoodstatesmap::Dict{Float64, Int64}`: A dictionary whose `keys` are the average of the neighborhood states and the `value` the neighborhood state index
"""
mutable struct MyTwoDimensionalTotalisticWolframRuleModel <: AbstractPolicyModel
    
    # data -
    index::Int
    radius::Int
    colors::Int
    neighborhoodstatesmap::Dict{Float64, Int64}
    rule::Dict{Int,Int}

    # constructor
    MyTwoDimensionalTotalisticWolframRuleModel() = new()
end
