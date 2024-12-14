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


function build(modeltype::Type{MyElementaryWolframRuleModel}, data::NamedTuple)::MyElementaryWolframRuleModel

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

function build(modeltype::Type{MySimpleOneDimensionalAgentModel}, world::MyOneDimensionalPeriodicGridWorld,
    data::NamedTuple)::MySimpleOneDimensionalAgentModel
    
    # create and empty instance. We'll fill this in with the data that we have
    model = modeltype();

    # get the data required to build the model
    width = world.width; # width of the world
    index = data.index; # index of the agent
    rule = data.rule; # rule model
    radius = rule.radius; # radius of the rule model
    number_of_flanks = range(1, stop = radius, step = 1) |> collect |> x-> median(x) - 1 |> Int64; # how many flanks do we have?

    # compute the connections -
    connections = nothing;
    if (index - number_of_flanks ≤ 0) # this is the start of the world
    
        left_flank = range((width + (index - number_of_flanks)), stop = width, step = 1) |> collect;
        right_flank = range(1, stop = (index + number_of_flanks), step = 1) |> collect;
        connections = vcat(left_flank, right_flank);

    elseif (index + number_of_flanks > width) # this is the end of the world    
    
        left_flank = range((index - number_of_flanks), stop = width, step = 1) |> collect;
        right_flank = range(1, stop = (index + number_of_flanks - width), step = 1) |> collect;
        connections = vcat(left_flank, right_flank);

    else # this is the interior of the world
        connections = range((index - number_of_flanks), stop = (index + number_of_flanks), step = 1) |> collect;
    end

    # set the data on the object
    model.index = index;
    model.rule = rule;
    model.connections = connections;

    # return
    return model;
end

function build(modeltype::Type{MyOneDimensionalPeriodicGridWorld}, data::NamedTuple)::MyOneDimensionalPeriodicGridWorld
    
    # initialize -
    width = data.width # 1d world with 1 agent per grid cell

    # create instance, and storage for the model components that we are going to build
    model = modeltype();
    states = Dict{Int, Int}();
    for i ∈ 1:width
        states[i] = i;
    end

    # set the data on the object
    model.states = states;
    model.width = width;

    # return
    return model;
end