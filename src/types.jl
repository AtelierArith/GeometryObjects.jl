mutable struct Point2D{T} <: FieldVector{2,T}
    x::T
    y::T
end

mutable struct Velocity2D{T} <: FieldVector{2,T}
    x::T
    y::T
end

struct Point3D{T} <: FieldVector{3,T}
    x::T
    y::T
    z::T
end

struct Circle2D{T}
    pt::Point2D{T}
    r::T
end

struct Circle3D{T}
    p::Point3D{T}
    r::T
end

struct Particle2D{T}
    c::Circle2D{T}
    v::Velocity2D{T}
    m::T
end

const ConcreteGeometricTypes =
    Union{Point2D,Point3D,Velocity2D,Circle2D,Circle3D,Particle2D}
const PointND = Union{Point2D,Point3D}

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Point2D}) = Point2D(rand(rng, 2))
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{Circle2D})
    Circle2D(Point2D(rand(rng, 2)), rand(rng))
end

function Random.rand(rng::AbstractRNG, ::Random.SamplerType{Velocity2D})
    v = (0.2 - 0.1) * rand(rng) + 0.1
    vy, vx = v .* sincospi(2rand(rng))
    Velocity2D(vx, vy)
end

function Random.rand(rng::AbstractRNG, ::Random.SamplerType{Particle2D})
    c = rand(rng, Circle2D)
    v = rand(rng, Velocity2D)
    m = c.r
    Particle2D(c, v, m)
end

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Point3D}) = Point3D(rand(rng, 3))
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{Circle3D})
    Circle3D(Point3D(rand(rng, 3)), rand(rng))
end
