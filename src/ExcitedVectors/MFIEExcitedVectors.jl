using MoM_Kernels:excitationVectorMFIE, excitationVectorMFIE!

"""
计算平面波在 RWG 基函数上的激励向量
输入：
source          ::ST, 波源
geosInfo        ::Vector{TriangleInfo{IT, FT}}，保存三角形信息的向量
nbf             ::Integer，基函数数目
"""
function MoM_Kernels.excitationVectorMFIE!(V::MPIVector, source::ST, geosInfo::SparseVector{GT, Int}, sbfType = VSBFTypes.sbfType) where{ST<:ExcitingSources, GT<:TriangleInfo}
    
    nt  =   length(geosInfo.nzval)
    # V 在本rank的区间
    Vindices =  V.indices[1]
    pmeter  =   Progress(nt; desc = "V on rank $(V.myrank)...", dt = 1, barglyphs=BarGlyphs("[=> ]"), color = :blue, enabled = true)
    # 开始对四面体形循环计算
    for geo in geosInfo.nzval
        next!(pmeter)
        # geo.inBfsID 全不在本区间则跳过
        all(x -> !(x in Vindices), geo.inBfsID) && continue
        # 三角形相关激励向量
        Vgeo    =   excitationVectorMFIE(source, geo, sbfType)
        # 写入结果
        for ni in 1:3
            n = geo.inBfsID[ni]
            # 跳过半基函数
            (n == 0) && continue
            geo.inBfsID[ni] in Vindices && begin
                V[n] += Vgeo[ni]
            end
        end
    end # for geo

    nothing
end #for function