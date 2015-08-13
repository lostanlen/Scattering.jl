# Bank
abstract AbstractBank{T<:Number}
abstract AbstractNonOrientedBank{T<:Number} <: AbstractBank{T<:Number}
abstract AbstractOrientedBank{T<:Number} <: AbstractBank{T<:Number}

immutable FourierNonOriented1DBank{T<:Number} <: AbstractNonOrientedBank{T}
    ψs::Vector{AbstractFourier1DFilter{T}}
    ϕs::FourierSymmetric1DFilter{T}
    behavior::Behavior
    metas::Vector{NonOrientedMeta}
    spec::Abstract1DSpec{T}
end

"""A `Behavior` object contains the mutable information in a filter bank. The
values of these fields may be changed *after* the construction of the filter
bank, without having to recompute the underlying architecture. Fields:

* γ_range: range of wavelet indices that are actually used in the convolutions.
Default is all of them (see outer constructor).

* log2_oversampling: base-2 logarithm of the oversampling factor with respect
to the critical sampling rate 2^(-j-1). Must be positive.
Default is 0, i.e. no oversampling.

* min_log2_resolution : base-2 logarithm of the minimal undersampling factor.
Default is (-J+1), i.e. it has no effect. Set min_log2_resolution to 0 to avoid
any undersampling."""
type Behavior
    γ_range::UnitRange
    log2_oversampling::Int
    min_log2_resolution::Int
end
function Behavior(js::Vector{Int8})
    γ_range = 0:(length(js)-1)
    log2_oversampling = 0
    min_log2_resolution = -js[end] + 1
    Behavior(γ_range, log2_oversampling, min_log2_resolution)
end
