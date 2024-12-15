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

# -- policy models below here --------------------------------------------------------------------------------------------------- #
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

function build(modeltype::Type{MyTotalisticWolframRuleModel}, data::NamedTuple)::MyTotalisticWolframRuleModel
    
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
# -- policy models above here --------------------------------------------------------------------------------------------------- #

# -- one dimensional models below here ------------------------------------------------------------------------------------------ #
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
# -- one dimensional models above here ------------------------------------------------------------------------------------------ #

# -- two dimensional models below here ------------------------------------------------------------------------------------------ #
function build(modeltype::Type{MySimpleTwoDimensionalAgentModel}, world::MyTwoDimensionalFixedBoundaryGridWorld, data::NamedTuple)::MySimpleTwoDimensionalAgentModel
    
    # create and empty instance. We'll fill this in with the data that we have
    model = modeltype();
    
    # get the data required to build the model -
    width = world.width; # width of the world
    height = world.height; # height of the world
    index = data.index; # index of the agent
    radius = data.rule.radius; # rule model
    myposition = world.states[index]; # what is my position in the world?

    coordinates = world.coordinates; # coordinates of the world

    # setup the moves - 
    moves = Dict{Int, Tuple{Int,Int}}();
    moves[1] = (-1,0); # up
    moves[2] = (1,0); # down
    moves[3] = (0,-1); # left
    moves[4] = (0,1); # right
    moves[5] = (-1,-1); # up-left
    moves[6] = (-1,1); # up-right
    moves[7] = (1,-1); # down-left
    moves[8] = (1,1); # down-right

    # check: radius can only be 4 or 8, or custom connections
    connections = nothing;
    if radius == 4 || radius == 8
        connections = Array{Int,1}(undef, radius); # setup the connections - which cells are in my neighborhood?
        
        # setup the connections -
        for i ∈ 1:radius
            Δ = moves[i]; # get the move 
            newposition = myposition .+ Δ; # new position

            if (haskey(coordinates, newposition) == true)
                newindex = world.coordinates[newposition]; # what is the index of this new position?
                connections[i] = newindex; # set the connection 
            else
                connections[i] = -1; # set the connection to -1
            end
        end

    else
        throw(ArgumentError("Automatic neighborhood generation is supported for radius = {4 | 8}. Otherwise, specify the connections manually."))
    end

    # set data on the model -
    model.index = index;
    model.rule = rule;
    model.connections = connections;

    # return
    return model;
end

function build(modeltype::Type{MyTwoDimensionalFixedBoundaryGridWorld}, data::NamedTuple)::MyTwoDimensionalFixedBoundaryGridWorld
    
    # initialize -
    model = modeltype();
    states = Dict{Int, Tuple{Int,Int}}()
    coordinates = Dict{Tuple{Int,Int},Int}()

    # get stuff from the data
    width = data.width;
    height = data.height;

    # build all the stuff 
    position_index = 1;
    for i ∈ 1:height # rows
        for j ∈ 1:width # cols
            
            # capture this corrdinate information -
            coordinate = (i,j);
            states[position_index] = coordinate;
            coordinates[coordinate] = position_index;

            # update position_index -
            position_index += 1;
        end
    end

    # set the data on the model -
    model.width = width;
    model.height = height;
    model.states = states;
    model.coordinates = coordinates;

    # return
    return model;
end
# -- two dimensional models above here ------------------------------------------------------------------------------------------ #
