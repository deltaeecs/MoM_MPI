# 包的载入与相关参数设置
include(joinpath(@__DIR__, "tetra_SWG.jl"))
include(joinpath(@__DIR__, "../../src/mpi_initial.jl"))

# 运行
updateVSBFTParams!(;sbfT = sbfT, vbfT = vbfT)
include(joinpath(@__DIR__, "../MPI_test.jl"))
