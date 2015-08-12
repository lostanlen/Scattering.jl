using Base.Test
import WaveletScattering: Morlet1DSpec, bandwidths, centerfrequencies,
    default_ɛ, qualityfactors, scales, uncertainty

numerictypes = [Float16, Float32, Float64,
                Complex{Float16}, Complex{Float32}, Complex{Float64}]

# Morlet1DSpec default options
for T in numerictypes
  # ordinary defaults, user-specified nOctaves
  spec = Morlet1DSpec(T, nOctaves=8)
  @test_approx_eq spec.ɛ default_ɛ(T)
  @test spec.log2_size == (15,)
  @test_approx_eq spec.max_qualityfactor 1.0
  @test_approx_eq spec.max_scale Inf
  @test spec.nFilters_per_octave == 1
  @test spec.nOctaves == 8
  # nFilters_per_octave defaults to max_qualityfactor when it is provided
  spec = Morlet1DSpec(max_qualityfactor=8)
  @test spec.nFilters_per_octave == 8
  @test spec.nOctaves == 10
  # max_qualityfactor defaults to nFilters_per_octave when it is provided
  spec = Morlet1DSpec(nFilters_per_octave=12)
  @test_approx_eq spec.max_qualityfactor 12.0
  @test spec.nOctaves == 9
end

# Zero-argument constructor
spec = Morlet1DSpec()
@test spec.signaltype == Float32
@test spec.nOctaves == spec.log2_size[1] - 3

nfos = [1, 2, 4, 8, 12, 16, 24, 32]
for nfo in nfos
    spec = Morlet1DSpec(nFilters_per_octave=nfo)
    ξs = centerfrequencies(spec)
    if nfo==1
        @test_approx_eq ξs[1] 0.39
    else
        @test_approx_eq (ξs[1]-ξs[2]) (1.0 - 2*ξs[1])
    end
end
