# setup my paths -
const _PATH_TO_ROOT = dirname(pathof(@__MODULE__));
const _PATH_TO_BASE = joinpath(_PATH_TO_ROOT, "base");

# load external packages -
using JLD2

# load my codes -
include(joinpath(_PATH_TO_BASE, "Types.jl"));
include(joinpath(_PATH_TO_BASE, "Factory.jl"));
include(joinpath(_PATH_TO_BASE, "Solve.jl"));
