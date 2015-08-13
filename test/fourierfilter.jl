using Base.Test
import WaveletScattering: AbstractFourier1DFilter, Vanishing1DFilter

log2_length = 3
first = -2
last = 3
y = 1 .<< collect(0:(last-first))
ψ = AbstractFourier1DFilter(y, first, last, log2_length)
@test isa(ψ, Vanishing1DFilter)
@test ψ.coan.neg == [1, 2]
@test ψ.coan.neglast == -2
@test ψ.an.pos == [8, 16, 32]
@test ψ.an.posfirst == 1

first = -2
last = 6
y = 1 .<< collect(0:(last-first))
ψ = AbstractFourier1DFilter(y, first, last, log2_length)
