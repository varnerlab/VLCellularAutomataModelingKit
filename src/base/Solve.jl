
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
    index = parse(Int, join(tmp), base = number_of_colors);

    # return the next state 
    return rulemodel.rule[index];
end

function _solve(agents::Array{MySimpleOneDimensionalAgentModel,1}, world::MyOneDimensionalPeriodicGridWorld;
    initial::Array{Int,2} = Array{Int,2}(), steps::Int=100, verbose::Bool=false)::Dict{Int, Array{Int,2}}

    # initialize -
    frames = Dict{Int, Array{Int, 2}}(); # storage for the simulation frames
    frames[0] = copy(initial); # initial frame

    # iterate over time -
    for t ∈ 1:steps
        
        # initialize -
        frame = copy(frames[t-1]); # get the frame from the previous step
        
        # iterate over the agents -
        for i ∈ eachindex(agents) # for each agent
            
            # get the agent, and data from the agent
            agent = agents[i]; # which agent are we dealing with?
            
            # compute the new state for this agent -
            frame[t,i] = _execute(agent, frame, t); # update the state of the agent
        end
        
        # store the frame -
        frames[t] = frame; # store the frame
    end

    # return -
    return frames;
end

function solve(agents::Array{T,1}, 
    world::AbstractWorldModel; initial::Array{Int,2}=Array{Int,2}(),
    steps::Int=100, verbose::Bool=false)::Dict{Int, Array{Int64,2}} where T<:AbstractAgentModel

    # call the appropriate function -
    return _solve(agents, world, initial=initial, steps=steps, verbose=verbose);
end