module VLCellularAutomataModelingKit


    # include -
    include("Include.jl");

    # export -
    export AbstractWorldModel, AbstractAgentModel, AbstractPolicyModel, AbstractLearningModel;
    export MyElementaryWolframRuleModel, MyTotalisticWolframRuleModel, MySimpleOneDimensionalAgentModel, MyOneDimensionalPeriodicGridWorld;
    export build, solve;


end # module VLCellularAutomataModelingKit
