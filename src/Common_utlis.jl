"""
	getGhostMPIVecs(y::MPIVector{T, I}) where {T, I}
   
	这里必须注明类型以稳定计算。
TBW
"""
function getGhostMPIVecs(y::MPIVector{T, I}) where {T, I}
	sparsevec(y.ghostindices[1], y.ghostdata)::SparseVector{T, Int}
end


function sortedVecInUnitRange(y::AbstractVector, ur::UnitRange)
	!issorted(y) && sort!(y)
	if (first(y) >= first(ur)) && (last(y) <= last(ur))
		return true
	else
		return false
	end
end