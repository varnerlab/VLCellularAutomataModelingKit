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
    neighborhoodstatesmap::Dict{Float64, Int64}
    rule::Dict{Int,Int}

    # constructor -
    MyTotalisticWolframRuleModel() = new();
end


mutable struct MySimpleAgentModel <: AbstractAgentModel
    
    # data -
    index::Int
    rule::Union{MyElementaryWolframRuleModel, MyTotalisticWolframRuleModel}
    connections::Dict{Int, Int}

    # constructor -
    MySimpleAgentModel() = new();
end
