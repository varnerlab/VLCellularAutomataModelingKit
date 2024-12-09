function _build(modeltype::Type{T}, data::NamedTuple) where T <: Union{AbstractWorldModel, AbstractPolicyModel, AbstractLearningModel}
    
    # build an empty model
    model = modeltype();

    # if we have options, add them to the contract model -
    if (isempty(data) == false)
        for key ∈ fieldnames(modeltype)
            
            # check the for the key - if we have it, then grab this value
            value = nothing
            if (haskey(data, key) == true)
                # get the value -
                value = data[key]
            end

            # set -
            setproperty!(model, key, value)
        end
    end
 
    # return -
    return model
end

"""
    function build(modeltype::Type{MyOneDimensionalElementarWolframRuleModel}, data::NamedTuple) -> MyOneDimensionalElementarWolframRuleModel

This `build` method constructs an instance of the [`MyOneDimensionalElementarWolframRuleModel`](@ref) type using the data in a [NamedTuple](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple).

### Arguments
- `modeltype::Type{MyOneDimensionalElementarWolframRuleModel}`: The type of model to build, in this case, the [`MyOneDimensionalElementarWolframRuleModel`](@ref) type.
- `data::NamedTuple`: The data to use to build the model.

The `data::NamedTuple` must contain the following `keys`:
- `index::Int64`: The index of the Wolfram rule
- `colors::Int64`: The number of colors in the rule
- `radius::Int64`: The radius, i.e., the number of cells to consider in the rule

### Return
This function returns a populated instance of the [`MyOneDimensionalElementarWolframRuleModel`](@ref) type.
"""
function build(modeltype::Type{MyOneDimensionalElementarWolframRuleModel}, 
    data::NamedTuple)::MyOneDimensionalElementarWolframRuleModel

    # initialize -
    index = data.index;
    colors = data.colors;
    radius = data.radius;

    # create an empty model instance -
    model = modeltype();
    rule = Dict{Int,Int}();

    # build the rule -
    number_of_states = colors^radius;
    states = digits(index, base=colors, pad=number_of_states);
    for i ∈ 0:number_of_states-1
        rule[i] = states[i+1];
    end
    
    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.radius = radius;
    model.colors = colors;

    # return
    return model;
end

function build(modeltype::Type{MyOneDimensionalTotalisticWolframRuleModel}, 
    data::NamedTuple)::MyOneDimensionalTotalisticWolframRuleModel


    # initialize -
    index = data.index;
    levels = data.colors;
    radius = data.radius;

    # create instance, and storage for the model components that we are going to build
    model = modeltype();
    Q = Dict{Float64, Int64}();
    rule = Dict{Int,Int}();

    # build the rule -
    number_of_states = range(0, stop = (levels - 1), step = (1/radius)) |> length;
    states = digits(index, base = levels, pad = number_of_states);
    for i ∈ 0:number_of_states-1
        rule[i] = states[i+1];
    end

    # setup Q -
    values = range(0.0, stop=(levels - 1), step = (1/radius));
    for i ∈ eachindex(values)
        Q[round(values[i], digits=2)] = (i - 1);
    end
    
    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.radius = radius;
    model.colors = levels;
    model.Q = Q;

    # return
    return model;
end


function build(modeltype::Type{MyTwoDimensionalElementaryWolframRuleModel}, data::NamedTuple)::MyTwoDimensionalElementaryWolframRuleModel
    
    # initialize -
    index = data.index;
    colors = data.colors;
    radius = data.radius;

    # create an empty model instance -
    model = modeltype();
    rule = Dict{Int,Int}();

    # build the rule -
    number_of_states = colors^(2*radius + 1);
    states = digits(index, base=colors, pad=number_of_states);
    for i ∈ 0:number_of_states-1
        rule[i] = states[i+1];
    end
    
    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.radius = radius;
    model.colors = colors;

    # return
    return model;
end


"""
    function build(modeltype::Type{MyTwoDimensionalTotalisticWolframRuleModel}, data::NamedTuple) -> MyTwoDimensionalTotalisticWolframRuleModel

This `build` method constructs an instance of the [`MyTwoDimensionalTotalisticWolframRuleModel`](@ref) type using the data in a [NamedTuple](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple).

### Arguments
- `modeltype::Type{MyTwoDimensionalTotalisticWolframRuleModel}`: The type of model to build.
- `data::NamedTuple`: The data to use to build the model.

The `data::NamedTuple` must contain the following `keys`:
- `index::Int64`: The index of the Wolfram rule
- `colors::Int64`: The number of colors in the rule
- `radius::Int64`: The radius, i.e., the number of neighbor cells to consider in the rule

### Return
This function returns a populated instance of the [`MyTwoDimensionalTotalisticWolframRuleModel`](@ref) type.
"""
function build(modeltype::Type{MyTwoDimensionalTotalisticWolframRuleModel}, 
    data::NamedTuple)::MyTwoDimensionalTotalisticWolframRuleModel
    
    # initialize -
    index = data.index;
    levels = data.colors;
    radius = data.radius;

    # create instance, and storage for the model components that we are going to build
    model = modeltype();
    Q = Dict{Float64, Int64}();
    rule = Dict{Int,Int}();

    # build the rule -
    number_of_states = range(0, stop = (levels - 1), step = (1/radius)) |> length;
    states = digits(index, base = levels, pad = number_of_states);
    for i ∈ 0:number_of_states-1
        rule[i] = states[i+1];
    end

    # setup Q -
    values = range(0.0, stop=(levels - 1), step = (1/radius));
    for i ∈ eachindex(values)
        Q[round(values[i], digits=2)] = (i - 1);
    end
    
    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.radius = radius;
    model.colors = levels;
    model.neighborhoodstatesmap = Q;

    # return
    return model;
end