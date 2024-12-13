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


function build(modeltype::Type{MyElementaryWolframRuleModel}, 
    data::NamedTuple)::MyElementaryWolframRuleModel

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

function build(modeltype::Type{MyTotalisticWolframRuleModel}, 
    data::NamedTuple)::MyTotalisticWolframRuleModel
    
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

function build(modeltype::Type{MySimpleAgentModel}, 
    data::NamedTuple)::MySimpleAgentModel
    
    # initialize -
    index = data.index;
    rule = data.rule;
    connections = data.connections;

    # create instance, and storage for the model components that we are going to build
    model = modeltype();
 
    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.connections = connections;

    # return
    return model;
end