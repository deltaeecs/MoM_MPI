using MoM_Kernels:OctreeInfo


function saveOctree(octree; dir="")

    !ispath(dir) && mkpath(dir)

    data = Dict{Symbol, Any}()

    fieldsKeept = (:nLevels, :leafCubeEdgel, :bigCubeLowerCoor)

    @floop for k in fieldsKeept
        data[k] = getfield(octree, k)
    end

    nLevels = octree.nLevels
    levels = octree.levels
    kcubeIndices = nothing
    for iLevel in nLevels:-1:1
        level = levels[iLevel]
        kcubeIndices = saveLevel(level; dir=dir, kcubeIndices = kcubeIndices)
        data[:levelsname] = joinpath(dir, "Level")
    end

    jldsave(joinpath(dir, "Octree.jld2"), data = data)

end



function loadOctree(fn; comm = MPI.COMM_WORLD, rank = MPI.Comm_rank(comm), np = MPI.Comm_size(comm))

    data = load(fn, "data")

    @unpack nLevels, leafCubeEdgel, 
        bigCubeLowerCoor, levelsname = data

    levels = Dict{Int, LevelInfoMPI}()

    for i in 1:nLevels
        levels[i] = loadMPILevel(levelsname*"_$i.jld2"; comm=comm, rank=rank, np=np)
    end

    return OctreeInfo(nLevels, leafCubeEdgel, bigCubeLowerCoor, levels)
end