
function _execute(agent::MySimpleOneDimensionalAgentModel, frame::Array{Int64,2}, time::Int64)::Int64

    # get the data -
    connections = agent.connections; # what are the connections of the agent? (neighborhood)
    rulemodel = agent.rule; # what is the rule model of the agent?
    radius = rulemodel.radius; # what is the radius of the rule model?
    number_of_colors = rulemodel.colors; # what is the number of colors in the rule model?

    tmp = Array{Int64,1}(undef, radius); # initialize the neighborhood
    for i ∈ 1:radius
        tmp[i] = frame[time, connections[i]]; # get the neighborhood
    end

    # not clever ... but it works
    index = nothing;
    if rulemodel isa MyElementaryWolframRuleModel
        index = parse(Int, join(tmp), base = number_of_colors);
    elseif rulemodel isa MyTotalisticWolframRuleModel
        Q = rulemodel.neighborhoodstatesmap;
        index = Q[round(mean(tmp), digits=2)]
    end
    
    # return the next state 
    return rulemodel.rule[index];
end

function _execute(agent::MySimpleTwoDimensionalAgentModel, frame::Array{Int64,2}, 
    world::MyTwoDimensionalFixedBoundaryGridWorld)::Int64

    # get the data -
    connections = agent.connections; # what are the connections of the agent? (neighborhood)
    rulemodel = agent.rule; # what is the rule model of the agent?
    radius = rulemodel.radius; # what is the radius of the rule model?
    number_of_colors = rulemodel.colors; # what is the number of colors in the rule model?
    states = world.states; # states of the world

    tmp = Array{Int64,1}(undef, radius); # initialize the neighborhood
    for i ∈ 1:radius
        j = connections[i]; # get the connection (this is a linear index)
        position = states[j]; # get the position of the connection
        tmp[i] = frame[position[1], position[2]]; # get the value of the connection
    end

    # not clever ... but it works
    index = nothing;
    if rulemodel isa MyElementaryWolframRuleModel
        index = parse(Int, join(tmp), base = number_of_colors);
    elseif rulemodel isa MyTotalisticWolframRuleModel
        Q = rulemodel.neighborhoodstatesmap;  
        index = Q[round(mean(tmp), digits=2)]
    end
    
    # return the next state 
    return rulemodel.rule[index];
end

function _solve(agents::Array{MySimpleOneDimensionalAgentModel,1}, world::MyOneDimensionalPeriodicGridWorld;
    initial::Array{Int,2} = Array{Int,2}(), steps::Int=100, verbose::Bool=false, 
    exclude::Union{Nothing, Set{Int64}} = nothing)::Dict{Int, Array{Int,2}}

    # initialize -
    frames = Dict{Int, Array{Int, 2}}(); # storage for the simulation frames
    frames[1] = copy(initial); # initial frame

    # check: is the exclusion list defined?
    if (exclude === nothing)
        exclude = Set{Int64}(); # initialize the exclusion list to empty if not defined
    end

    # iterate over time -
    for t ∈ 2:steps
        
        # initialize -
        frame = copy(frames[t-1]); # get the frame from the previous step
        
        # iterate over the agents -
        for i ∈ eachindex(agents) # for each agent

            # check: is the agent in the exclusion list?
            if (i ∈ exclude == false)
                
                # this agent can be updated -
                # get the agent, and data from the agent
                agent = agents[i]; # which agent are we dealing with?
            
                # compute the new state for this agent -
                frame[t,i] = _execute(agent, frame, t - 1); # update the state of the agent
            else
                
                # this agent cannot be updated -
                frame[t,i] = frame[t-1,i]; # keep the state of the agent the same
            end
        end
        
        # store the frame -
        frames[t] = frame; # store the frame
    end

    # return -
    return frames;
end

function _solve(agents::Array{MySimpleTwoDimensionalAgentModel,1}, world::MyTwoDimensionalFixedBoundaryGridWorld;
    initial::Array{Int,2} = Array{Int,2}(), steps::Int=100, verbose::Bool=false, 
    exclude::Union{Nothing, Set{Tuple{Int64,Int64}}} = nothing)::Dict{Int, Array{Int,2}}

    # initialize -
    frames = Dict{Int, Array{Int, 2}}(); # storage for the simulation frames
    frames[1] = copy(initial); # initial frame
    width = world.width; # width of the world
    height = world.height; # height of the world
    states = world.states; # states of the world
    coordinates = world.coordinates; # coordinates of the world

    # check: is the exclusion list defined?
    if (exclude === nothing)
        exclude = Set{Tuple{Int64,Int64}}(); # initialize the exclusion list to empty if not defined
    end

    # iterate over time -
    for t ∈ 2:steps
        
        # initialize -
        current_frame = copy(frames[t-1]); # get the frame from the previous step
        next_frame = copy(current_frame);
        
        for row ∈ 2:(height-1)
            for col ∈ (2:width-1)

                coordinate = (row, col);
                if (true)
                    @show (coordinate ∈ exclude == false)
                    agent_index = coordinates[coordinate];
                    next_state = _execute(agents[agent_index], current_frame, world);
                    next_frame[row, col] = next_state;
                else
                    next_frame[row, col] = current_frame[row, col];
                end
            end
        end
        frames[t] = next_frame; # store the frame
    end

    # return -
    return frames;
end

function solve(agents::Array{T,1}, 
    world::AbstractWorldModel; initial::Array{Int,2}=Array{Int,2}(),
    steps::Int = 100, verbose::Bool = false, exclude = nothing)::Dict{Int, Array{Int64,2}} where T<:AbstractAgentModel

    # call the appropriate function -
    return _solve(agents, world, initial = initial, steps = steps, 
        verbose = verbose, exclude = exclude);
end