
struct Dense{M, N, BIAS, ST} <: AbstractExplicitLayer{M, N}
    σ::ST

    Dense(m, n, σ; use_bias = true) = new{m, n, use_bias, typeof(σ)}(σ)
end

function (layer::Dense)(x::AbstractArray, ps::NamedTuple)
    if usebias(layer)
        layer.σ.(ps.W * x .+ ps.b)
    else
        layer.σ.(ps.W * x)
    end
end

function (layer::Dense)(y::AbstractArray, x::AbstractArray, ps::NamedTuple)
    mul!(y, ps.W, x)
    if usebias(layer)
        add!(y, ps.b)
    end
    y .= layer.σ.(y)
end

usebias(::Dense{M, N, BIAS}) where {M, N, BIAS} = BIAS


function initialparameters(rng::AbstractRNG, backend::Backend, ::Type{T}, layer::Dense{M,N}; init::Callable = default_initializer()) where {M,N,T}
    W = KernelAbstractions.zeros(backend, T, N, M)
    b = KernelAbstractions.zeros(backend, T, N)
    init(rng, W)
    init(rng, b)
    (W = W, b = b)
end
