module VLCellularAutomataModelingKit


    # include -
    include("Include.jl");

    # export -
    export AbstractWorldModel, AbstractAgentModel, AbstractPolicyModel, AbstractLearningModel;
    export MyElementaryWolframRuleModel, MyTotalisticWolframRuleModel; # rules
    export MySimpleOneDimensionalAgentModel, MyOneDimensionalPeriodicGridWorld; # 1d
    export MySimpleTwoDimensionalAgentModel, MyTwoDimensionalFixedBoundaryGridWorld; # 2d
    export build, solve;


end # module VLCellularAutomataModelingKit
