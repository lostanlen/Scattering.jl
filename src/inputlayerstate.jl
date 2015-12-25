immutable InputLayerState <: AbstractScatteredLayerState
    layer::InputLayer
    blobs::Vector{Mocha.Blob}
    blobs_diff::Vector{Mocha.Blob}
end

function InputLayerState(backend::Backend, layer::InputLayer)
    ranges = ntuple(k -> kthrange(layer, k), ndims(layer.data))
    blob = ScatteredBlob(Dict(Path() => Node(layer.data, ranges)))
    blobs = Mocha.Blob[blob]
    blobs_diff = Mocha.Blob[]
    return InputLayerState(layer, blobs, blobs_diff)
end

function Mocha.setup(
        backend::Mocha.Backend,
        layer::InputLayer,
        inputs::Vector{Blob},
        diffs::Vector{Blob})
    return InputLayerState(backend, layer)
end

kthrange(layer::InputLayer, k::Int) =
    (PathKey(layer.symbols[k]) => (1:1:size(layer.data, k)))
