abstract type AbstractWorldModel end
abstract type AbstractAgentModel end
abstract type AbstractPolicyModel end
abstract type AbstractLearningModel end


mutable struct MyElementaryWolframRuleModel <: AbstractPolicyModel
    
    # data -
    index::Int
    radius::Int
    colors::Int
    rule::Dict{Int, Int}

    # constructor
    MyElementaryWolframRuleModel() = new()
end


mutable struct MyTotalisticWolframRuleModel <: AbstractPolicyModel
    
    # data
    index::Int
    radius::Int
    colors::Int
    neighborhoodstatesmap::Dict{Float64, Int}
    rule::Dict{Int, Int}
    weights::Array{Float64,1}

    # constructor -
    MyTotalisticWolframRuleModel() = new();
end

mutable struct MySimpleTwoDimensionalAgentModel <: AbstractAgentModel
    
    # data -
    index::Int
    rule::Union{MyElementaryWolframRuleModel, MyTotalisticWolframRuleModel}
    connections::Array{Int,1} # which cells are in my neighborhood?

    # constructor -
    MySimpleTwoDimensionalAgentModel() = new();
end

mutable struct MySimpleOneDimensionalAgentModel <: AbstractAgentModel
    
    # data -
    index::Int
    rule::Union{MyElementaryWolframRuleModel, MyTotalisticWolframRuleModel}
    connections::Array{Int,1} # which cells are in my neighborhood?

    # constructor -
    MySimpleOneDimensionalAgentModel() = new();
end

mutable struct MyOneDimensionalPeriodicGridWorld <: AbstractWorldModel
    
    # data -
    states::Dict{Int, Int}
    width::Int

    # constructor -
    MyOneDimensionalPeriodicGridWorld() = new();
end

mutable struct MyTwoDimensionalFixedBoundaryGridWorld <: AbstractWorldModel
    
    # data -
    states::Dict{Int, Tuple{Int, Int}}
    coordinates::Dict{Tuple{Int, Int}, Int}
    width::Int
    height::Int

    # constructor -
    MyTwoDimensionalFixedBoundaryGridWorld() = new();
end
