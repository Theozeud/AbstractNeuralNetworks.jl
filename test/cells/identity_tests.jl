using AbstractNeuralNetworks
using Test
using Random

c = IdentityCell()
p = initialparameters(Random.default_rng(), c, Float64)

x = [4,5]
st = [1,2,3]

@test c(x, st, p) == (x, st)
